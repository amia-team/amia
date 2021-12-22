//::///////////////////////////////////////////////
//:: FileName ck_hassymbol
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 30/08/2005 18:01:56
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "SymbolofEilistraee"))
        return FALSE;

    return TRUE;
}
