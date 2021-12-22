//::///////////////////////////////////////////////
//:: FileName ck_gargshape
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 20/03/2005 16:38:12
//:: Modified On: 08/01/2018 10:58:00 - Hrothmus - modified to check for dragon shape
//:://////////////////////////////////////////////
int StartingConditional()
{

    // Restrict based on Shifter feat, Epic Gargantuan Shape
    int iPassed = 0;
    if(GetHasFeat(1244 , GetPCSpeaker()))
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    return TRUE;
}
