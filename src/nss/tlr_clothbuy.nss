//::///////////////////////////////////////////////
//:: Tailoring - Check for Valid Clothing on Model
//:: Also check to see if clothing buying is allowed
//:: tlr_clothbuy.nss
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
    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF))  == 1)
        //&& GetLocalInt(OBJECT_SELF, "Cloth_Buy")
    return TRUE;
 return FALSE;
}
