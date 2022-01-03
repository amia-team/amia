//::///////////////////////////////////////////////
//:: Tailoring - Check for Valid Clothing on PC & Model
//:: Also check to see if clothing copying is allowed
//:: tlr_clothcheck.nss
//:://////////////////////////////////////////////
/*
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: from Mandragon's mil_tailor
//:://////////////////////////////////////////////
*/
//void main (){}
int StartingConditional()
{
    object oPC = GetPCSpeaker();

    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, oPC))
        && GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF)) == 1)
        //&& GetLocalInt(OBJECT_SELF, "Cloth_Copy")
    return TRUE;

 return FALSE;
}
