// Conversation action to give the PC 200 gold.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/26/2003 Artos            Initial Release.
//

void main( )
{
    // Give the speaker some gold
    GiveGoldToCreature( GetPCSpeaker(), 200 );
}
