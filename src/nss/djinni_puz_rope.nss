/*
  Hemp Rope Bridge Puzzle for Djinni

  - Maverick00053, 3/1/25

*/

void ActivatePLC();

void main()
{
   object oPC = OBJECT_SELF;
   object oPLC = GetLocalObject(oPC,"ropeplc");
   int nAnswer = GetLocalInt(oPLC,"answer");
   int nActivated = GetLocalInt(oPLC,"activated");
   int nBlock = GetLocalInt(oPLC,"block");
   string sAnswer = GetLocalString(oPC, "last_chat");
   int nDamage = GetMaxHitPoints(oPC)/2;
   effect eDamage = EffectDamage(nDamage,DAMAGE_TYPE_ELECTRICAL);
   effect eVis = EffectVisualEffect(VFX_IMP_LIGHTNING_M);

   if(nBlock==1)
   {
    AssignCommand(oPLC,ActionSpeakString("<c ¿ >**The device appears unusable at this time**</c>"));
    return;
   }

   if(nActivated==1)
   {
    if(StringToInt(sAnswer)==nAnswer)
    {
     ActivatePLC();
     AssignCommand(oPLC,ActionSpeakString("<c ¿ >**The device rumbles and it accepts your answer!**</c>"));
     SetLocalInt(oPLC,"block",1);
     DelayCommand(300.0,DeleteLocalInt(oPLC,"block"));
    }
    else
    {
     AssignCommand(oPLC,ActionSpeakString("<c ¿ >**The device rejects your answer and shocks you**</c>"));
     ApplyEffectToObject(DURATION_TYPE_INSTANT,eDamage,oPC);
     ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oPC);
     // If they fail reset the question, because it might be too hard
     DeleteLocalInt(oPLC,"activated");
    }
   }
}

void ActivatePLC()
{
  effect eVis = EffectVisualEffect(99);
  object oWP1 = GetWaypointByTag("djinni_rope_1");
  object oWP2 = GetWaypointByTag("djinni_rope_2");
  object oWP3 = GetWaypointByTag("djinni_rope_3");

  CreateObject(OBJECT_TYPE_PLACEABLE,"rope_post",GetLocation(oWP1));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetLocation(oWP1));
  CreateObject(OBJECT_TYPE_PLACEABLE,"rope_post",GetLocation(oWP2));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetLocation(oWP2));
  CreateObject(OBJECT_TYPE_PLACEABLE,"rope_post",GetLocation(oWP3));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eVis,GetLocation(oWP3));
}
