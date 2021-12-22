// Conversation conditional to check if the PC is NOT a cleric.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/01/2004 jpavelch         Initial release.
//

int StartingConditional()
{
    object oPC = GetPCSpeaker( );

    if ( GetIsDM(oPC) )
        return FALSE;

    return ( GetLevelByClass(CLASS_TYPE_CLERIC, oPC) == 0 );
}
