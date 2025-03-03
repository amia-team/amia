//::///////////////////////////////////////////////
//:: Virtue
//:: NW_S0_Virtue.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target gains 1 temporary HP
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 6, 2001
//:://////////////////////////////////////////////

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
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
    effect eHP = EffectTemporaryHitpoints(1);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink;

     if ( GetHasEffect( EFFECT_TYPE_TEMPORARY_HITPOINTS, oTarget ))
     {
            return;
     }
    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    if (GetHasFeat( FEAT_SPELL_FOCUS_TRANSMUTATION, OBJECT_SELF ))
    {
                eHP = EffectTemporaryHitpoints(10);
    }
    if (GetHasFeat( FEAT_GREATER_SPELL_FOCUS_TRANSMUTATION, OBJECT_SELF ))
    {
                eHP = EffectTemporaryHitpoints(20);
    }
    if (GetHasFeat( FEAT_EPIC_SPELL_FOCUS_TRANSMUTATION, OBJECT_SELF ))
    {
                eHP = EffectTemporaryHitpoints(30);
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_VIRTUE, FALSE));

    eLink = EffectLinkEffects(eHP, eDur);
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

