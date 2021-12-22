//::///////////////////////////////////////////////
//:: Tailoring - Check for Valid Gloves on PC
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

    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_ARMS, oPC)) == 1)
    return TRUE;

 return FALSE;
}
