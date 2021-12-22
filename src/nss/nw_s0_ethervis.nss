//::///////////////////////////////////////////////
//:: Ethereal Visage
//:: NW_S0_EtherVis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Caster gains 20/+3 Damage reduction and is immune
    to 2 level spells and lower.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////


// 11/13/2016   msheeler    Ethereal visage: Spell Focus and Greater Spell Focus
//                          add 5% concealment and 5/+3 DR, ending at 35% concealment
//                          and 30/+3 DR. Epic Focus allows the spell to last Turns/level.

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


    object oTarget = GetSpellTargetObject();
    int nBonus = 0;

    //incerted check to adjust bonus based on feats
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        nBonus = 5;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        nBonus = 10;
    }

    effect eVis = EffectVisualEffect(VFX_DUR_ETHEREAL_VISAGE);
    effect eDam = EffectDamageReduction((20 + nBonus), DAMAGE_POWER_PLUS_THREE);
    effect eSpell = EffectSpellLevelAbsorption(2);
    effect eConceal = EffectConcealment(25 + nBonus);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);



    effect eLink = EffectLinkEffects(eDam, eVis);
    eLink = EffectLinkEffects(eLink, eSpell);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eConceal);

    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = GetCasterLevel(OBJECT_SELF);

    //added bonus duration for epic focus
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        nDuration = nDuration * 10;
    }

    //Enter Metamagic conditions
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ETHEREAL_VISAGE, FALSE));

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

