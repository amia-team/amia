//::///////////////////////////////////////////////
//:: Spell Turning
//:: NW_S0_SpTurn.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Absorbes 1d8 + 8 spell levels before disapearing.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

// Updated 17/02/2012 by PaladinOfSune; Abjuration focus buffs.

#include "nw_i0_spells"
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
    effect eVis = EffectVisualEffect(VFX_DUR_SPELLTURNING);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nAbsorb = d8() + 8;
    int nAbsorbBonus = 0;
    int nMetaMagic = GetMetaMagicFeat();

    // Seek out Spell Foci
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        nAbsorbBonus = d3( 3 );
    }
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        nAbsorbBonus = d3( 2 );
    }
    else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        nAbsorbBonus = d3();
    }

    nAbsorb = nAbsorb + nAbsorbBonus;

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        // Seek out Spell Foci
        if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
        {
            nAbsorbBonus = 9;
        }
        else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
        {
            nAbsorbBonus = 6;
        }
        else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
        {
            nAbsorbBonus = 3;
        }

        nAbsorb = 16 + nAbsorbBonus;//Damage is at max
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
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SPELL_MANTLE, FALSE));

    RemoveEffectsFromSpell(oTarget, GetSpellId());
    RemoveEffectsFromSpell(oTarget, SPELL_LESSER_SPELL_MANTLE);
    RemoveEffectsFromSpell(oTarget, SPELL_GREATER_SPELL_MANTLE);

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}


