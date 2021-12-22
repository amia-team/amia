// If user saved vs fort or is immune, this shows them standing their ground
// in a conversation.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/01/12 jking            Initial Release.
//

int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "leidende_harm") != 0 ? TRUE : FALSE;
}
