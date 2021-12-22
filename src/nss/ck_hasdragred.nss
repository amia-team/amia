//Kamina 28/07/18
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "polydragred"))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "polysdragred"))
        return FALSE;

    return TRUE;
}
