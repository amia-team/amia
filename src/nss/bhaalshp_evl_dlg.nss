//::///////////////////////////////////////////////
//:: FileName bhaalshop_evil
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 3
//:://////////////////////////////////////////////
int StartingConditional()
{
    int iWarlockClassType = 57;

    object oCharacter = GetPCSpeaker();

    if (GetAlignmentGoodEvil(oCharacter) != ALIGNMENT_EVIL
    || GetLevelByClass(CLASS_TYPE_ASSASSIN, oCharacter) >= 1
    || GetLevelByClass(CLASS_TYPE_BLACKGUARD, oCharacter) >= 1
    || GetLevelByClass(iWarlockClassType, oCharacter) >= 1)
        return FALSE;

    return TRUE;
}
