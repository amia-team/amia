//::///////////////////////////////////////////////
//:: FileName ck_councilpapers
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 4/13/2004 7:27:14 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "councilseal"))
        return FALSE;

    return TRUE;
}
