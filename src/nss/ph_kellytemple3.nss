//::///////////////////////////////////////////////
//:: FileName ph_kellytemple3
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 24.06.2009 12:24:17
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "EternalOrderTemplarHelmet"))
        return FALSE;

    return TRUE;
}
