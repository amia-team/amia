/*
  The portal script that sends PCs to locations

 - MAverick00053 11/23/2023
*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"

void main()
{
  object oPC = GetLastUsedBy();
  int nDungeonType = GetPCKEYValue(oPC,"actanddungeon");


  if(nDungeonType==0)
  {
    SendMessageToPC(oPC,"-- You must first speak with the portal master --");
  }
  else if(nDungeonType==1)
  {
    AssignCommand(oPC,ActionJumpToLocation(GetLocation(GetWaypointByTag("actandgoodstart"))));
  }
  else if(nDungeonType==2)
  {
    AssignCommand(oPC,ActionJumpToLocation(GetLocation(GetWaypointByTag("actandevilstart"))));
  }

}
