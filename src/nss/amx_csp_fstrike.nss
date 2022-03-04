//::///////////////////////////////////////////////
//:: Force Punch Spell
//:: amx_csp_fpunch
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: 02/09/2022
//:://////////////////////////////////////////////

// Explanation:
/*
Spell school: Evocation
Level: Dragon Disciple 1
Components: V
Casting Time: 1 standard action
Range: Touch
Area of effect: Single
Duration: Instantaneous
Valid Metamagic: Empower, Maximize
Save: Fortitude Half
Spell Resistance: Yes

Spell Description:
The caster imbues one of their limbs with magical force and attempts to strike
the target. The caster makes a melee touch attack against the target and if
they hit, deal 1d4 magic damage per caster level to the target, to a maximum of
10d4. If a target is hit, they can make a fortitude save for half damage.
The Dragon Disciple's caster level counts as their dragon disciple level plus
their bard and sorcerer levels for this spell.
*/

#include "x2_inc_spellhook"
#include "amx_rddcore"

void main() {
    int nDiceCap = 10;

    if (!X2PreSpellCastCode()) {
        // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();
    object oCaster = OBJECT_SELF;
    int nMetaMagic = GetMetaMagicFeat();

    int nCL = getDDCL(oCaster);

    int dmgDice = nCL;
    if (dmgDice > nDiceCap) {
        dmgDice = nDiceCap;
    }

    int nDmg = d4(dmgDice);
    if (nMetaMagic == METAMAGIC_MAXIMIZE) {
        nDmg = 4*dmgDice;
    }

    if (nMetaMagic == METAMAGIC_EMPOWER) {
        nDmg = FloatToInt(nDmg * 1.5);
    }
    int nDC = GetSpellSaveDC();
    int nTouch = TouchAttackMelee(oTarget);
    // Uncomment to enable crits.
    //if (nTouch == 2) {
    //    nDmg = nDmg + nDmg;
    //}

    int nDamageType = DAMAGE_TYPE_MAGICAL;
    int nVFX = VFX_IMP_MAGBLUE;

    SignalEvent(oTarget,EventSpellCastAt(oCaster,GetSpellId()));
    if (nTouch >= 1) {
        effect eVis = EffectVisualEffect(nVFX);
        DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
        if (customDDSpellResist(oCaster,oTarget,nCL) >= 1) {
            if (FortitudeSave(oTarget,nDC,SAVING_THROW_TYPE_SPELL,oCaster) >= 1) {
                nDmg = nDmg / 2;
            }

            effect eDmg = EffectDamage(nDmg, nDamageType);
            DelayCommand(0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDmg,oTarget));
        }
    }

}
