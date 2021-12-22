#include "x2_i0_spells"

void main()
{
    object oPC = OBJECT_SELF;
    // var
    int cLvl = GetCasterLevel(oPC);

    // effects
    effect eDarkvision = EffectUltravision();
    effect eImmunePoison = EffectImmunity(IMMUNITY_TYPE_POISON);
    effect eAcid = EffectDamageResistance(DAMAGE_TYPE_ACID,10,0);
    effect eCold = EffectDamageResistance(DAMAGE_TYPE_COLD,10,0);
    effect eElectrical = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL,10,0);
    effect eFire = EffectDamageResistance(DAMAGE_TYPE_FIRE,10,0);
    effect eDamageReduction = EffectDamageReduction(10, DAMAGE_POWER_PLUS_FIVE);
    effect eSR = EffectSpellResistanceIncrease(10 + cLvl);
    effect eCharisma = EffectAbilityIncrease(ABILITY_CHARISMA, 4);
    effect eHeal = EffectSkillIncrease(SKILL_HEAL, 10);
    effect eConcentration = EffectSkillIncrease(SKILL_CONCENTRATION, 10);

    effect eVFX1 = EffectVisualEffect(VFX_DUR_GLOW_LIGHT_RED);
    effect eVFX2 = EffectVisualEffect(743);

    // elink
    effect eLink = EffectLinkEffects(eVFX1, eVFX2);
           eLink = EffectLinkEffects(eLink, eDarkvision);
           eLink = EffectLinkEffects(eLink, eImmunePoison);
           eLink = EffectLinkEffects(eLink, eAcid);
           eLink = EffectLinkEffects(eLink, eCold);
           eLink = EffectLinkEffects(eLink, eElectrical);
           eLink = EffectLinkEffects(eLink, eFire);
           eLink = EffectLinkEffects(eLink, eDamageReduction);
           eLink = EffectLinkEffects(eLink, eSR);
           eLink = EffectLinkEffects(eLink, eCharisma);
           eLink = EffectLinkEffects(eLink, eHeal);
           eLink = EffectLinkEffects(eLink, eConcentration);


    RemoveEffectsFromSpell(oPC, GetSpellId());

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(cLvl));
}
