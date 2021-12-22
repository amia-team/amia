//::///////////////////////////////////////////////
//:: FileName tshar_keycheck2
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 6/12/2006 1:41:40 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker dos NOT have these items in their inventory
    if(HasItem(GetPCSpeaker(), "tshar_sinkey"))
        return FALSE;

    return TRUE;
}
