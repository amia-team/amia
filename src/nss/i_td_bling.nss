//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_td_bling
//group:   Bling spawner wizardry stuff
//used as: activation script
//date:    20080930
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_nwnx_events"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

int GetPLCsSpawned( object oItem ){

    string sTag = "bling_"+ObjectToString( oItem );
    int n=0;
    object oPLC = GetObjectByTag( sTag, n );
    int nCount = 0;
    while( GetIsObjectValid( oPLC ) ){

        nCount++;

        oPLC = GetObjectByTag( sTag, ++n );
    }

    return nCount;
}


float GetAngle( location lOrigin, location lTarget ){

    vector v1 = GetPositionFromLocation(lOrigin);
    vector v2 = GetPositionFromLocation(lTarget);
    return VectorToAngle(v2 - v1);
}

void main( ){

        //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            // item activate variables
            object oPC       = InstantGetItemActivator();
            object oItem     = InstantGetItemActivated();
            object oTarget   = InstantGetItemActivatedTarget();
            location lTarget = InstantGetItemActivatedTargetLocation();

            if( GetIsObjectValid( oTarget ) )
                lTarget = GetLocation( oTarget );
            else
                lTarget = Location( GetArea( oPC ), GetPositionFromLocation( lTarget ), GetAngle( lTarget, GetLocation( oPC ) ) );

            SetLocalString( oPC, "ds_action", "td_bling" );
            SetLocalObject( oPC, "ds_target", oItem );
            SetLocalLocation( oPC, "ds_target", lTarget );
            SetLocalInt( oPC, "ds_section", 0 );

            int nPlcs = GetPLCsSpawned( oItem );
            SetLocalInt( oPC, "ds_check_1", nPlcs < 10 );
            SendMessageToPC( oPC, "You got " + IntToString( nPlcs ) + " PLCs spawned!");
            AssignCommand( oPC, ActionStartConversation( oPC, "td_bling", TRUE, FALSE ) );

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

