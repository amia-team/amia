/*

   Job System PLC Spawner

   - Maverick00053


*/
void main()
{
   object oPC = GetItemActivator();
   object oWidget = GetItemActivated();
   location lTargeted = GetItemActivatedTargetLocation();
   string sPLC = GetLocalString(oWidget,"plc");
   int sActivePLC = GetLocalInt(oWidget,"active");
   location lPLC = GetLocalLocation(oWidget, "spawnedplclocation");


   if(sActivePLC == 1)
   {
      object oPLC = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE, lPLC);
      string sPLCRes = GetResRef(oPLC);
     if(sPLCRes == sPLC)
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
     SetName(oPlacedPLC,GetName(oWidget));
     SetDescription(oPlacedPLC,GetDescription(oWidget));
     SetLocalInt(oWidget,"active",1);
     SetLocalLocation(oWidget, "spawnedplclocation",lTargeted);
   }




}
