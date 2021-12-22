//Kamina 28/07/18
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "polydragblac" ))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "polysdragblac" ))
        return FALSE;

    return TRUE;
}
