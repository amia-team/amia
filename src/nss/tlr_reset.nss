//::///////////////////////////////////////////////
//::MIL TAILOR: reset
//::                 onconv mil_tailor
//:://////////////////////////////////////////////
/*
   read the blueprint of our clothes
   destroy clothes
   create the standard blueprint and put it on

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//:: Modified By: stacy_19201325
//:://////////////////////////////////////////////

void main()
{
    object oNext = GetFirstItemInInventory(OBJECT_SELF);
    while(GetIsObjectValid(oNext))
    {
        DestroyObject(oNext, 0.0);
        oNext = GetNextItemInInventory(OBJECT_SELF);
    }

    object oCloth = GetItemInSlot(INVENTORY_SLOT_CHEST);
    object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD);
    string sBP = "mil_clothing668";
    string sHelm = "mil_clothing669";
    object oClothing;
    object oHelmet;

    DestroyObject(oCloth);
    DestroyObject(oHelm);

    object oNew = CreateItemOnObject(sBP);
    object oNewHelm = CreateItemOnObject(sHelm);
    DelayCommand(0.5, ActionEquipItem(oNew, INVENTORY_SLOT_CHEST));
    DelayCommand(0.5, ActionEquipItem(oNewHelm, INVENTORY_SLOT_HEAD));
}
