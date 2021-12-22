// If user failed saved vs fort, this shows them screaming in pain during
// a conversation.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/01/12 jking            Initial Release.
//

int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "leidende_harm") == 0 ? TRUE : FALSE;
}
