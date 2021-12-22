// Conversation conditional to check if PC has less than 3,000 XP.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/01/2003 Artos            Initial release.
//

int StartingConditional( )
{
    object oPC = GetPCSpeaker( );
    return ( GetXP(oPC) <= 3000 );
}
