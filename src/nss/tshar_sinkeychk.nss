//::///////////////////////////////////////////////
//:: FileName tshar_sinkeychk
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 6/12/2006 1:40:00 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "tshar_sinkey"))
        return FALSE;

    return TRUE;
}
