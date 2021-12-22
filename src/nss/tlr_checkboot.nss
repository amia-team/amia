//::///////////////////////////////////////////////
//:: Tailoring - Check for Valid Boots on PC
//:: tlr_checkhelm.nss
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

    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC)) == 1)
    return TRUE;

 return FALSE;
}
