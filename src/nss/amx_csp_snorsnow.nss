//::///////////////////////////////////////////////
//:: Snorri's Snowball
//:: amx_csp_snorsnow.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Snorri’s Snowball (Evocation):

Level: Wizard/Sorcerer 6, Bard 6
Components: V,S
Range: Long
Area of effect: Single
Duration: Instantaneous
Valid Metamagic: Empower, Maximize
Save: Reflex Half (See description)
Spell Resistance: Yes

The caster casts a snowball at a target, and performs a ranged touch attack
against a single target. If the touch attack hits, the target will take 1d6
cold damage per caster level, with no cap. The Snowball will then burst and
every target in a 15 ft radius will take 1d6 cold damage per two caster levels,
to a maximum of 15d6 damage at level 30. Each Spell Focus in evocation increases
the burst damage by 1d6 cold damage, and epic spell focus will increase the burst
damage by 3d6 cold damage. A reflex save will half the cold damage taken, evasion applies.
Should the initial target be hit by the touch attack, they will not take the
burst damage. However if the touch attack misses, they will be subject to the burst damage.
*/
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: Feb 12, 2024
//:://////////////////////////////////////////////
//::

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"

void main()
{
    if (!X2PreSpellCastCode()) {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nMetaMagic = GetMetaMagicFeat();

    int nCL = GetCasterLevel(oCaster);
    int dmgDice = nCL;


    int nTouch = TouchAttackRanged(oTarget);
    // Uncomment to enable crits.
    //if (nTouch == 2) {
    //    nDmg = nDmg + nDmg;
    //}

    int nDamageType = DAMAGE_TYPE_COLD;
    int nDC = GetSpellSaveDC();

    SignalEvent(oTarget,EventSpellCastAt(oCaster,GetSpellId()));
    if (nTouch >= 1) {
        int nDmg = d6(dmgDice);
        if (nMetaMagic == METAMAGIC_MAXIMIZE) {
            nDmg = 6*dmgDice;
        }
        if (nMetaMagic == METAMAGIC_EMPOWER) {
            nDmg = FloatToInt(nDmg * 1.5);
        }
        effect eDmg = EffectDamage(nDmg, nDamageType);
        int nVFX = VFX_IMP_FROST_L;
        effect eHit = EffectVisualEffect(nVFX);
        DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget));
        DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eHit,oTarget));
    }
    // Now for the AoE portion

    location lTarget = GetLocation(oTarget);

    int nBoomVFX = VFX_IMP_PULSE_COLD;
    effect eBoom = EffectVisualEffect(nBoomVFX);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,eBoom,oTarget);

    object oAoE = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oAoE))
    {
        if ((oAoE == oTarget) && (nTouch >= 1)) {
            continue;
        }
        if (spellsIsTarget(oAoE, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {

            int nBonusMaxDice = 0;
            if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) {
                nBonusMaxDice = 1;
            }
            if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) {
                nBonusMaxDice = 3;
            }
            if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF)) {
                nBonusMaxDice = 5;
            }

            //Fire cast spell at event for the specified target
            SignalEvent(oAoE, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Get the distance between the explosion and the target to calculate delay
            float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oAoE))/20;
            if (!MyResistSpell(OBJECT_SELF, oAoE, fDelay)) {
                //Roll damage for each target
                int nDamage = d6((nCL / 2) + nBonusMaxDice);
                //Resolve metamagic
                if (nMetaMagic == METAMAGIC_MAXIMIZE) {
                    nDamage = 6 * ((nCL/2) + nBonusMaxDice);
                } else if (nMetaMagic == METAMAGIC_EMPOWER) {
                    nDamage = nDamage + nDamage / 2;
                }

                nDamage = GetReflexAdjustedDamage( nDamage, oAoE, GetSpellSaveDC(), SAVING_THROW_TYPE_COLD );
                if (nDamage != 0) {
                    effect eAoEDmg = EffectDamage(nDamage, nDamageType);
                    int nAoEVFX = VFX_IMP_FROST_S;
                    effect eAoEHit = EffectVisualEffect(nAoEVFX);
                    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,eAoEDmg,oAoE));
                    DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT,eAoEHit,oAoE));
                }
            }
       }
       //Select the next target within the spell shape.
       oAoE = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }
}