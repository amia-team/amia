//::///////////////////////////////////////////////
//:: Tailoring - Check for Valid Armor on PC
//:: tlr_checkarm.nss
//:://////////////////////////////////////////////
/*
//:://////////////////////////////////////////////
//:: Created By: Jes
//:: from Mandragon's mil_tailor
//:://////////////////////////////////////////////
*/
int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC)) == 1)
    return TRUE;

 return FALSE;
}
