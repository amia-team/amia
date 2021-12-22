/*
---------------------------------------------------------------------------------
NAME: fw_transition
Description: This determines what you clicked on, and sends you along your way by creating the area ahead of you.
LOG:
    Faded Wings [10/28/2015 - Born!]
----------------------------------------------------------------------------------
*/

#include "inc_lua"
#include "fw_include"

void main()
{
     object oPC = GetClickingObject();
     object oTarget = OBJECT_SELF;

     int nTimestamp = StringToInt(RunLua("return os.time()"));
     if(nTimestamp-GetLocalInt(oPC,"last_trans") < 3)return;
     SetLocalInt(oPC, "last_trans", nTimestamp);

     // try door / trigger
     if(GetIsObjectValid(oPC))
     {
         fw_goToInstance(oPC, oTarget);
         return;
     }
     else
     {
         //ok try plc
         oPC = GetPlaceableLastClickedBy();
         if(GetIsObjectValid(oPC))
         {
             fw_spawnInstance(oTarget);
             return;
         }
         else
         {
            // nothing to do here...
            return;
         }
      }
}

