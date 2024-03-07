//::///////////////////////////////////////////////
//:: Bernard's Third Spell: Rigor Mortis
//:: amx_csp_rigmort.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Rigor Mortis (Necromancy)
Level: Cleric 4
Components: V,S
Range: Melee
Area of effect: Single
Duration: Instantaneous
Valid Metamagic: Still, Silent, Extend, Empower, Maximize
Save: Fortitude Special
Spell Resistance: Yes

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

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();

    if ( GetObjectType(oTarget) != OBJECT_TYPE_CREATURE )
        return;

    float fDelay;
    int DAMAGE_LEVEL_CAP = 20;

    int nCL = GetNewCasterLevel(OBJECT_SELF);
    int nDmg = nCL;
    if (nDmg >= DAMAGE_LEVEL_CAP) {
        nDmg = DAMAGE_LEVEL_CAP;
    }
    int nMetaMagic = GetMetaMagicFeat();
    if (!MyResistSpell(OBJECT_SELF, oTarget)) {
        int nDamage = d6(nDmg);
        if (nMetaMagic == METAMAGIC_MAXIMIZE) {
            nDamage = 6 * nDmg;
        }
        if (nMetaMagic == METAMAGIC_EMPOWER) {
            nDamage = nDamage + (nDamage / 2);
        }
        if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC() ))) {
            effect eDexDecrease = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
            effect eMoveDecrease = EffectMovementSpeedDecrease(10);
            effect eVis2 = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
            effect eLink2 = EffectLinkEffects(eDexDecrease, eMoveDecrease);

            int nDur = nCL * 10;
            if (nMetaMagic == METAMAGIC_EXTEND) {
                nDur = nDur + nDur;
            }
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDur)));
        } else {
            nDamage = nDamage / 2;
        }
        effect eDmg = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
        effect eVis = EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE);
        effect eLink = EffectLinkEffects(eVis,eDmg);

        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget));
    }

}