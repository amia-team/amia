// Conversation action to climb the rickety ladder in the caverns below
// Mirmar Bridge.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/30/2003 jpavelch         Initial Release.
//

void main( )
{
    object oPC = GetPCSpeaker( );
    object oDest = GetWaypointByTag( "pass2cabin" );

    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, ActionJumpToLocation( GetLocation(oDest)) );
}
