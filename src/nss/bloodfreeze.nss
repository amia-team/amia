 /*
      8/20/21
      Magically makes the ranger arrows
      - Maverick00053
*/




void main()
{
    object oPC = OBJECT_SELF;
    int nGold = GetGold(oPC);

    // If the PC doesnt have enough gold, generate message telling them so otherwise take gold and give healkits
    if(nGold >= 100)
    {
      TakeGoldFromCreature(100, oPC, TRUE);
      CreateItemOnObject("bloodfreeze", oPC, 999);
      SendMessageToPC(oPC, "You forge arrows made of solid ice.");
    }
    else
    {
      SendMessageToPC(oPC, "Not enough gold!");
    }

}
