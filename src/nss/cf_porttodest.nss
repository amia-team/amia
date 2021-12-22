// Generic script to port to a destination using a placeable.  The tag of the
// destination waypoint is stored as a local string on the object NPC as
// 'CustomFlag'.  This string was placed there by the waypoint spawn generator
// and appears in the waypoint name after CF.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/01/2003 jpavelch         Initial Release.
//


void main( )
{
    object oPC = GetLastUsedBy( );
    if ( !GetIsPC(oPC) ) return;

    string sDestTag = GetLocalString( OBJECT_SELF, "CustomFlag" );
    object oDest = GetWaypointByTag( sDestTag );

    if ( !GetIsObjectValid(oDest) ) {
        FloatingTextStringOnCreature( "Portal has invalid destination!", oPC );
        return;
    }

    AssignCommand( oPC, ClearAllActions() );
    AssignCommand( oPC, JumpToObject(oDest, FALSE) );
}
