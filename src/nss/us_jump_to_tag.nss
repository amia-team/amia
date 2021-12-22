/*  us_jump_to_tag

--------
Verbatim
--------
Jumps user to waypoint GetTag(OBJECT_SELF)

---------
Changelog
---------
"open" determines if this PLC is a locked one and the event OnOpen.

Date        Name        Reason
------------------------------------------------------------------
2007-01-25  Disco       Start of header
2007-11-07  Disco       Can also be used as a convo action
2007-11-15  Disco       Takes messages as well
2008-01-31  Disco       Unfucked previous bollock scripting
2008-03-22  Disco       Added VFX flag
2008-09-22  Disco       Added module flag
2008-10-22  Disco       Added gold flag
2009-06-10  Disco       Added tag override via local string
2014-04-19  Glim        Added support for Climb Checks and Falling
2014-10-20  Glim        Added support for racial restricted use.
2015-09-29  PoS         Polymorphed PCs aren't screwed by this script now
------------------------------------------------------------------

*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_porting"

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void DoTransition( object oPC, object oTarget, string sMessage, int nOpen );

void MoveAssociates( object oPC, object oTarget );

void ClimbCheck( object oPC, object oTarget, string sMessage, int nOpen, object oPLC );

int IsBanned( object oPC, object oObject );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------


void main(){

    object oPC;
    string sTag     = GetLocalString( OBJECT_SELF, "tag" );

    if ( sTag == "" ){

        sTag = GetTag( OBJECT_SELF );
    }

    object oTarget  = GetWaypointByTag( sTag );
    int nOpen       = 0;
    int nTesting    = GetLocalInt( OBJECT_SELF, "testing" );
    int nGold       = GetLocalInt( OBJECT_SELF, "gold" );
    string sKey     = GetLocalString( OBJECT_SELF, "ds_key" );
    string sMessage = GetLocalString( OBJECT_SELF, "ds_message" );


    if ( GetObjectType( OBJECT_SELF ) == OBJECT_TYPE_CREATURE ){

        oPC   = GetPCSpeaker();
    }
    else{

        oPC   = GetLastUsedBy();
        nOpen = GetLocalInt( OBJECT_SELF, "open" );
    }

    //check racial banning / allowing
    if( IsBanned( oPC, OBJECT_SELF ) == TRUE )
    {
        SendMessageToPC( oPC, "Only certain races may use this object." );
        return;
    }

    if ( nGold ){

        if ( nGold > GetGold( oPC ) ){

            SendMessageToPC( oPC,  "You need more gold to use this object." );
            return;
        }
        else{

            TakeGoldFromCreature( nGold, oPC, TRUE );
        }
    }

    //check if we do a climb check or just jump straight to target
    if( GetLocalString( OBJECT_SELF, "fall_target" ) != "" )
    {
        object oPLC = OBJECT_SELF;
        AssignCommand( oPC, ClimbCheck( oPC, oTarget, sMessage, nOpen, oPLC ) );
    }
    else if ( GetLocalInt( oPC, "tester" ) == 1 ){

        SendMessageToPC( oPC,  "Jumping to area." );
        SendMessageToPC( oPC,  "Key tag: "+sKey );
        DoTransition( oPC, oTarget, sMessage, nOpen );
    }
    else if ( sKey == "" ){

        DoTransition( oPC, oTarget, sMessage, nOpen );
    }
    else if ( GetItemPossessedBy( oPC, sKey ) != OBJECT_INVALID ){

        DoTransition( oPC, oTarget, sMessage, nOpen );
    }
    else{

        SendMessageToPC( oPC, "-- You need a key or item to activate this transition --" );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


void DoTransition( object oPC, object oTarget, string sMessage, int nOpen ){

    if ( GetArea( oPC ) == GetArea( oTarget ) && GetIsPC( oPC ) ){

        MoveAssociates( oPC, oTarget );
    }


    if ( sMessage != "" ){

        SendMessageToPC( oPC,  sMessage );
    }

    if ( nOpen ){

        PlayAnimation( ANIMATION_PLACEABLE_OPEN );
        DelayCommand( 20.0, PlayAnimation( ANIMATION_PLACEABLE_CLOSE ) );
    }

    int nFX = GetLocalInt( OBJECT_SELF, "vfx" );

    if ( nFX ){

        effect ePort = EffectVisualEffect( nFX );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePort, oPC );
    }

    int nTargetModule  = GetLocalInt( OBJECT_SELF, "module" );
    int nCurrenModule  = GetLocalInt( GetModule(), "Module" );

    if ( nTargetModule > 0 && nTargetModule != nCurrenModule ){

        server_jump( oPC, GetTag( OBJECT_SELF ), 0 );
    }
    else{

        DelayCommand( 1.0, AssignCommand( oPC, ClearAllActions() ) );
        DelayCommand( 1.1, AssignCommand( oPC, JumpToObject( oTarget, 0 ) ) );
    }
}

void MoveAssociates( object oPC, object oTarget ){

    int i;
    object oAssociate;

    for ( i=1; i<6; ++i ){

        oAssociate = GetAssociate( i, oPC );

        if ( GetIsObjectValid( oAssociate ) ){

            AssignCommand( oAssociate, JumpToObject( oTarget ) );
        }
    }
}

void ClimbCheck( object oPC, object oTarget, string sMessage, int nOpen, object oPLC )
{
    string sFall = GetLocalString( oPLC, "fall_target" );
    int nDC = GetLocalInt( oPLC, "climb_DC" );
    int nFraction = GetLocalInt( oPLC, "HP_fraction" );
    int nSTR = GetAbilityModifier( ABILITY_STRENGTH, oPC );
    int nDEX = GetAbilityModifier( ABILITY_DEXTERITY, oPC );
    int nRoll = d20( 1 );
    int nCheck = nSTR + nDEX + nRoll;

    effect eDamage   = EffectDamage( ( GetMaxHitPoints( oPC ) / nFraction ) + 20, DAMAGE_TYPE_BLUDGEONING  );
    object oWaypoint = GetWaypointByTag( sFall );

    if( nCheck >= nDC )
    {
        SendMessageToPC( oPC, "Climb Check: Strength Modifier plus Dexterity Modifier "+IntToString( nSTR )+" + Roll of "+IntToString( nRoll )+" = "+IntToString( nCheck )+" versus DC "+IntToString( nDC )+": Success!" );
        DoTransition( oPC, oTarget, sMessage, nOpen );
    }
    else
    {
        ClearAllActions( TRUE );
        SpeakString( "Aaaaargh!  *You slip and fall*" );
        AssignCommand( oPC, JumpToObject( oWaypoint ) );
        SendMessageToPC( oPC, "Climb Check: Strength Modifier plus Dexterity Modifier "+IntToString( nSTR )+" + Roll of "+IntToString( nRoll )+" = "+IntToString( nCheck )+" versus DC "+IntToString( nDC )+": Failure!" );
        DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC ) );
        PlayAnimation( ANIMATION_LOOPING_DEAD_BACK, 1.0, 60.0 );
    }
}

int IsBanned( object oPC, object oObject ){

    int nRacialType     = GetRacialType(oPC);
    string sSubRace     = GetSubRace(oPC);
    int nRaceSlot       = GetLocalInt( oObject, "race_"+IntToString( nRacialType ) );

    string sType        = GetLocalString( oObject, "type" );
    string sInsignia    = GetLocalString( GetInsigniaB( oPC ), "HouseName" );
    int nBindpoint      = GetLocalInt( oObject, "ds_bindpoint" );
    object oItem        = GetItemPossessedBy( oPC, GetLocalString( oObject, "ItemName" ) );

    if(sSubRace != "")
    {
      nRaceSlot       = GetLocalInt( oObject, "race_"+sSubRace);
    }

    if( GetLocalString( oObject, "ItemName" ) != "" )
    {
        if( GetIsObjectValid( oItem ) ) {

            return FALSE;
        }
    }

    if ( nBindpoint && HasBindPoint( oPC, nBindpoint ) ){

        return FALSE;
    }

    if ( GetLocalInt( oObject, sInsignia ) == 1 ){

        return FALSE;
    }

    if ( GetLocalInt( oPC, GetTag( oObject ) ) == 1 ){

        return FALSE;
    }

    if (  nRaceSlot == 1 && sType == "ban" ){

        //not allowed to enter
        return TRUE;
    }

    if (  nRaceSlot == 0 && sType == "allow"  ){

        //not allowed to enter
        return TRUE;
    }

    return FALSE;
}
