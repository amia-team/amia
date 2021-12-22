//::///////////////////////////////////////////////
//:: Tailoring - Check for Valid Weapon on NPC
//:: Also check to see if weapon buying is allowed
//:: tlr_weapbuy.nss
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
    object oModel = OBJECT_SELF;

    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oModel)) == 1)
    //&& GetLocalInt(OBJECT_SELF, "Weapon_Buy")
    return TRUE;

 return FALSE;
}
