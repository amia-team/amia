/*  travel_coaches

    --------
    Verbatim
    --------
    Amian Carts transport script

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    07-28-06    Disco       Start of header
    11-10-06    Disco       Fix
    11-20-06    Disco       Removed level restrictions
    2007-07-22  disco       Can't use the cart while in combat
    ------------------------------------------------------------------


*/
#include "fw_include"

void main(){

    //Get PC
    object oPC = GetPCSpeaker();

    //--------------------------------------------------------------------------
    //anti combat bit
    //--------------------------------------------------------------------------
    if (  GetIsInCombat( oPC ) ){

        SendMessageToPC( oPC, "[you cannot use this cart while you are in combat!]" );
        return;

    }

    if (  GetLocalObject( OBJECT_SELF, "CurrentSpeaker" ) != oPC
          && GetIsObjectValid( GetLocalObject( OBJECT_SELF, "CurrentSpeaker" ) ) ){

        SendMessageToPC( oPC, "[the cart driver is already helping someone else!]" );
        return;

    }

    SetLocalObject( OBJECT_SELF, "CurrentSpeaker", oPC );

    DelayCommand( 15.0, DeleteLocalObject( OBJECT_SELF, "CurrentSpeaker" ) );

    //--------------------------------------------------------------------------
    //variables
    //--------------------------------------------------------------------------
    //get destination from NPC tag
    string sDestination = GetLocalString( OBJECT_SELF, "WP_destination" );
    object oWaypoint    = GetWaypointByTag( sDestination );
    // lets try to spawn the area, if it doesn't exist.
    //fw_spawnInstance(OBJECT_SELF);
    //ambush along the route
   // string sAmbush      = GetLocalString( OBJECT_SELF, "WP_ambush" );
    //object oAmbush      = GetWaypointByTag( sAmbush );
    //object oAmbushArea  = GetArea( oAmbush );
    //int nPlayerCount    = GetLocalInt( oAmbushArea, "PlayerCount" );
    //Disabling the Ambushed Mechanic for now
    //int nAmbushed = 10;
    //int nAmbushed       = d10();


    //--------------------------------------------------------------------------
    //DM avatar support
    //--------------------------------------------------------------------------
    if ( GetIsDM( oPC ) ){

        AssignCommand( oPC, JumpToObject( oWaypoint ) );

        return;
    }

    //--------------------------------------------------------------------------
    //party_trigger support
    //--------------------------------------------------------------------------
    object oTrigger     = GetLocalObject( OBJECT_SELF, "party_trigger" );

    if ( oTrigger == OBJECT_INVALID ){

        oTrigger = GetNearestObjectByTag( "party_trigger" );
    }

    if ( oTrigger == OBJECT_INVALID ){

        SendMessageToPC( oPC, "[Error: Missing Party Trigger!]" );
        return;

    }
    else{

        SetLocalObject( OBJECT_SELF, "party_trigger", oTrigger );
    }

    //--------------------------------------------------------------------------
    //fire teleport convos for party
    //--------------------------------------------------------------------------
    //teleport if the PC has enough money
    if( GetGold( oPC ) >= 50 ){

        //take gold
        TakeGoldFromCreature( 50, oPC, TRUE );

        object oObject      = GetFirstInPersistentObject( oTrigger );

        while ( GetIsObjectValid( oObject ) ) {

            if ( GetLocalInt( oPC, "tester" ) == 1 ){

                SendMessageToPC( oPC,  GetName( oPC )+" inside trigger." );
            }

            if ( ds_check_partymember( oPC, oObject ) ) {

                if ( GetLocalInt( oPC, "tester" ) == 1 ){

                    SendMessageToPC( oPC,  GetName( oPC )+" selected for transport." );
                }

                    //start transport convo
                    FadeToBlack( oObject );
                    //DelayCommand( 1.0, AssignCommand( oObject, ActionStartConversation( oObject, "travel_normal", TRUE, FALSE ) ) );
                    DelayCommand( 1.0, AssignCommand( oObject, ExecuteScript("travel_normal", oObject) ) );
                    SetLocalObject( oObject, "ds_target", OBJECT_SELF );
            }

            oObject = GetNextInPersistentObject( oTrigger );
        }
    }
    else{
                     //Let player know that they don't have enough money
                     SendMessageToPC( oPC, "[Sadly, you don't have enough money to pay!]" );
    }
}
