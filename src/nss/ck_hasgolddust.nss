//::///////////////////////////////////////////////
//:: FileName ck_hasblackroot
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 5/9/2004 1:47:51 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "GoldDust"))
        return FALSE;

    return TRUE;
}
