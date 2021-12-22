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
   object oPLC = GetLocalObject(oWidget, "spawnedplc");

   if(GetIsObjectValid(oPLC))
   {
     FloatingTextStringOnCreature("*Removing PLC*",oPC);
     DestroyObject(oPLC);
     DeleteLocalObject(oWidget,"spawnedplc");
   }
   else
   {
     FloatingTextStringOnCreature("*Spawning PLC*",oPC);
     oPLC = CreateObject(OBJECT_TYPE_PLACEABLE,sPLC,lTargeted,FALSE);
     SetName(oPLC,GetName(oWidget));
     SetDescription(oPLC,GetDescription(oWidget));
     SetLocalObject(oWidget,"spawnedplc",oPLC);
   }




}
