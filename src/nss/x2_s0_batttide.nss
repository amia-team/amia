/* Battletide

    - duration: 1 round per casterlevel
    - creates an aura that if an enemy enters it she will suffer -2 to attack, damage and saves
    - caster's attack, damage and saves increase by 2

*/

// includes
#include "nw_i0_spells"
#include "x2_i0_spells"
#include "x2_inc_spellhook"

void main(){

    // spellhook
    if(X2PreSpellCastCode()==FALSE){

        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;

    }

    // vars
    object oPC=OBJECT_SELF;
    int nCasterLevel=GetCasterLevel(oPC);
    float fDuration=RoundsToSeconds(nCasterLevel);

    // double the duration if Extended Metamagic was used
    if(GetMetaMagicFeat()==METAMAGIC_EXTEND){

        fDuration*=2.0;

    }

    // stacking check
    SignalEvent(
        oPC,
        EventSpellCastAt(
            oPC,
            SPELL_BATTLETIDE,
            FALSE));

    RemoveEffectsFromSpell(
        oPC,
        SPELL_BATTLETIDE);

    // caster buff
    // AB +2
    effect eAttackBonus=EffectAttackIncrease(2);

    // Damage +2
    effect eDamageBonus=EffectDamageIncrease(2);

    // Saving throws +2
    effect eSavingThrowBonus=EffectSavingThrowIncrease(
        SAVING_THROW_ALL,
        2);

    // wrap it all up
    effect eBoost=EffectLinkEffects(
        eAttackBonus,
        eDamageBonus);
    eBoost=EffectLinkEffects(
        eBoost,
        eSavingThrowBonus);

    // slap it on
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        eBoost,
        oPC,
        fDuration);

    // caster aura
    // aura vfx and scriptset
    effect eBattletideVFX=EffectAreaOfEffect(
        AOE_MOB_STUN,
        "cs_battletide_en",
        "cs_battletide_hb",
        "cs_battletide_ex");

    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        eBattletideVFX,
        oPC,
        fDuration);

    return;

}
