/*  travel_boats

    --------
    Verbatim
    --------
    Boat transport script

    ---------
    Changelog
    ---------

    Date      Name          Reason
    ------------------------------------------------------------------
    11-07-06  Disco         Start of header
    2007-07-22  disco       Can't use the boat while in combat
    ------------------------------------------------------------------

*/
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void spawn_pirate_captain( object oPC, object oAmbush );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){


    //Get PC
    object oPC = GetPCSpeaker();

    if (  GetIsInCombat( oPC ) ){

        SendMessageToPC( oPC, "[you cannot use this boat while you are in combat!]" );
        return;
    }

    //get destination from NPC tag
    string sDestination = GetLocalString( OBJECT_SELF, "WP_destination" );
    object oWaypoint    = GetWaypointByTag( sDestination );
    int nPrice          = GetLocalInt( OBJECT_SELF, "Price" );

    //ambush along the route
    string sAmbush      = GetLocalString( OBJECT_SELF, "WP_ambush" );
    object oAmbush      = GetWaypointByTag( sAmbush );
    object oAmbushArea  = GetArea( oAmbush );

    //party script doesn't pick up DMs
    if ( GetIsDM( oPC ) ){

        AssignCommand( oPC, JumpToObject( oWaypoint, 0 ) );

        return;
    }

    //teleport if the PC has enough money
    if( GetGold( oPC ) >= nPrice ){

        //take gold
        TakeGoldFromCreature( nPrice, oPC, TRUE );

        if( GetLocalInt( oAmbushArea, "PlayerCount" ) == 0 && d10() == 1 && oAmbush != OBJECT_INVALID ){

            //start ambush convo
            DelayCommand( 1.0, ds_transport_party( oPC, sAmbush ) );
            DelayCommand( 1.0, spawn_pirate_captain( oPC, oAmbush ) );

            //debug
            SendMessageToAllDMs( GetName(oPC)+"'s party attacked on trip to "+GetName( GetArea( oWaypoint ) ) );
            return;

        }
        else{
            //start transport convo
            if ( GetLocalInt( oPC, "tester" ) == 1 ){

                SendMessageToPC( oPC,  "Jumping to "+GetName( GetArea( oWaypoint ) ) );
            }

            DelayCommand( 1.0, ds_transport_party( oPC, sDestination ) );
            return;
        }
    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void spawn_pirate_captain( object oPC, object oAmbush ){

    object oSpawnpoint     = GetNearestObjectByTag( "ds_spawn_captain", oAmbush );
    location lSpawnpoint   = GetLocation( oSpawnpoint );
    object oBoss           = ds_spawn_critter( oPC, "ds_piratecaptain", lSpawnpoint );

    //set to commoner
    ChangeToStandardFaction( oBoss , STANDARD_FACTION_COMMONER );

}
