// Conversation check for the drow starter quest, to check if the drow's xp is
// under 3000 and has the item for the merchant.
//
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 15/01/2005 kbillington         Initial release.


int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return ( GetXP(oPC) <= 3000
            && GetIsObjectValid(GetItemPossessedBy(oPC, "dyepots")) );
}
