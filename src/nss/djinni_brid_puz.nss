/*
  Key Bridge Puzzle for Djinni

  - Maverick00053, 3/1/25

*/

object HasOrb(object oPC, object oPLC);

void SpawnBridge();

void main()
{
   object oPC = GetLastUsedBy();
   object oPLC = OBJECT_SELF;
   object oOrb = HasOrb(oPC,oPLC);

   if(GetIsObjectValid(oOrb))
   {
     AssignCommand(oPLC,ActionSpeakString("<c ¿ >**The magical stone activates as you slide the orb into an open hole.**</c>"));
     SpawnBridge();
     DestroyObject(oOrb);
   }
   else
   {
     AssignCommand(oPLC,ActionSpeakString("<c ¿ >**The magical stone does nothing. It needs something to activate.**</c>"));
   }


}

object HasOrb(object oPC, object oPLC)
{
  string oOrb = "djinniorb";
  object oNothing;
  int nCount = 0;

  object oInventoryItem = GetFirstItemInInventory(oPC);

  while(GetIsObjectValid(oInventoryItem))
  {
    if((GetResRef(oInventoryItem)==oOrb))
    {
      return oInventoryItem;
      break;
    }
   oInventoryItem = GetNextItemInInventory(oPC);
  }

  return oNothing;
}

void SpawnBridge()
{
  effect eVis = EffectVisualEffect(VFX_FNF_ELECTRIC_EXPLOSION);
  object oWPBridge = GetWaypointByTag("djinni_bridge_up");
  object oWPPortal = GetWaypointByTag("bridge_travel");
  object oNewBridge = CreateObject(OBJECT_TYPE_PLACEABLE,"djinni_puz_brid",GetLocation(oWPBridge));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetLocation(oWPBridge));
  DelayCommand(0.1,SetFacing(180.0,oNewBridge));
  CreateObject(OBJECT_TYPE_PLACEABLE,"djinni_brid_port",GetLocation(oWPPortal));
}
