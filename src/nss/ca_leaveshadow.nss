// Conversation action to port PC out of the Shadow Realms and into the
// Cordor (Docks) Temple.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/25/2003 jpavelch         Initial release.
// 10/20/2004 jpavelch         Added check for Drow subrace.
// 12/11/2005 kfw              Disabled SEI, added compatibility for True Races
// 12/11/2007 kfw              Uses inc_ds_records
// 08/15/2020 Jes              Sends to Travel Agency instead due to EE races

#include "inc_ds_records"


void main(){

    // vars
    object oPC   = GetPCSpeaker();
    object oDest = GetWaypointByTag( "core_travelagency" );

    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, ActionJumpToObject(oDest) );
}
