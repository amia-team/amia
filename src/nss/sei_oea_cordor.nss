/*  Area :: On Enter2 :: Executes with OBJECT_SELF As Player Character

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    ??????  shir'le     SEI Initial Release [Deprecated].
    011004  jpevelch    Added user-defined event call.
    013005  jking       Hook standard call.
    040205  jking       Added Connections Management.
    121005  kfw         Gutted SEI. Added True Races vulnerability handling.
    122205  kfw         Map Reveal: Checks Integer variabl: CS_MAP_REVEAL equal to 1, to unfog.
    031906  kfw         Code optimization.
    052006  kfw         Code optimization and bug fix: Improved Effect precision.
    062206  kfw         Bug fix. Bioware functions not working correctly.
    082206  kfw         Added light sensitivity support for Shadow Elf.
    010107  disco       Continued from default script, added Cordor weather and ban routines
  20070822  Disco       Added functions for testing
  20071118  Disco       Libbed
  20080325  Disco       Added guard quest
    ----------------------------------------------------------------------------

    --------
    Verbatim
    --------
    This script executes whenever a player enters an area.
    Specifically this script will check and verify any light penalties due to player characters.

*/

//-------------------------------------------------------------------------------
//Includes
//-------------------------------------------------------------------------------
#include "area_constants"
#include "inc_ds_records"
#include "ds_inc_ambience"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
// expells banned PCs
void ban_PC( object oPC, object oArea );

//sets guardquest stuff
void GuardQuest( object oPC, object oArea );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main( ){

    // Variables.
    object oArea        = OBJECT_SELF;
    object oPC          = GetEnteringObject( );

    // Bug out on non-PC
    if( !GetIsPC( oPC ) ){

        return;
    }

    //set Cordor weather
    amb_cordor( oPC, oArea );

    //manage bans
    if ( GetName( oArea ) != "Cordor: South" ){

        ban_PC( oPC, oArea );
    }

    //guard quest
    GuardQuest( oPC, oArea );

    /* Area Management. */
    db_onTransition( oPC, oArea );

    AreaHandleOnEnterEventDefault( oArea );

    return;

}


//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
void ban_PC( object oPC, object oArea ){

    //stamp PC as banned
    if ( GetLocalInt( oPC, "banned_cordor" ) != 1 ){

        return;
    }

    //trace item
    TrackItems( oArea, oPC, "Guardsman's Ban Letter",  "Expelled from Cordor" );

    //hook into travel scripts
    SetLocalString( oPC, "travel_destination", "ds_throwout_"+IntToString( d2() ) );

    //fade to black
    FadeToBlack( oPC );

    //damage
    int OrgHealth    = GetCurrentHitPoints( oPC );
    effect eDamage   = EffectDamage( ( OrgHealth /2 ), DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_NORMAL );
    DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC ) );

    //convo finishes the routine
    DelayCommand( 3.0, AssignCommand( oPC, ActionStartConversation( oPC, "travel_thrownout", TRUE, FALSE ) ) );

}

void GuardQuest( object oPC, object oArea ){

    string sCG_area         = GetLocalString( oPC, "cg_area" );
    string sCG_name         = GetLocalString( oPC, "cg_name" );
    int nCG_type            = GetLocalInt( oPC, "cg_type" );
    int nCG_status          = GetPCKEYValue( oPC, "cg_status" );

    if ( sCG_area == GetResRef( oArea ) ){

        if ( nCG_type > 0 && nCG_type < 7 && nCG_status == 1 ){

            location lCreature  = GetOppositeLocation( GetNearestObject( OBJECT_TYPE_CREATURE, oPC, 4+d4() ) );
            object oNPC         = CreateObject( OBJECT_TYPE_CREATURE, "cg_ds_criminal", lCreature, FALSE, "cg_"+GetPCPublicCDKey( oPC, TRUE ) );

            SetName( oNPC, sCG_name );

            SetPCKEYValue( oPC, "cg_status", 2 );

            //test
            //SendMessageToPC( oPC, "Test: Created NPC in "+GetName( oArea ) );
        }
    }
}


