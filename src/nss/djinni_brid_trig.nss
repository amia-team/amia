/*
   Djinni_brid_trig - Entry trigger for Djinni Bridge challenge
   - Maverick00053, March 2025

*/



void main()
{

  object oWP = GetWaypointByTag("djinni_bridge_up");
  object oBridge = GetObjectByTag("djinni_puz_brid");
  object oWPPortal = GetWaypointByTag("bridge_travel");
  object oPortal = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE,GetLocation(oWPPortal));

  if(GetIsObjectValid(oBridge))
  {
    AssignCommand(oBridge,ActionSpeakString("<c ¿ >**As you finish crossing the bridge collapses into the abyss below**</c>"));
    DelayCommand(2.0,DestroyObject(oBridge));
  }

  if(GetIsObjectValid(oPortal))
  {
    DelayCommand(2.0,DestroyObject(oPortal));
  }
}
