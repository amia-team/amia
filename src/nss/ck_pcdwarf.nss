// Conversation conditional to check if PC speaker race is Dwarf.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/10/2003 Artos            First recorded version.
//
int StartingConditional()
{
    return ( GetRacialType(GetPCSpeaker()) == RACIAL_TYPE_DWARF );
}
