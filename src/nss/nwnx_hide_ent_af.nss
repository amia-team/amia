#include "nwnx_reveal"


void main()
{
    object oPC = OBJECT_SELF;
    int nCooldown = GetLocalInt(oPC,"HIPSCooldown");

    if(nCooldown == 1)
    {
     SetActionMode(oPC,ACTION_MODE_STEALTH,FALSE);
    }

}
