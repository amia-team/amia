// Makes targets/dummies not attack.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/15/2004 jpavelch         Initial release.
//

void main( )
{
    object oPC = GetLastAttacker( );
    SetIsTemporaryFriend( oPC, OBJECT_SELF, FALSE, 0.001 );
    DelayCommand( 0.001, SetIsTemporaryEnemy(oPC) );
}
