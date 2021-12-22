#include "nw_i0_spells"

void main()
{
object oPC = GetLocalObject(OBJECT_SELF, "SHACKLE_VICTIM");
effect eKnockdown = EffectKnockdown();

RemoveSpecificEffect(0, oPC);
SetLocalInt(OBJECT_SELF, "GRIMM_SHACKLED", FALSE);
}
