///////////////////////////////////////////////////////
/*      Lord-Jyssev Convo Actions Taken Script

  This script will allow you to use Script Params in
  the dialogue window to take actions from the convo.

  To use it, add this to every instance of an "Actions
  taken" and be sure to set Script Params from the
  following list of options:

  - TakeGold       (Amount of gold to take from PC)
  - TakeItem       (Item tag to take from PC)
  - TakeDCs        (Amount of Dream Coins to take)
  - GiveXP         (XP to give to PC, can be negative)
  - GiveItem       (Item tag to give to PC)
  - GiveGold       (Amount of gold to give to PC)
  - GiveDCs        (Amount of Dream Coins to give)
                                                     */
///////////////////////////////////////////////////////

#include "inc_dc_api"
#include "inc_ds_records"

void main()
{
    object oPC = GetPCSpeaker();

    int nTakeGold = StringToInt(GetScriptParam("TakeGold"));
    int nTakeDCs = StringToInt(GetScriptParam("TakeDCs"));
    string sTakeItem = GetScriptParam("TakeItem");

    int nGiveGold = StringToInt(GetScriptParam("GiveGold"));
    int nGiveDCs = StringToInt(GetScriptParam("GiveDCs"));
    string sGiveItem = GetScriptParam("GiveItem");
//    int nGiveFeat = StringToInt(GetScriptParam("GiveFeat"));            //Not yet implemented
    int nGiveXP = StringToInt(GetScriptParam("GiveXP"));

    if(nTakeGold != 0)
    {

        if(GetGold(oPC) < nTakeGold) //Failsafe for if the PC drops gold during the conversation
        {
            SendMessageToPC(oPC,"You don't have enough gold.");
            return;
        }
        else
        {
            TakeGoldFromCreature(nTakeGold, oPC, TRUE);
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
    if(nTakeDCs != 0)
    {
        string sCDKey = GetPCPublicCDKey(oPC);
        SetDreamCoins(sCDKey, GetDreamCoins(sCDKey)-nTakeDCs);
        SendMessageToPC(oPC, "Dream Coins removed: <c§iÿ>" + IntToString(nTakeDCs) + "</c>");
    }
    if(nGiveGold != 0)
    {
        GiveGoldToCreature(oPC, nGiveGold);
    }
    if(sGiveItem != "")
    {
        object oGivenItem = CreateItemOnObject(sGiveItem, oPC, 1);
        SetIdentified(oGivenItem, 1);
    }
    if(nGiveXP != 0)
    {
        GiveXPToCreature(oPC, nGiveXP);
    }
    if(nGiveDCs != 0)
    {
        string sCDKey = GetPCPublicCDKey(oPC);
        SetDreamCoins(sCDKey, GetDreamCoins(sCDKey)+nGiveDCs);
        SendMessageToPC(oPC, "You gain <c§iÿ>" + IntToString(nGiveDCs) + "</c> Dream Coins.");
    }
    return;
}
