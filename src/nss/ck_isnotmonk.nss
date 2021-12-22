// Conversation conditional the checks if the PC has any levels of monk.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/04/2004 jpavelch         Initial release.
//

int StartingConditional()
{
    object oPC = GetPCSpeaker( );
    return ( GetLevelByClass(CLASS_TYPE_MONK, oPC) == 0 );
}
