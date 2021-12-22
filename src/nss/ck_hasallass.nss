//::///////////////////////////////////////////////
//:: FileName ck_hasallass
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 29/10/2005 16:29:56
//:://////////////////////////////////////////////
#include "nw_i0_tool"

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if(!HasItem(GetPCSpeaker(), "asnobsmist"))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "asndark"))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "asninv"))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "asnimpinv"))
        return FALSE;
    if(!HasItem(GetPCSpeaker(), "asnfree"))
        return FALSE;

    return TRUE;
}
