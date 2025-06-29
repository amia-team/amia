//::///////////////////////////////////////////////
//:: Lesser Spell Mantle
//:: NW_S0_LsSpTurn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Absorbs 1d4 + 6 spell levels before collapsing
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

// Updated 17/02/2012 by PaladinOfSune; Abjuration focus buffs.

#include "nw_i0_spells"

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
    object oCasterItem = GetSpellCastItem();
    effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int iCL = GetIsObjectValid(oCasterItem)?GetCasterLevel(OBJECT_SELF):GetNewCasterLevel(OBJECT_SELF);
    int nDuration = iCL;
    int nAbsorb = d4() + 6;
    int nAbsorbBonus = 0;
    int nMetaMagic = GetMetaMagicFeat();

    // Seek out Spell Foci
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        nAbsorbBonus = 3;
    }
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        nAbsorbBonus = 2;
    }
    else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        nAbsorbBonus = 1;
    }

    nAbsorb = nAbsorb + nAbsorbBonus;

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nAbsorb = 10 + nAbsorbBonus;//Damage is at max
    }
    else if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nAbsorb = nAbsorb + (nAbsorb/2); //Damage/Healing is +50%
    }
    else if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Link Effects
    effect eAbsob = EffectSpellLevelAbsorption(9, nAbsorb);
    effect eLink = EffectLinkEffects(eVis, eAbsob);
    eLink = EffectLinkEffects(eLink, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LESSER_SPELL_MANTLE, FALSE));
    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemoveEffectsFromSpell(oTarget, SPELL_GREATER_SPELL_MANTLE);
    RemoveEffectsFromSpell(oTarget, SPELL_SPELL_MANTLE);
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

