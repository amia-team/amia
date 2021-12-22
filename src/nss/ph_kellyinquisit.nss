//::///////////////////////////////////////////////
//:: FileName ph_kellyinquisit
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 10.09.2009 14:25:03
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "ph_InquisitorialSeal"))
        return FALSE;

    return TRUE;
}
