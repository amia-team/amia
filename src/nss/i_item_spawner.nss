/*
  New Item Spawner for Post EE Release

  - Maverick00053
  12/6/21

*/


void main()
{
    object oPC = GetItemActivator();
    object oWidget = GetItemActivated();
    object oTarget = GetItemActivatedTarget();
    string itemNumber = GetLocalString(oWidget,"itemNumber");
    int nSet = GetLocalInt(oWidget, "isSet");
    int nValue = GetLocalInt(oWidget,"itemValue");
    int nSpawnerCount = GetCampaignInt("itemSpawnerNumbers","itemSpawnerCount",oPC);
    location lPC = GetLocation(oPC);
    int nGoldCost = GetGoldPieceValue(oTarget);

    if(nSet == 1)
    {

       if(GetGold(oPC) >= nValue)
       {
       object oItemMade = RetrieveCampaignObject("itemSpawnerDatabase", itemNumber, lPC, oPC, oPC, TRUE);
       AssignCommand(oPC, TakeGoldFromCreature(nValue, oPC, TRUE));
       }
       else
       {
         SendMessageToPC(oPC, "Not enough gold to spawn! You need " + IntToString(nValue) + " gold to use.");
       }

    }
    else
    {
       if(GetIsObjectValid(oTarget) && (GetObjectType(oTarget) == OBJECT_TYPE_ITEM))
       {
          nSpawnerCount++;

          StoreCampaignObject("itemSpawnerDatabase",IntToString(nSpawnerCount),oTarget,oPC,TRUE);
          SetCampaignInt("itemSpawnerNumbers","itemSpawnerCount",nSpawnerCount,oPC);
          SetLocalInt(oWidget,"itemValue",nGoldCost);
          SetLocalInt(oWidget, "isSet",1);
          SetLocalString(oWidget, "itemNumber",IntToString(nSpawnerCount));
          SetName(oWidget,GetName(oTarget) + " Spawner");
          SetDescription(oWidget,GetName(oTarget) + " Spawner.");

          SendMessageToPC(oPC, "Item Spawner Set!");
       }
       else
       {
         SendMessageToPC(oPC, "Must set item spawner to an item object!");
       }
    }
}
