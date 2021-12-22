void main()
{


  object oModule = GetModule();
  int nTimer = GetLocalInt(oModule, "InvasionTimer");
  int nInvasionGobs = GetLocalInt(GetModule(),"invasiongobstime");
  int nInvasionOrcs = GetLocalInt(GetModule(),"invasionorcstime");
  int nInvasionTrolls = GetLocalInt(GetModule(),"invasiontrollstime");
  int nInvasionBeasts = GetLocalInt(GetModule(),"invasionbeastmentime");
  nTimer = nTimer + 5;
  SetLocalInt(oModule, "InvasionTimer", nTimer);


  if((nTimer == nInvasionGobs) && (nInvasionGobs != 0))
  {
   SendMessageToAllDMs("// Launch Time in Minutes: " + IntToString(nTimer));
   ExecuteScript("invasion_goblins",oModule);
  }

  if((nTimer == nInvasionOrcs) && (nInvasionOrcs != 0))
  {
   SendMessageToAllDMs("// Launch Time in Minutes: " + IntToString(nTimer));
   ExecuteScript("invasion_orcs",oModule);
  }

  if((nTimer == nInvasionTrolls) && (nInvasionTrolls != 0))
  {
   SendMessageToAllDMs("// Launch Time in Minutes: " + IntToString(nTimer));
   ExecuteScript("invasion_trolls",oModule);
  }

  if((nTimer == nInvasionBeasts) && (nInvasionBeasts != 0))
  {
   SendMessageToAllDMs("// Launch Time in Minutes: " + IntToString(nTimer));
   ExecuteScript("invasion_beasts",oModule);
  }



  DelayCommand(300.0,ExecuteScript("invasion_timer",oModule));
}
