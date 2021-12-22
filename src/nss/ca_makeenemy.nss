// Conversation action to make the PC speaker an enemy of the NPC.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/20/2004 jpavelch         Initial release.
//

void main( )
{
    object oNPC = OBJECT_SELF;
    object oPC = GetPCSpeaker( );

    SetIsTemporaryEnemy( oPC, oNPC );
}
