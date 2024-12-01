/*

   Job System PLC Spawner

   - Maverick00053


*/


#include "x2_inc_switches"
#include "x2_inc_itemprop"
#include "inc_ds_porting"

void main()
{
   object oPC = GetItemActivator();
   object oWidget = GetItemActivated();
   object oPCKEY = GetPCKEY(oPC);
   object oTarget = GetItemActivatedTarget();
   location lTargeted = GetItemActivatedTargetLocation();
   string sPLC = GetLocalString(oWidget,"plc");
   int sActivePLC = GetLocalInt(oWidget,"active");
   location lPLC = GetLocalLocation(oWidget, "spawnedplclocation");
   string sPCKEYName = GetName(oPCKEY);
   string sPCKEYNameSub = GetSubString(sPCKEYName,0,8);

   if((sActivePLC == 1) && (GetIsObjectValid(oTarget)) && (GetLocalString(oTarget,"pcowner")==sPCKEYNameSub))
   {
     SetLocalObject(oPC,"pcplc",oTarget);
     SetLocalObject(oPC,"plcwidget",oWidget);
     SetLocalFloat(oTarget,"basesize",GetObjectVisualTransform(oTarget,OBJECT_VISUAL_TRANSFORM_SCALE));
     AssignCommand(oPC, ActionStartConversation(oPC, "js_plc_persist", TRUE, FALSE));
   }
   else if(sActivePLC == 1)
   {
     object oPLC = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lPLC);
     string sPLCRes = GetResRef(oPLC);
     if((sPLCRes == sPLC) && (GetLocalString(oPLC,"pcowner")==sPCKEYNameSub))
     {
      DestroyObject(oPLC);
     }
     FloatingTextStringOnCreature("*Removing PLC*",oPC);
     DeleteLocalInt(oWidget,"active");


   }
   else
   {
     FloatingTextStringOnCreature("*Spawning PLC*",oPC);
     object oPlacedPLC = CreateObject(OBJECT_TYPE_PLACEABLE,sPLC,lTargeted,FALSE);
     float fRotation = GetFacing(oPlacedPLC) + GetLocalFloat(oPlacedPLC, "SpawnRotation");
     AssignCommand(oPlacedPLC, SetFacing(fRotation));
     SetName(oPlacedPLC,GetName(oWidget));
     SetDescription(oPlacedPLC,GetDescription(oWidget));
     SetLocalInt(oWidget,"active",1);
     SetLocalLocation(oWidget, "spawnedplclocation",lTargeted);
     SetLocalString(oPlacedPLC, "pcowner",sPCKEYNameSub);
     if(GetLocalInt(oPC,"plctoggle")==1)
     {
       SetUseableFlag(oPlacedPLC,0);
     }
     else
     {
       SetUseableFlag(oPlacedPLC,1);
     }
   }




}
