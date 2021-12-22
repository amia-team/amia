// Conversation conditional to check if PC has joined the Melee Magthere
// Drow fighting academy.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/20/2003 jpavelch         Initial Release.
//

int StartingConditional( )
{
    object oToken = GetItemPossessedBy( GetPCSpeaker(), "meleemagthereins" );
    return ( GetIsObjectValid(oToken) );
}
