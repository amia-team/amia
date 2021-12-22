// Ports the player to the bottom of the rat-infested boat.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 08/23/2003 jpavelch         Initial Release.
//

void main()
{
    object oPC = GetPCSpeaker( );
    if ( !GetIsPC(oPC) ) return;

    object oDest = GetWaypointByTag( "wp_cordor2boat" );
    if ( GetIsObjectValid(oDest) ) {
        AssignCommand( oPC, ClearAllActions() );
        AssignCommand( oPC, ActionJumpToObject(oDest, FALSE) );
    }
}
