//::///////////////////////////////////////////////
//:: Tailoring - Copy Cost Weapon
//:: tlr_copycostshld.nss
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: from Mandragon's mil_tailor
//:://////////////////////////////////////////////
int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int BaseCost = 10; //-- change this to raise your base prices.
    float BaseDivider = 0.2; //-- mil default

    object oNPCItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, OBJECT_SELF);
    object oPCItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);

    int iCost = FloatToInt(IntToFloat(GetGoldPieceValue(oPCItem)) * 0.2f);

    int iModifier=GetLocalInt(OBJECT_SELF, "Shield_Mod_Copy");
    int iValue=GetLocalInt(OBJECT_SELF, "Shield_Value_Copy");

    switch (iModifier)
    {
       case 0: //Variable-set price modifying is OFF
           iCost = BaseCost;
           break;

       case 1: //Variable "Value" will be used to ADD to the price
           iCost = BaseCost;
           break;

       case 2: //Variable "Value" will be used to SUBTRACT from the price
           iCost = BaseCost;
           break;

       case 3: //Variable "Value" will be used to MULTIPLY by the price
           iCost = BaseCost;
           break;

       case 4: //Variable "Value" will be used to DIVIDE by the price
           if (iValue!=0)
              iCost = BaseCost;

           else iCost = BaseCost;
           break;

      case 5: //Variable "Value" will be used to SET the price
           iCost = BaseCost;
           break;

    }

    string sOut = "Cost: " + IntToString(iCost) + " gold to copy.\n";
    sOut += "\nDo you wish to continue?";
    SetCustomToken(9883, sOut);
    //-- this is called to check if the pc has the money to buy
    SetLocalInt(OBJECT_SELF, "CURRENTPRICE", iCost);

    return TRUE;
}
