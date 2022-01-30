//::///////////////////////////////////////////////
//:: Amia Enhanced Cure Wounds
//:: amx_curwnds
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: 01/30/2022
//:://////////////////////////////////////////////

// Explanation:
// Script to add hooks for an expanded functionality and cleaner implementation
// of the cure wounds spells. Script is expanded to better account for faction
// hostility and for AoE functionality given Epic Focus Conjuration.
// AoE will affect friendly targets and hostile undead.
// The explicit target will always be affected regardless of faction reputation

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

int nCircleVFX = VFX_FNF_LOS_HOLY_10;

int GetIsUndead( object oCreature ) {
    return ( GetRacialType(oCreature) == RACIAL_TYPE_UNDEAD
            || GetLevelByClass(CLASS_TYPE_UNDEAD, oCreature) > 0 );
}

// Function to heal a single target. OBJECT_SELF refers to the caster.
void HealTarget(object oTarget, int nDice, int nBonus, int nMm, int nHealVFX=VFX_IMP_HEALING_S, int nAtkVFX=VFX_IMP_SUNSTRIKE, int nCastFromItem=FALSE) {

    int nHP = d8(nDice)+nBonus;
    if (nMm == METAMAGIC_MAXIMIZE && !GetIsPolymorphed(OBJECT_SELF)) {
        nHP = (8*nDice) + nBonus;
    }
    if (nMm == METAMAGIC_EMPOWER && !GetIsPolymorphed(OBJECT_SELF)) {
        nHP = nHP + (nHP/2); //Damage/Healing is +50%
    }
    if (nCastFromItem == FALSE) {
        if (GetHasFeat(FEAT_HEALING_DOMAIN_POWER) && !GetIsPolymorphed(OBJECT_SELF)) {
            nHP = nHP + (nHP/2); //Damage/Healing is +50%
        }
    }

    if (GetIsUndead(oTarget)) {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        if (WillSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_POSITIVE) > 0) {
            nHP = nHP / 2;
        }
        if (TouchAttackMelee(oTarget) > 0) {
            float fDelay = fDelay = GetRandomDelay();
            //Set the damage effect
            effect eDmg = EffectDamage(nHP, DAMAGE_TYPE_POSITIVE);
            effect eVis = EffectVisualEffect (nAtkVFX);
            //Apply the VFX impact and damage effect
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDmg, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
    } else {
        effect eCure = EffectHeal (nHP);
        effect eVis = EffectVisualEffect (nHealVFX);

        float fDelay = fDelay = GetRandomDelay();
        //Apply healing and visual
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCure, oTarget));
        DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
    }
}

// Function to perform an AoE healing. It will get targets and then run the
// HealTarget function above on them.
void AoEHeal(int nDice, int nBonus, int nMetaMagic, int nHealVFX=VFX_IMP_HEALING_S, int nAtkVFX=VFX_IMP_SUNSTRIKE, object oSpecificTarget=OBJECT_INVALID) {
    //Declare major variables
    effect eStrike = EffectVisualEffect(nCircleVFX);
    float fDelay;
    location lLoc = GetSpellTargetLocation();

    //Apply VFX area impact
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, lLoc);

    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
    while(GetIsObjectValid(oTarget)) {
        if (GetIsUndead(oTarget) && GetIsReactionTypeHostile(oTarget)) {
            fDelay = GetRandomDelay();
            DelayCommand(fDelay,HealTarget(oTarget,nDice,nBonus,nMetaMagic, nHealVFX, nAtkVFX));
        } else if (!GetIsUndead(oTarget) && GetIsFriend(oTarget)) {
            fDelay = GetRandomDelay();
            DelayCommand(fDelay,HealTarget(oTarget,nDice,nBonus,nMetaMagic, nHealVFX, nAtkVFX));
        } else if (oTarget == oSpecificTarget) {
            fDelay = GetRandomDelay();
            DelayCommand(fDelay,HealTarget(oSpecificTarget,nDice,nBonus,nMetaMagic, nHealVFX, nAtkVFX));
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lLoc);
    }
}
