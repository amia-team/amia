//::///////////////////////////////////////////////
//:: FileName a13_check4nature
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 8/11/2003 6:47:00 PM
//:://////////////////////////////////////////////
int StartingConditional()
{
    if ( GetIsDM(GetPCSpeaker()) )
        return TRUE;

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 3)
        iPassed = 1;
    if((iPassed == 0) && (GetLevelByClass(CLASS_TYPE_RANGER, GetPCSpeaker()) >= 5))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
