// Bard Quest #2.  OnSpellCastAt event of the talent scout.  Sets a flag
// on the PC if he performed in range of the talen scout and has at least
// four levels of bard.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/04/2004 jpavelch         Initial release.
//

void main( )
{
    object oPC = GetLastSpellCaster( );
    if ( !GetIsPC(oPC) ) return;

    int nSpell = GetLastSpell( );
    if ( nSpell != 411 ) return;

    if ( GetLevelByClass(CLASS_TYPE_BARD, oPC) < 4 )
        return;

    SetLocalInt( oPC, "AR_BardQuest2", TRUE );
}
