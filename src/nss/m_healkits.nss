 /*
      June 20th 2019 - Maverick00053
      Manufacture Heal Kits Feat for the Combat Medic class.

*/




void main()
{
    object oPC = OBJECT_SELF;
    int nGold = GetGold(oPC);

    // If the PC doesnt have enough gold, generate message telling them so otherwise take gold and give healkits
    if(nGold >= 5000)
    {
      TakeGoldFromCreature(5000, oPC, TRUE);
      CreateItemOnObject("medickits", oPC, 10);
      SendMessageToPC(oPC, "Heal kits made!");
    }
    else
    {
      SendMessageToPC(oPC, "Not enough gold to buy the materials needed to manufacture the kits!");
    }

}
