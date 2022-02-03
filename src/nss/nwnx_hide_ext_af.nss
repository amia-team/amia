#include "nwnx_reveal"


void main()
{
    object oPC = OBJECT_SELF;
    int nCooldown = GetLocalInt(oPC,"HIPSCooldown");

    if((nCooldown==0) && (GetLevelByClass(CLASS_TYPE_SHADOWDANCER,OBJECT_SELF) >= 1))
    {
      FloatingTextStringOnCreature("<cò­ÿ>You may use HIPS again in 6 seconds.</c>",oPC,FALSE);
      SetLocalInt(oPC,"HIPSCooldown",1);
      DelayCommand(6.0,DeleteLocalInt(oPC,"HIPSCooldown"));
      DelayCommand(6.0,FloatingTextStringOnCreature("<cò­ÿ>You can HIPS again!</c>",oPC,FALSE));
    }
}
