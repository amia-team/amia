//::///////////////////////////////////////////////
//:: FileName ck_hasgoblinform
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 05/03/2005 21:01:58
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "goblinform"))
        return FALSE;

    return TRUE;
}
