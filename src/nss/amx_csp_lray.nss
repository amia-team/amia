//::///////////////////////////////////////////////
//:: Lightning Ray Spell
//:: amx_csp_sray
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: 02/26/2022
//:://////////////////////////////////////////////

// Explanation:
/*
Spell school: Evocation
Level: Dragon Disciple 2
Components: V, S
Casting Time: 1 standard action
Range: Long
Area of effect: Single
Duration: Instantaneous
Valid Metamagic: Empower, Maximize
Save: None
Spell Resistance: Yes

Spell Description:
The caster fires rays of energy at a target, making a ranged touch attack
against the target for each ray fired. Each ray deals 4d6 electrical damage. The caster
fires one ray at caster level 3, increasing to two at level 7 and three at 11.
The Dragon Disciple's caster level counts as their dragon disciple level plus
their bard and sorcerer levels for this spell.
*/

#include "x2_inc_spellhook"
#include "amx_rddcore"

void main() {
    int dmgDice = 4;
    float fBeamDur = 1.7;

    if (!X2PreSpellCastCode()) {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nMetaMagic = GetMetaMagicFeat();

    int nCL = getDDCL(oCaster);

    int nRays = 1;
    if (nCL >= 11) {
        nRays = 3;
    } else if (nCL >= 7) {
        nRays = 2;
    }
    int loop;
    for (loop = 0; loop < nRays; loop++) {
        int nDmg = d6(dmgDice);
        if (nMetaMagic == METAMAGIC_MAXIMIZE) {
            nDmg = 6*dmgDice;
        }
        if (nMetaMagic == METAMAGIC_EMPOWER) {
            nDmg = FloatToInt(nDmg * 1.5);
        }
        int nTouch = TouchAttackRanged(oTarget);
        // Uncomment to enable crits.
        //if (nTouch == 2) {
        //    nDmg = nDmg + nDmg;
        //}

        int nDamageType = DAMAGE_TYPE_ELECTRICAL;
        int nBeam = VFX_BEAM_LIGHTNING;

        SignalEvent(oTarget,EventSpellCastAt(oCaster,GetSpellId()));
        if (nTouch >= 1) {
            effect eVis = EffectBeam(nBeam,oCaster,BODY_NODE_HAND);
            DelayCommand(0.1f+IntToFloat(loop)/5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oTarget, fBeamDur));
            if (customDDSpellResist(oCaster,oTarget,nCL) >= 1) {
                effect eDmg = EffectDamage(nDmg, nDamageType);
                int nVFX = VFX_IMP_LIGHTNING_S;
                effect eHit = EffectVisualEffect(nVFX);
                DelayCommand(0.1f+IntToFloat(loop)/5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget));
                DelayCommand(0.1f+IntToFloat(loop)/5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eHit,oTarget));
            }
        } else {
            // Display Missed Beam
            effect eVis = EffectBeam(nBeam,oCaster,BODY_NODE_HAND, TRUE, 1.0f,Vector(0.0,0.0,0.0),Vector(GetRandomDelay(),GetRandomDelay(),GetRandomDelay()));
            DelayCommand(0.1f+IntToFloat(loop)/5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oTarget, fBeamDur));
        }
    }
}
