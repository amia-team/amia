#include "nw_i0_generic"

void main()
{
float fPause = 1.2f;
object oPC = GetLastUsedBy();
object oShackle = OBJECT_SELF;
location lShackle = GetLocation(oShackle);
effect eKnockdown = EffectKnockdown();

AssignCommand(oPC, ActionJumpToLocation(lShackle));
DelayCommand(fPause, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eKnockdown, oPC));
SetLocalInt(OBJECT_SELF, "GRIMM_SHACKLED", TRUE);
SetLocalObject(OBJECT_SELF, "SHACKLE_VICTIM", oPC);
}
