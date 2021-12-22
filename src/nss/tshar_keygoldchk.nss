//::///////////////////////////////////////////////
//:: FileName tshar_keygoldchk
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 6/12/2006 1:47:17 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(GetGold(GetPCSpeaker()) <= 5000)
        return FALSE;

    return TRUE;
}
