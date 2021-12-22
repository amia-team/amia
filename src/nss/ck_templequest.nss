//::///////////////////////////////////////////////
//:: FileName a13_cktmplqestbk
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 8/31/2003 10:02:58 PM
//:://////////////////////////////////////////////
#include "nw_i0_tool"

// Make sure the PC speaker has these items in their inventory
// and does not have more than 6k experience.
//
int StartingConditional()
{
    return ( HasItem(GetPCSpeaker(), "templequestbook") );
}
