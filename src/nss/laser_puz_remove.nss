/*
  Puzzle Beam Removal
  - Mav, 2/22/25
*/

void RemoveEffectVFX(object oTarget);

void main()
{

  object oPLC = OBJECT_SELF;
  string sTag = GetLocalString(oPLC,"target");
  string sTagSource = GetTag(oPLC);
  object oTarget = GetObjectByTag(sTag);
  //string sLaserTag = "lp"+sTagSource+sTag;
  string sTargetSource = GetLocalString(oTarget,"source");

  if(sTag == "")
  {
    return;
  }

   // While loop to cycle through all the statues
   while(GetIsObjectValid(oTarget))
   {

     RemoveEffectVFX(oTarget);
     // If the source for the target you are moving off us is from you, delete it
     if(sTargetSource==GetTag(oPLC))
     {
      DeleteLocalString(oTarget,"source");
      DeleteLocalInt(oTarget,"active");
      //ExecuteScript("laser_puz_remove",oTarget);
     }
     DeleteLocalString(oPLC,"target");

     oPLC = oTarget;
     sTag = GetLocalString(oPLC,"target");
     sTagSource = GetTag(oPLC);
     oTarget = GetObjectByTag(sTag);
     sTargetSource = GetLocalString(oTarget,"source");
   }


}


void RemoveEffectVFX(object oTarget)
{
  effect eLoop = GetFirstEffect(oTarget);
  while(GetIsEffectValid(eLoop))
  {
    RemoveEffect(oTarget,eLoop);
    eLoop = GetNextEffect(oTarget);
  }
}
