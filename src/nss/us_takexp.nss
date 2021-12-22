// OnUsed event of a placeable to give 10,000 XP. Used for testing.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/25/2004 jpavelch         Initial release.
//

void main( )
{
    object oPC = GetLastUsedBy( );
    if ( !GetIsPC(oPC) ) return;

    int nXP = GetXP( oPC );
    SetXP( oPC, nXP - 10000 );
}
