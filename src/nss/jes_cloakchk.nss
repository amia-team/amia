int StartingConditional()
{
    object oPC    = GetPCSpeaker();
    object oCloak = GetItemInSlot(INVENTORY_SLOT_CLOAK, oPC);

    if(GetIsObjectValid(oCloak) == 1)
    return TRUE;

 return FALSE;
}
