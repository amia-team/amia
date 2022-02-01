#include "nwnx_reveal"


void main()
{
    object oPC = OBJECT_SELF;
    int nCooldown = GetLocalInt(oPC,"HIPSCooldown");

    if(nCooldown==0)
    {
      SendMessageToPC(oPC,"<cò­ÿ>You may use HIPS again in 6 seconds.</c>");
      SetLocalInt(oPC,"HIPSCooldown",1);
      DelayCommand(6.0,DeleteLocalInt(oPC,"HIPSCooldown"));
    }
}
