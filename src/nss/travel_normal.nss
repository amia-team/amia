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
    ------------------------------------------------------------------


*/
#include "amia_include"

void main(){

    object oPC          = OBJECT_SELF;
    object oNPC         = GetLocalObject( oPC, "ds_target" );

    //get destination from PC
    string sDestination     = GetLocalString( oNPC, "WP_destination" );
    object oDest            = GetWaypointByTag( sDestination );

    //teleport to destination
    AssignCommand( oPC, JumpToObject( oDest, FALSE ) );
    FadeFromBlack( oPC );

    //cleanup
    DeleteLocalObject( oPC, "ds_target" );

}
