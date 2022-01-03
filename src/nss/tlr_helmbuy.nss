//::///////////////////////////////////////////////
//:: Tailoring - Check for Valid Helmet on NPC
//:: Also check to see if helm buying is allowed
//:: tlr_helmbuy.nss
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

    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_HEAD, oModel)) == 1)
    //&& GetLocalInt(OBJECT_SELF, "Helm_Buy")
    return TRUE;

 return FALSE;
}
