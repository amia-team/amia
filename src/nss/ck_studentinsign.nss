//::///////////////////////////////////////////////
//:: FileName ck_studentinsign
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 4/13/2005 8:19:09 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "studentinsignia"))
        return FALSE;

    return TRUE;
}
