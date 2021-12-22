// Conversation action to give an Arelith scribe to a PC.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 12/29/2003 jpavelch         Initial release.
//

void main( )
{
    object oPC = GetPCSpeaker( );

    TakeGoldFromCreature( 1, oPC, TRUE );
    CreateItemOnObject( "theamianrecord", oPC );
}
