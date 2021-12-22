void main()
{
    object oPC = OBJECT_SELF;
    int iMaterialToDye = GetLocalInt(oPC, "MaterialToDye");
    int iColor = GetLocalInt(OBJECT_SELF, "ToModify");

    object oItem = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
    if (GetIsObjectValid(oItem)) {
        // Dye the item
        object oDyedItem = CopyItemAndModify(oItem, ITEM_APPR_TYPE_ARMOR_COLOR, iMaterialToDye, iColor, TRUE);
        DestroyObject(oItem);

        // Equip the armor
       DelayCommand(0.5f, AssignCommand(oPC, ActionEquipItem(oDyedItem, INVENTORY_SLOT_CHEST)));
    }
}
