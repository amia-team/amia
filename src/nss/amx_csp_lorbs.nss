//::///////////////////////////////////////////////
//:: Lesser Orb Of Sound Spell
//:: amx_csp_lorba
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: 03/17/2022
//:://////////////////////////////////////////////

// Explanation:
/*
Spell school: Conjuration
Level: Dragon Disciple 1
Components: V, S
Casting Time: 1 standard action
Range: Long
Area of effect: Single
Duration: Instantaneous
Valid Metamagic: Empower, Maximize
Save: None
Spell Resistance: No

Spell Description:
An orb of sound about 2 inches across shoots from your palm at its target dealing
1d8 points of sonic damage. You must succeed on ranged touch attack to hit your
target. For every two caster levels beyond 1st, your orb deals an additional
1d8 points of damage: 2d8 at 3rd level, 3d8 at 5th level, 4d8 at 7th level, and
the maximum of 5d8 at 9th level or higher.
*/

#include "x2_inc_spellhook"
#include "amx_rddcore"

void main() {
    int nDmgCap = 5;

    if (!X2PreSpellCastCode()) {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nMetaMagic = GetMetaMagicFeat();

    int nCL = (getDDCL(oCaster)+1)/2;
    int dmgDice = nCL;
    if (dmgDice > nDmgCap) {
        dmgDice = nDmgCap;
    }

    int nDmg = d8(dmgDice);
    if (nMetaMagic == METAMAGIC_MAXIMIZE) {
        nDmg = 8*dmgDice;
    }
    if (nMetaMagic == METAMAGIC_EMPOWER) {
        nDmg = FloatToInt(nDmg * 1.5);
    }
    int nTouch = TouchAttackRanged(oTarget);
    // Uncomment to enable crits.
    //if (nTouch == 2) {
    //    nDmg = nDmg + nDmg;
    //}

    int nDamageType = DAMAGE_TYPE_SONIC;
    int nDC = GetSpellSaveDC();

    SignalEvent(oTarget,EventSpellCastAt(oCaster,GetSpellId()));
    if (nTouch >= 1) {
        effect eDmg = EffectDamage(nDmg, nDamageType);
        int nVFX = VFX_IMP_SONIC;
        effect eHit = EffectVisualEffect(nVFX);
        DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget));
        DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eHit,oTarget));
    } else {
        // Display Missed Orb
        //effect eVis = EffectBeam(nBeam,oCaster,BODY_NODE_HAND, TRUE, 1.0f,Vector(0.0,0.0,0.0),Vector(GetRandomDelay(),GetRandomDelay(),GetRandomDelay()));
        //DelayCommand(0.1f+IntToFloat(loop)/5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVis,oTarget, fBeamDur));
    }
}
