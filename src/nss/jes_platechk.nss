int StartingConditional()
{
    object oPC    = GetPCSpeaker();
    object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);

    if(GetIsObjectValid(oArmor) == 1)
    return TRUE;

 return FALSE;
}
