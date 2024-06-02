/*
Morgen's Electrifier (Evocation):

Level: Wizard/Sorcerer 4, Bard 4
Components: V,S
Range: Personal
Area of effect: Single
Duration: 1 round/Caster Level
Valid Metamagic: Still, Silent, Extend
Save: None
Spell Resistance: No

The caster energizes themselves with a large flow of electricity, dangerously protecting themselves and enhancing themselves with electrical energy.

For the duration, the caster gains 50% movement speed, gains a 25% immunity to electricity, gains +1d8 electrical damage per hit, and has a 2d6 electrical damage shield.
This spell does not stack with death armor, elemental shield, wounding whispers, or mestil's acid sheath.*/

#include "x2_inc_spellhook"
#include "x0_i0_spells"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_DUR_AURA_BLUE);
    int nCL = GetCasterLevel(OBJECT_SELF);
    int nDur = nCL;
    int nDamage = 0;
    int nMetaMagic = GetMetaMagicFeat();
    int nDice = 2;
    int nResist = 25;
    object oTarget = OBJECT_SELF;


    //Set up effects
    effect eShield = EffectDamageShield(nDamage, d6(nDice), DAMAGE_TYPE_ELECTRICAL);
    //effect eResistance = EffectDamageResistance(DAMAGE_TYPE_ELECTRICAL, nResist, 0);
    effect eResistance = EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL, nResist);
    effect eElecDmg = EffectDamageIncrease(DAMAGE_BONUS_1d8, DAMAGE_TYPE_ELECTRICAL);
    effect eMoveInc = EffectMovementSpeedIncrease(50);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eResistance);
    eLink = EffectLinkEffects(eLink, eElecDmg);
    eLink = EffectLinkEffects(eLink, eMoveInc);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDur = nDur *2; //Duration is +100%
    }

    // 2003-07-07: Stacking Spell Pass, Georg
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    if ( GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD) ) {
        RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, oTarget );
    }
    if ( GetHasSpellEffect(SPELL_DEATH_ARMOR) ) {
        RemoveSpellEffects(SPELL_DEATH_ARMOR, OBJECT_SELF, oTarget );
    }
    if ( GetHasSpellEffect(SPELL_WOUNDING_WHISPERS) ) {
        RemoveSpellEffects(SPELL_WOUNDING_WHISPERS, OBJECT_SELF, oTarget );
    }
    if ( GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH)) {
        RemoveSpellEffects(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, oTarget );
    }

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur));
}
