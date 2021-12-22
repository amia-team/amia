// Speedy Messenger Quest.  Conversation conditional to see if PC is eligible
// for quest based on XP and has the parcel for the orphanage.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/25/2003 jpavelch         Initial release.
// 11/02/2006 bbillington      Changed the name for the new orphanage.

int StartingConditional()
{
    object oPC = GetPCSpeaker();

    return ( GetXP(oPC) <= 3000
            && GetIsObjectValid(GetItemPossessedBy(oPC, "parcelshelter")) );
}
