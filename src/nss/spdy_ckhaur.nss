// Speedy Messenger Quest.  Conversation conditional to see if PC is eligible
// for quest based on XP and has the parcel for Haur.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/25/2003 jpavelch         Initial release.
//

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return ( GetXP(oPC) <= 3000
            && GetIsObjectValid(GetItemPossessedBy(oPC, "parcelhaur")) );
}
