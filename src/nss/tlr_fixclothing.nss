//::///////////////////////////////////////////////
//:: Tailoring - Fix Clothing
//:: tlr_fixclothing.nss
//:: Copyright (c) 2003 Jake E. Fitch
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jake E. Fitch (Milambus Mandragon)
//:: Created On: March 9, 2004
//-- stacy_19201325 added helmet functionality
//:://////////////////////////////////////////////
void main()
{
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
    object oHelmet = GetItemInSlot(INVENTORY_SLOT_HEAD, OBJECT_SELF);
    AssignCommand(OBJECT_SELF, ActionUnequipItem(oArmor));
    AssignCommand(OBJECT_SELF, ActionUnequipItem(oHelmet));
    DelayCommand(2.0f, AssignCommand(OBJECT_SELF, ActionEquipItem(oArmor, INVENTORY_SLOT_CHEST)));
    DelayCommand(2.0f, AssignCommand(OBJECT_SELF, ActionEquipItem(oHelmet, INVENTORY_SLOT_HEAD)));

}
