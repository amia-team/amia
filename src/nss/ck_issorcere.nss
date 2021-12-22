// Conversation conditional to check if PC has joined the Sorcere Drow
// mage academy.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/20/2003 jpavelch         Initial Release.
//71856

int StartingConditional( )
{
    object oToken = GetItemPossessedBy( GetPCSpeaker(), "sorcereinsignia" );
    return ( GetIsObjectValid(oToken) );
}
