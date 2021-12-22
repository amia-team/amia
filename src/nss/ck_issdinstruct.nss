//::///////////////////////////////////////////////
//:: FileName ck_issdinstruct
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 30/04/2005 20:49:25
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Restrict based on the player's class
    int iPassed = 0;
    if(GetLevelByClass(CLASS_TYPE_SHADOWDANCER, GetPCSpeaker()) >= 10)
        iPassed = 1;
    if(iPassed == 0)
        return FALSE;

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "instructorinsignia"))
        return FALSE;

    return TRUE;
}
