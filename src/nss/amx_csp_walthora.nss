// Wall of Thorns On Enter
#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"


void main()
{
//Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    int nBonusMaxDice = 0;
    effect eDam;
    object oTarget;
    object oCaster = GetAreaOfEffectCreator();
    //Declare and assign personal impact visual effect.
    //Capture the first target object in the shape.
    int nCL = GetCasterLevel(oCaster);
    int nFocusBonus = 0;
    int nWisBonus = GetAbilityModifier(ABILITY_WISDOM);
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster)) {
        nFocusBonus = 6;
    } else if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster)) {
        nFocusBonus = 4;
    } else if (GetHasFeat (FEAT_SPELL_FOCUS_CONJURATION, oCaster)) {
        nFocusBonus = 2;
    }
    oTarget = GetEnteringObject();

    int nAB = nCL + nFocusBonus + nWisBonus;
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator())) {
        int nAC = GetAC(oTarget);
        int nAttack = d20(1) + nAB;
        if (nAttack >= nAC) {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Make SR check, and appropriate saving throw(s).

            nDamage = d6(2);
            //Enter Metamagic conditions
            if (nMetaMagic == METAMAGIC_MAXIMIZE) {
                nDamage = 12;//Damage is at max
            }
            if (nMetaMagic == METAMAGIC_EMPOWER) {
                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
            }
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);

                    // Apply effects to the currently selected target.
            effect eVis = EffectVisualEffect(VFX_IMP_WALLSPIKE);
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_PLUS_TWO);
            effect eMoveDecrease = EffectMovementSpeedDecrease(50);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMoveDecrease, oTarget, RoundsToSeconds(1));

        }
    }
}