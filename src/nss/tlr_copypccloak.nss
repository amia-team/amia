//::///////////////////////////////////////////////
//:: Tailoring - Copy the PCs Cloak
//:: tlr_copypccloak.nss
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Jes
//:: based on Mandragon's mil_tailor
//:://////////////////////////////////////////////
void main()
{
    object oPC = GetPCSpeaker();

    object oSourceCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);
    object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, OBJECT_SELF);

    int iSourceCloakValue;
    object oCurrentCloak, oNewCloak;

////// Copy Colors
    // Cloth 1
    iSourceCloakValue = GetItemAppearance(oSourceCloak, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1);
    oCurrentCloak = oCloak;
    oNewCloak = CopyItemAndModify(oCurrentCloak,ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH1, iSourceCloakValue, TRUE);
    DestroyObject(oCurrentCloak);

    // Cloth 2
    iSourceCloakValue = GetItemAppearance(oSourceCloak, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2);
    oCurrentCloak = oNewCloak;
    oNewCloak = CopyItemAndModify(oCurrentCloak,ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_CLOTH2, iSourceCloakValue, TRUE);
    DestroyObject(oCurrentCloak);

    // Leather 1
    iSourceCloakValue = GetItemAppearance(oSourceCloak, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1);
    oCurrentCloak = oNewCloak;
    oNewCloak = CopyItemAndModify(oCurrentCloak,ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER1, iSourceCloakValue, TRUE);
    DestroyObject(oCurrentCloak);

    // Leather 2
    iSourceCloakValue = GetItemAppearance(oSourceCloak, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2);
    oCurrentCloak = oNewCloak;
    oNewCloak = CopyItemAndModify(oCurrentCloak,ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_LEATHER2, iSourceCloakValue, TRUE);
    DestroyObject(oCurrentCloak);

    // Metal 1
    iSourceCloakValue = GetItemAppearance(oSourceCloak, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1);
    oCurrentCloak = oNewCloak;
    oNewCloak = CopyItemAndModify(oCurrentCloak,ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL1, iSourceCloakValue, TRUE);
    DestroyObject(oCurrentCloak);

    // Metal 2
    iSourceCloakValue = GetItemAppearance(oSourceCloak, ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2);
    oCurrentCloak = oNewCloak;
    oNewCloak = CopyItemAndModify(oCurrentCloak,ITEM_APPR_TYPE_ARMOR_COLOR, ITEM_APPR_ARMOR_COLOR_METAL2, iSourceCloakValue, TRUE);
    DestroyObject(oCurrentCloak);


////// Copy Design
    // Cloak
    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC)))
    {
    iSourceCloakValue = GetItemAppearance(oSourceCloak, ITEM_APPR_TYPE_SIMPLE_MODEL, 0);
    oCurrentCloak = oNewCloak;
    oNewCloak = CopyItemAndModify(oCurrentCloak, ITEM_APPR_TYPE_SIMPLE_MODEL, 0, iSourceCloakValue, TRUE);
    DestroyObject(oCurrentCloak);
    }

    // Equip
    if(GetIsObjectValid(GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC)))
    {
       DelayCommand(0.5f, AssignCommand(OBJECT_SELF, ActionEquipItem(oNewCloak, INVENTORY_SLOT_CLOAK)));
       SetDroppableFlag(oNewCloak,FALSE);
    }
}
