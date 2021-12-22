#include "nw_i0_spells"

void main()
{
effect eEffect = EffectKnockdown();
object oPC = GetLocalObject(OBJECT_SELF, "SHACKLE_VICTIM");

RemoveSpecificEffect(0, oPC);
}
