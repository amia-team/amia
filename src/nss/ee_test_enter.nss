// Script to check if the entrering player has a PC-Key
#include "nw_i0_tool"
void main()
{
     object oPC = GetClickingObject();
     object oTarget;
     oTarget = GetWaypointByTag("Startingpoint");
     if(HasItem(oPC, "ds_pckey") == TRUE)
     {
     AssignCommand(oPC, JumpToObject(oTarget));
     }
     else if(HasItem(oPC, "ds_pckey_dm") == TRUE)
     {
     AssignCommand(oPC, JumpToObject(oTarget));
     }
     else{
         SendMessageToPC(oPC, "No PC-Key detected, please talk to the statue first.");
     }

}
