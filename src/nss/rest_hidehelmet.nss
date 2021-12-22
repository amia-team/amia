// Helmet off script attached to the playerrest menu
// 8/24/21 Maverick00053

void main()
{
    // This is the Object to apply the effect to.
    object oPC = GetPCSpeaker();
    object oHelmet = GetItemInSlot( INVENTORY_SLOT_HEAD, oPC );
    int nHelmet = 0;

    if(GetIsObjectValid(oHelmet))
    {
      nHelmet = GetHiddenWhenEquipped(oHelmet);
    }

    if((nHelmet == 0) && (GetIsObjectValid(oHelmet)))
    {
      SetHiddenWhenEquipped(oHelmet,TRUE);
      SendMessageToPC(oPC,"Helmet hide on");
    }
    else if(nHelmet == 1)
    {
      SetHiddenWhenEquipped(oHelmet,FALSE);
      SendMessageToPC(oPC,"Helmet hide off");
    }
    else
    {
      SendMessageToPC(oPC,"No helmet detected");
    }


}
