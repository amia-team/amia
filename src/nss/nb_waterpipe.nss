//OnUsed
void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

object oTarget;
oTarget = oPC;

effect eEffect;
eEffect = EffectDazed();

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 60.0f);

FloatingTextStringOnCreature("You feel the substance hit your head and start feeling all dazed...", oPC);

eEffect = EffectBlindness();

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 60.0f);

eEffect = EffectKnockdown();

ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 60.0f);

}

