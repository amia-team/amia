/*
    Gibberling Lair Camp Entry Script
    - Mav, 12/5/24

*/

void main()
{
  object oPC = GetLastUsedBy();
  object oWP = GetWaypointByTag("gibcampentry");
  object oGuard1 = GetObjectByTag("GibGuard1");
  object oGuard2 = GetObjectByTag("GibGuard2");
  int nCD = GetLocalInt(oWP,"cooldown");

  AssignCommand(oPC,ActionJumpToObject(oWP));

  if(nCD!=1)
  {
   DelayCommand(1.0,AssignCommand(oGuard1,ActionSpeakString("Welcome! Not everyone makes it all the way here. Go speak with Gabriel after you take a breather.")));
   DelayCommand(1.5,AssignCommand(oGuard2,ActionSpeakString("*Offers a nod* Good to have you.")));
   SetLocalInt(oWP,"cooldown",1);
   DelayCommand(15.0,DeleteLocalInt(oWP,"cooldown"));
  }
}
