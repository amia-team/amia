/*
Made on April 27th 2019 by Maverick00053
A tool that shifts the double XP server wide on and off.
*/

void main()
{
  object oModule = GetModule();
  object oPC     = GetItemActivator();
  int nDoubleXP  = GetLocalInt(oModule,"doubleXP");

  if(nDoubleXP == 0)
  {
    SendMessageToAllDMs("Double XP Set!");
    SendMessageToPC(oPC,"Double XP Set!");
    SetLocalInt(oModule, "doubleXP", 1);
  }
  else if(nDoubleXP == 1)
  {
    SendMessageToAllDMs("Normal XP Set!");
     SendMessageToPC(oPC,"Normal XP Set!");
    SetLocalInt(oModule, "doubleXP", 0);
  }
  else
  {
    SendMessageToAllDMs("Double XP Set!");
    SendMessageToPC(oPC,"Double XP Set!");
    SetLocalInt(oModule, "doubleXP", 1);
  }





}
