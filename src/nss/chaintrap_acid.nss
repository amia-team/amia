void main()
{

object oPC = GetLastUsedBy();

if (!GetIsPC(oPC)) return;

effect eEffect;
eEffect = EffectDamage(25, DAMAGE_TYPE_ACID, DAMAGE_POWER_NORMAL);

ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oPC);

}

