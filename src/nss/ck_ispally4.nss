// Conversation conditional to check if PC has at least four levels in the
// Paladin class or Cleric class.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/30/2003 jpavelch         Initial Release.
// 01/09/2005 bbillington      Modified to include the cleric class.

int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_PALADIN, GetPCSpeaker()) >= 4 && ALIGNMENT_GOOD)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_CLERIC, GetPCSpeaker()) >= 4 && ALIGNMENT_GOOD))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
