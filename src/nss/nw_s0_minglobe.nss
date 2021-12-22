//::///////////////////////////////////////////////
//:: Minor Globe of Invulnerability
//:: NW_S0_MinGlobe.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster is immune to 3rd levels spells and lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 22, 2001

// Updated 17/02/2012 by PaladinOfSune; Abjuration focus buffs.
// 12/5/2016    msheeler    Shadow Minor Globe of Invulnerability: As normal - adds
//                          temporary +5 saves vs Cold and Negative energy. Epic
//                          Illusion focus allows spell to last turns/level.

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
    object oTarget = OBJECT_SELF;
    effect eVis = EffectVisualEffect(VFX_DUR_GLOBE_MINOR);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eColdSave = EffectSavingThrowIncrease (SAVING_THROW_ALL, 5, SAVING_THROW_TYPE_COLD);
    effect eNegSave = EffectSavingThrowIncrease (SAVING_THROW_ALL, 5, SAVING_THROW_TYPE_NEGATIVE);
    effect eLinkSave = EffectLinkEffects (eColdSave, eNegSave);
    effect eSpell = EffectSpellLevelAbsorption(3, 0);
    //Link Effects
    effect eLink = EffectLinkEffects(eVis, eSpell);
    eLink = EffectLinkEffects(eLink, eDur);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    float fDuration = RoundsToSeconds( nDuration );
    int nMetaMagic = GetMetaMagicFeat();
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_MINOR_GLOBE_OF_INVULNERABILITY, FALSE));

    if (GetSpellId() == SPELL_MINOR_GLOBE_OF_INVULNERABILITY && GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
    {
        fDuration = TurnsToSeconds( nDuration );
    }
    if(GetSpellId() == SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE && GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        fDuration = TurnsToSeconds( nDuration );
    }

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        fDuration = fDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, fDuration );
    if (GetSpellId() == SPELL_GREATER_SHADOW_CONJURATION_MINOR_GLOBE)
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLinkSave, oTarget, fDuration);
    }
}

