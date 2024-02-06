///////////////////////////////////////////////////////
/*      Lord-Jyssev Convo Actions Taken Script

  This script will allow you to use Script Params in
  the dialogue window to take actions from the convo.

  To use it, add this to every instance of an "Actions
  taken" and be sure to set Script Params from the
  following list of options:

  - GoldCost       (Amount of gold to take from PC)
  - TakeItem       (Item tag to take from PC)
  - GiveXP         (XP to give to PC, can be negative)
  - GiveItem       (Item tag to give to PC)
                                                     */
///////////////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();

    int nGoldCost = StringToInt(GetScriptParam("GoldCost"));
    string sTakeItem = GetScriptParam("TakeItem");

    int nGiveGold = StringToInt(GetScriptParam("GiveGold"));
    string sGiveItem = GetScriptParam("GiveItem");
//    int nGiveFeat = StringToInt(GetScriptParam("GiveFeat"));            //Not yet implemented
    int nGiveXP = StringToInt(GetScriptParam("GiveXP"));

    if(nGoldCost != 0)
    {

        if(GetGold(oPC) < nGoldCost) //Failsafe for if the PC drops gold during the conversation
        {
            SendMessageToPC(oPC,"You don't have enough gold.");
            return;
        }
        else
        {
            TakeGoldFromCreature(nGoldCost, oPC, TRUE);
        }
    }
    if(sTakeItem != "")
    {
        if(GetIsObjectValid(GetItemPossessedBy(oPC, sTakeItem))) //Failsafe for if the PC drops the item during the conversation
        {
            SendMessageToPC(oPC,"You don't have the required item.");
            return;
        }
        else
        {
            ActionTakeItem(GetItemPossessedBy(oPC, sTakeItem), oPC);
        }
    }
    if(nGiveGold != 0)
    {
        GiveGoldToCreature(oPC, nGiveGold);
    }
    if(sGiveItem != "")
    {
        CreateItemOnObject(sGiveItem, oPC, 1);
    }
    if(nGiveXP != 0)
    {
        GiveXPToCreature(oPC, nGiveXP);
    }
    return;
}
