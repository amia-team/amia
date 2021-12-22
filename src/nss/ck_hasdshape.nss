//::///////////////////////////////////////////////
//:: FileName ck_hasdshape
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 20/03/2005 16:38:12
//:: Modified On: 08/01/2018 10:58:00 - Hrothmus - modified to check for dragon shape
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetHasFeat(FEAT_EPIC_WILD_SHAPE_DRAGON, GetPCSpeaker()))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
