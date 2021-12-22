//::///////////////////////////////////////////////
//:: Mage Armor
//:: [NW_S0_MageArm.nss]
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the target +1 AC Bonus to Deflection,
    Armor Enchantment, Natural Armor and Dodge.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 22, 2001

/*
bugfix by Kovi 2002.07.23
- dodge bonus was stacking
*/

// 11/12/2016   msheeler    Shadow Mage Armor: Replace old effect entirely with:
//                          Applies 5/- cold and negative energy resistance for duration.
//                          Epic Focus each add 5/- resist to each of cold and negative.

#include "nw_i0_spells"
#include "amia_include"
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
    int nDuration = GetNewCasterLevel( OBJECT_SELF );
    int nMetaMagic = GetMetaMagicFeat();
    int nRes = 5;
    int nSpellId = GetSpellId();
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eAC1, eAC2, eAC3, eAC4;
    effect eResistNeg;
    effect eResistCold;
    effect eLink;

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MAGE_ARMOR, FALSE));
    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }
    //Set the four unique armor bonuses
    eAC1 = EffectACIncrease(1, AC_ARMOUR_ENCHANTMENT_BONUS);
    eAC2 = EffectACIncrease(1, AC_DEFLECTION_BONUS);
    eAC3 = EffectACIncrease(1, AC_DODGE_BONUS);
    eAC4 = EffectACIncrease(1, AC_NATURAL_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLinkMA = EffectLinkEffects(eAC1, eAC2);
    eLinkMA = EffectLinkEffects(eLinkMA, eAC3);
    eLinkMA = EffectLinkEffects(eLinkMA, eAC4);
    eLinkMA = EffectLinkEffects(eLinkMA, eDur);

    //new effects for shadow mage armor
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        nRes += 5;
    }
    eResistNeg = EffectDamageResistance(DAMAGE_TYPE_COLD, nRes, 0);
    eResistCold = EffectDamageResistance(DAMAGE_TYPE_NEGATIVE, nRes, 0);
    effect eLinkShadMA = EffectLinkEffects (eResistNeg, eResistCold);
    //eLink = EffectLinkEffects (eLinkMA, eLinkShadMA);

    if (nSpellId == SPELL_MAGE_ARMOR)
    {
        RemoveEffectsFromSpell(oTarget, SPELL_MAGE_ARMOR);  //stops stacking
    }
    if (nSpellId == SPELL_SHADOW_CONJURATION_MAGE_ARMOR)
    {
        RemoveEffectsFromSpell(oTarget, SPELL_SHADOW_CONJURATION_MAGE_ARMOR);   //stops stacking
    }

    //Apply the armor bonuses and the VFX impact
    if (nSpellId == SPELL_MAGE_ARMOR)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkMA, oTarget, NewHoursToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
    if (nSpellId == SPELL_SHADOW_CONJURATION_MAGE_ARMOR)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkShadMA, oTarget, NewHoursToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }
}
