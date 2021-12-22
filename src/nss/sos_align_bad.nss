// Check if PC is not the correct alignment to follow Loviatar
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/01/12 jking            Initial Release.
//

int StartingConditional()
{
    return GetLocalInt(GetPCSpeaker(), "loviatar_favor") == FALSE;
}
