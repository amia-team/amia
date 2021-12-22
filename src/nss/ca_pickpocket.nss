// Conversation action to pickpocket five gold from the PC.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/30/2003 jpavelch         Initial Release.
//

void main()
{
    // Remove some gold from the player
    TakeGoldFromCreature( 5, GetPCSpeaker(), TRUE );
}
