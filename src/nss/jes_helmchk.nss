int StartingConditional()
{
    object oPC    = GetPCSpeaker();
    object oHelmet = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);

    if(GetIsObjectValid(oHelmet) == 1)
    return TRUE;

 return FALSE;
}
