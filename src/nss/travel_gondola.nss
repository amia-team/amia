/*  travel_normal

    --------
    Verbatim
    --------
    Amian Carts transport script

    ---------
    Changelog
    ---------

    Date      Name        Reason
    ------------------------------------------------------------------
    07-28-06  Disco       Start of header
    11-10-06  Disco       Fix
  2007-03-10  Disco       jumps party
  2010-01-05  Disco       removed NPC jumping
    ------------------------------------------------------------------


*/

#include "x0_i0_position"
#include "amia_include"

void main(){

    //Get PC
    object oPC  = OBJECT_SELF;
    object oNPC = GetLocalObject( oPC, "travel_npc" );

    //get destination from NPC
    //string sSwitch           = GetLocalString( oNPC, "WP_switch" );
    //string sDestination      = GetLocalString( oNPC, "WP_destination_" + sSwitch ) ;
    string sDestination      = GetLocalString( oNPC, "WP_destination" ) ;
    object oWaypoint         = GetWaypointByTag( sDestination );
    location lWaypoint       = GetLocation( oWaypoint );

    //--------------------------------------------------------------------------
    //DM avatar support
    //--------------------------------------------------------------------------
    if ( GetIsDM( oPC ) ){

        AssignCommand( oPC, JumpToObject( oWaypoint ) );

        return;
    }

    //teleport to destination
    //AssignCommand( oNPC, JumpToLocation(lWaypoint) );

    ds_transport_party( oPC, GetTag( oWaypoint ) );

    //unfade PC and set switch
    FadeFromBlack( oPC );

    /*
    if ( sSwitch == "1" ) {

        SetLocalString( oNPC, "WP_switch", "2" );

    }
    else {

        SetLocalString( oNPC, "WP_switch", "1" );

    }
    */

    //take gold and say bye bye
    TakeGoldFromCreature( 5, oPC, TRUE );
    ActionSpeakString( "Ciao!" );
}
