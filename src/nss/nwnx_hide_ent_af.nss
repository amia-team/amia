#include "nwnx_reveal"


void main()
{
    object oPC = OBJECT_SELF;
    int nCooldown = GetLocalInt(oPC,"HIPSCooldown");

    if(nCooldown == 1)
    {
     object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_COLOSSAL,GetLocation(oPC),TRUE,OBJECT_TYPE_CREATURE);
     while(GetIsObjectValid(oTarget))
     {
      NWNX_Reveal_RevealTo(oPC,oTarget,NWNX_REVEAL_SEEN);
      NWNX_Reveal_RevealTo(oPC,oTarget,NWNX_REVEAL_HEARD);
      oTarget = GetNextObjectInShape(SHAPE_SPHERE,RADIUS_SIZE_COLOSSAL,GetLocation(oPC),TRUE,OBJECT_TYPE_CREATURE);
     }
     // Below solution if this fix doesnt work
     // SetActionMode(oPC,ACTION_MODE_STEALTH,FALSE);
    }

}
