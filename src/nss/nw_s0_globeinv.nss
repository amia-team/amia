//::///////////////////////////////////////////////
//:: Globe of Invulnerability
//:: NW_S0_GlobeInv.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster is immune to 4th level spells or lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001

// Updated 17/02/2012 by PaladinOfSune; Abjuration focus buffs.

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
    effect eVis = EffectVisualEffect(VFX_DUR_GLOBE_INVULNERABILITY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSpell = EffectSpellLevelAbsorption(4, 0);
    //Link Effects
    effect eLink = EffectLinkEffects(eVis, eSpell);
    eLink = EffectLinkEffects(eLink, eDur);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    float fDuration = RoundsToSeconds( nDuration );
    int nMetaMagic = GetMetaMagicFeat();
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_GLOBE_OF_INVULNERABILITY, FALSE));

    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ABJURATION, OBJECT_SELF))
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
}

