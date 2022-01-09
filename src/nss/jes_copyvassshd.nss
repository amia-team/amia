//::///////////////////////////////////////////////
//:: Tailoring - Copy the PCs Outfit
//:: tlr_copypcoutfit.nss
//:: Copyright (c) 2003 Jake E. Fitch
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jake E. Fitch (Milambus Mandragon)
//:: Created On: March 8, 2004
//:://////////////////////////////////////////////

object CopyItemAppearance(object oSource, object oTarget);

void main()
{
    object oPC = GetPCSpeaker();

    object oSource = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);

    int iSourceValue;
    object oCurrent, oNew;

    // Shield
    iSourceValue = GetItemAppearance(oSource, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    oCurrent = oNew;
    oNew = CopyItemAndModify(oCurrent, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, iSourceValue, TRUE);
    DestroyObject(oCurrent);


    // Equip
    DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionEquipItem(oNew, INVENTORY_SLOT_LEFTHAND)));
    SetDroppableFlag(oNew,FALSE);
    }
