//::///////////////////////////////////////////////
//:: Orb Of Acid Spell
//:: amx_csp_morba
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: 03/17/2022
//:://////////////////////////////////////////////

// Explanation:
/*
Spell school: Conjuration
Level: Dragon Disciple 4
Components: V, S
Casting Time: 1 standard action
Range: Long
Area of effect: Single
Duration: Instantaneous
Valid Metamagic: Empower, Maximize
Save: Fortitude Partial
Spell Resistance: No

Spell Description:
An orb of acid about 3 inches across shoots from your palm at its target
dealing 1D6 points of acid damage per caster level (maximum 15D6). You must
succeed on ranged touch attack to hit your target. A creature struck by the orb
take damage and becomes sickened by the acid's noxious fumes for 1 round. A
successful fortitude save negates the sickened effect, but does not reduce damage.
*/

#include "x2_inc_spellhook"
#include "amx_rddcore"

void main() {
    int nDmgCap = 15;

    if (!X2PreSpellCastCode()) {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nMetaMagic = GetMetaMagicFeat();

    int nCL = getDDCL(oCaster);
    int dmgDice = nCL;
    if (dmgDice > nDmgCap) {
        dmgDice = nDmgCap;
    }

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

    int nDamageType = DAMAGE_TYPE_ACID;
    int nDC = GetSpellSaveDC();

    SignalEvent(oTarget,EventSpellCastAt(oCaster,GetSpellId()));
    if (nTouch >= 1) {
        if (customDDSpellResist(oCaster,oTarget,nCL) >= 1) {
            if (FortitudeSave(oTarget,nDC,SAVING_THROW_TYPE_SPELL,oCaster) < 1) {
                float fDur = 6.0f;
                // Come up with sickened effect:
                // The character takes a -2 penalty on all attack rolls,
                // weapon damage rolls, saving throws, skill checks,
                // and ability checks.
                int nPenalty = 2;
                effect eOrbDebuff = EffectAttackDecrease(nPenalty);
                eOrbDebuff = EffectLinkEffects(EffectDamageDecrease(nPenalty),eOrbDebuff);
                eOrbDebuff = EffectLinkEffects(EffectSavingThrowDecrease(SAVING_THROW_ALL, nPenalty),eOrbDebuff);
                eOrbDebuff = EffectLinkEffects(EffectSkillDecrease(SKILL_ALL_SKILLS,nPenalty),eOrbDebuff);
                DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eOrbDebuff,oTarget, fDur));
            }
            effect eDmg = EffectDamage(nDmg, nDamageType);
            int nVFX = VFX_IMP_ACID_L;
            effect eHit = EffectVisualEffect(nVFX);
            DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget));
            DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eHit,oTarget));
        }
    } else {
        // Display Missed Orb
        //effect eVis = EffectBeam(nBeam,oCaster,BODY_NODE_HAND, TRUE, 1.0f,Vector(0.0,0.0,0.0),Vector(GetRandomDelay(),GetRandomDelay(),GetRandomDelay()));
        //DelayCommand(0.1f+IntToFloat(loop)/5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oTarget, fBeamDur));
    }
}
