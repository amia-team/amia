// Speedy Messenger Quest.  Conversation conditional to see if PC does not
// currently possess the parcel for Igor.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/25/2003 jpavelch         Initial release.
//

int StartingConditional()
{
    return ( !GetIsObjectValid(GetItemPossessedBy(GetPCSpeaker(), "parceligor")) );
}

