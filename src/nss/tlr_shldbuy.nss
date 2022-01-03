//::///////////////////////////////////////////////
//:: Tailoring - Check for Valid Shield on NPC
//:: Also check to see if shield buying is allowed
//:: tlr_shldbuy.nss
//:://////////////////////////////////////////////
/*
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: from Mandragon's mil_tailor
//:://////////////////////////////////////////////
*/
//void main(){}
int StartingConditional()
{
    object oModel = OBJECT_SELF;

    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oModel)) == 1)
    //&& GetLocalInt(OBJECT_SELF, "Shield_Buy")
    return TRUE;

 return FALSE;
}
