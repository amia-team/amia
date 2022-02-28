/*
 Bloodsworn Statue Convo Script - 2/27/22 - Maverick00053
*/

#include "nwnx_creature"

void main()
{

   object oPC = GetPCSpeaker();
   string sObject = GetLocalString(oPC,"bsWidgetResRef");

   if(GetHasFeat(1259, oPC))
   {
     SendMessageToPC(oPC,"You are already blood sworn to another cause.");
   }
   else
   {
      NWNX_Creature_AddFeat(oPC, 1259);
      CreateItemOnObject(sObject,oPC);
      SendMessageToPC(oPC,"You are now Bloodsworn!");
      DeleteLocalString(oPC, "bsWidgetResRef");
   }

}
