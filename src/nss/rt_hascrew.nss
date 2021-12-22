//::///////////////////////////////////////////////
//Kamina 10/06/2019
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "rt_insigcrew"))
        return FALSE;

    return TRUE;
}
