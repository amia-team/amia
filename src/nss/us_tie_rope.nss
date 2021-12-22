/*
    Used with the Tie-Off PLC.
*/

// March 26, 2014   Glim    First implimentation.

void main()
{
    string sRopeTarget = GetLocalString( OBJECT_SELF, "rope_target" );
    string sCoilTarget = GetLocalString( OBJECT_SELF, "coil_target" );
    string sRope = GetLocalString( OBJECT_SELF, "rope_spawn" );
    object oRope = GetObjectByTag( sRope );
    location lRope = GetLocation( oRope );
    location lCoil = GetLocation( GetNearestObject( OBJECT_TYPE_WAYPOINT, OBJECT_SELF ) );

    int nRoped = GetLocalInt( OBJECT_SELF, "roped" );
    object oPC = GetLastUsedBy( );
    object oHemp = GetItemPossessedBy( oPC, "rope" );
    int nDestroy = 0;

    //check current status, rope (1) or no rope (0) attached
    if( nRoped == 0 )
    {
        if( GetIsObjectValid( oHemp ) )
        {
            //short loop to find the PLC to spawn the Climbing Rope at

            DestroyObject( oHemp );
            CreateObject( OBJECT_TYPE_PLACEABLE, "climbing_rope", lRope, FALSE, sRopeTarget );
            CreateObject( OBJECT_TYPE_PLACEABLE, "climbing_coil", lCoil, FALSE, sCoilTarget );
            SetName( OBJECT_SELF, "Tie-Off [with rope]" );
            SetLocalInt( OBJECT_SELF, "roped", 1 );
        }
        else
        {
            SendMessageToPC( oPC, "[you don't have any rope to tie around this]" );
        }
        return;
    }
    else
    {
        SetName( OBJECT_SELF, "Tie-Off [no rope]" );
        SetLocalInt( OBJECT_SELF, "roped", 0 );
        //start a cycle to find the PLC climbable rope we spawned before
        object oDestroy = GetObjectByTag( sRopeTarget, nDestroy );

        while( GetIsObjectValid( oDestroy ) )
        {
            if( GetObjectType( oDestroy ) == OBJECT_TYPE_PLACEABLE )
            {
                DestroyObject( oDestroy );
                break;
            }
            nDestroy = nDestroy + 1;
            oDestroy = GetObjectByTag( sRopeTarget, nDestroy );
        }
        //second cycle to destroy the PLC climbable coil we spawned before
        oDestroy = GetObjectByTag( sCoilTarget, nDestroy );

        while( GetIsObjectValid( oDestroy ) )
        {
            if( GetObjectType( oDestroy ) == OBJECT_TYPE_PLACEABLE )
            {
                DestroyObject( oDestroy );
                break;
            }
            nDestroy = nDestroy + 1;
            oDestroy = GetObjectByTag( sCoilTarget, nDestroy );
        }
        CreateItemOnObject( "rope", oPC );
        return;
    }
}
