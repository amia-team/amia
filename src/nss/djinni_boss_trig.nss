/*
   Djinni_boss_trig - Entry trigger to setup the boss challenge in Djinni
   - Maverick00053, March 2025

*/


void main()
{
  object oArea = GetArea(OBJECT_SELF);
  int nBlock = GetLocalInt(OBJECT_SELF,"block");
  object oSign = GetObjectByTag("djinni_boss_sign");
  object oWP = GetWaypointByTag("djinni_boss_exit");

  if((nBlock==0))
  {
    switch(Random(2)+1)
    {
      case 1: SetLocalString(oArea,"challengeboss","djinni_anti_ft"); SetName(oSign,"Beware Fighters!"); SetDescription(oSign,"Beware adventurers for the challenge ahead will deal devastation against those skilled in close range combat!                                                Once you enter you may not leave unless you survive or die. Mages should strip away the obstacles in their way and the path to success will reveal itself!"); break;
      case 2: SetLocalString(oArea,"challengeboss","djinni_anti_cast"); SetName(oSign,"Beware Mages!"); SetDescription(oSign,"Beware adventurers for the challenge ahead will deal devastation against those skilled in magic!                                                                   Once you enter you may not leave unless you survive or die. Fighters should focus on the task at hand and do what they do best and the path to success will show itself!"); break;
    }

    SetLocalInt(OBJECT_SELF,"block",1);
    DelayCommand(300.0,DeleteLocalInt(OBJECT_SELF,"block"));

   object oPortal = GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE,GetLocation(oWP));
   if(GetResRef(oPortal)=="djinni_boss_port")
   {
     DestroyObject(oPortal);
   }
  }
}
