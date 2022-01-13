/*

   Maverick's New Item Spawner Script

*/
#include "nw_i0_tool"

void main()
{
  object oPC = GetItemActivator();
  object oWidget = GetItemActivated();
  object oTarget = GetItemActivatedTarget();
  object oSpawnedItem = GetLocalObject(oWidget,"itemspawner");
  int nGoldCost = GetLocalInt(oWidget,"itemcost");
  int nItemValue = GetGoldPieceValue(oTarget);

  if(GetIsObjectValid(oSpawnedItem))
  {
    // Make sure they have enough gold
    if(GetGold(oPC) >= nGoldCost)
    {
      CopyItem(oSpawnedItem,oPC);
      TakeGold(nGoldCost,oPC,TRUE);
      SendMessageToPC(oPC,"*Item spawned for "+IntToString(nGoldCost)+"gp.*");
    }
  }
  else if(GetIsObjectValid(oTarget))
  {
    if(GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
      SetLocalObject(oWidget,"itemspawner",oTarget);
      SendMessageToAllDMs(GetName(oPC)+" set an item spawner with"+GetName(oTarget)+".");
      SendMessageToPC(oPC,"*Item spawner set with"+GetName(oTarget)+"with cost of "+IntToString(nItemValue)+"gp.*");
      SetName(oWidget,"Item Spawner: " + GetName(oTarget));
      SetLocalInt(oWidget,"itemcost",nItemValue);

    }
  }
}

