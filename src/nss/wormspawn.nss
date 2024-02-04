/*
  Script attached to the Purple Worm Eggs that summons the raid boss.

  -Maverick00053
*/


void main()
{
   object oPC = GetLastUsedBy();
   object oPLC = OBJECT_SELF;
   int nRandom = Random(3);
   int nWP;
   int nSet = GetLocalInt(oPLC,"set");
   effect eNoMovement = EffectCutsceneImmobilize();

   if(nSet==0)
   {
    switch(nRandom)  // We want the first appearance of the Purple Worm to be close to the party and very cinamatic. So we are forcing them just to the three front WPs.
    {
     case 0: nWP=5; break;
     case 1: nWP=6; break;
     case 2: nWP=14; break;
    }

    object oWP = GetWaypointByTag("wormspawn"+IntToString(nWP));
    location lWP = GetLocation(oWP);

    object oWorm = CreateObject(OBJECT_TYPE_CREATURE,"raid_purpleworm",lWP,TRUE);
    DelayCommand(1.0,AssignCommand(oWorm,SpeakString("*The ground trembles and cracks as the massive Purple Worm appears!*")));
    SetObjectVisualTransform(oWorm, 10, 0.6);
    ApplyEffectToObject(DURATION_TYPE_PERMANENT,eNoMovement,oWorm);
    SetLocalInt(oPLC,"set",1);
    DelayCommand(3.0,DestroyObject(oPLC));
   }


}
