//::///////////////////////////////////////////////
//:: Ghostly Visage
//:: NW_S0_MirrImage.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 5/+1 Damage reduction and immunity
    to 1st level spells.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2001
//:://////////////////////////////////////////////

// 11/7/2016    msheeler    Ghostly visage: Each Spell Focus adds +5% Concealment
//                          and 5 DR/+1, ending at 25% concealment and 20/+1 DR at epic.

#include "x2_inc_spellhook"

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
    int nConcealment = 10;
    int nDamReduction = 5;
    effect eVis = EffectVisualEffect(VFX_DUR_GHOSTLY_VISAGE);
    effect eSpell = EffectSpellLevelAbsorption(1);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);

    //determin bonus for spell foci
    if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        nConcealment += 5;
        nDamReduction += 5;
    }

    if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        nConcealment += 5;
        nDamReduction += 5;
    }
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        nConcealment += 5;
        nDamReduction += 5;
    }

    //some effects moved here to determin new bonuses
    effect eConceal = EffectConcealment(nConcealment);
    effect eDam = EffectDamageReduction(nDamReduction, DAMAGE_POWER_PLUS_ONE);
    effect eLink = EffectLinkEffects(eDam, eVis);
    eLink = EffectLinkEffects(eLink, eSpell);
    eLink = EffectLinkEffects(eLink, eConceal);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GHOSTLY_VISAGE, FALSE));

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

