int StartingConditional()
{
    object oPC    = GetPCSpeaker();
    object oLeft = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    if(GetIsObjectValid(oLeft) == 1)
    return TRUE;

 return FALSE;
}
