//::///////////////////////////////////////////////
//:: Resistance
//:: NW_S0_Resis
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: This spell gives the recipiant a +1 bonus to
//:: all saves.  It lasts for 1 Turn.
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/12/01
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: VFX Pass By: Preston W, On: Aug 7, 2001

// Updated 17/02/2012 by PaladinOfSune; Abjuration focus buffs.

#include "x2_inc_spellhook"

void main()
{
    CantripRefresh();
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
    effect eSave;
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    int nBonus = 1; //Saving throw bonus to be applied
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = 2; // Turns
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RESISTANCE, FALSE));

    float fDuration = TurnsToSeconds( nDuration ) ;
    int   nCasterLevel = GetCasterLevel( OBJECT_SELF );

    // Seek out Spell Foci
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        fDuration = TurnsToSeconds( nCasterLevel );
    }
    else if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        fDuration = RoundsToSeconds( nCasterLevel * 4 );
    }
    else if (GetHasFeat(FEAT_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        fDuration = RoundsToSeconds( nCasterLevel * 2 );
    }

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fDuration = fDuration * 2;
    }
    //Set the bonus save effect
    eSave = EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus);
    effect eLink = EffectLinkEffects(eSave, eDur);

    //Apply the bonus effect and VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
}
