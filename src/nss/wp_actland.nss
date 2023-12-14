/*

  Actand area 4 neutral area teleport script. It is based on if they are good/bad where they go after the leave the cavern.

  - Maverick00053 11/23/2023
*/


#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"

void main()
{
  object oPC = GetLastUsedBy();
  object oTrans = OBJECT_SELF;
  string sWPe = GetLocalString(oTrans,"WaypointEvil");
  string sWPg = GetLocalString(oTrans,"WaypointGood");
  int nAlignment = GetPCKEYValue(oPC,"actanddungeon"); // 1 is good, 2 is evil

  if(nAlignment==1)
  {
   AssignCommand(oPC,ActionJumpToLocation(GetLocation(GetWaypointByTag(sWPg))));
  }
  else if(nAlignment==2)
  {
    AssignCommand(oPC,ActionJumpToLocation(GetLocation(GetWaypointByTag(sWPe))));
  }
}
