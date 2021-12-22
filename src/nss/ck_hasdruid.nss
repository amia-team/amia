//::///////////////////////////////////////////////
// Kamina 28/07/18
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = 0;
    if((GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 1) || (GetLevelByClass(CLASS_TYPE_SHIFTER, GetPCSpeaker()) >= 1))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
