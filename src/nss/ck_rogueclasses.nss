// Conversation conditional to check if PC has Rogue classes or any
// derivatives.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/24/2003 Artos            Initial release.
// 02/25/2005 bbillington      Edited so harpers are also an accepted rogue class.

int StartingConditional()
{
    object oPC = GetPCSpeaker( );

    if ( GetIsDM(oPC) )
        return TRUE;

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_ROGUE, oPC) >= 4)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_SHADOWDANCER, oPC) >= 2))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC) >= 1))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_BARD, oPC) >= 4))
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_HARPER, oPC) >= 1))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
