//::///////////////////////////////////////////////
//:: Displacement
//:: x0_s0_displace
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target gains a 50% concealment bonus.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////

// 11/7/2016    msheeler    Displacement: spell focus makes 3 rounds per level
//                          greater focus makes 5 rounds and epic focus makes turns


#include "x2_inc_spellhook"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
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
    effect eDisplace;
    effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);


    int nMetaMagic = GetMetaMagicFeat();
    int nRaise = GetCasterLevel(OBJECT_SELF) / 2;
    int nLvl = GetCasterLevel(OBJECT_SELF);
    int nDuration = nLvl;

    //adjust duration based on spell focus
    if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        nDuration = nLvl * 3;
    }
    if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        nDuration = nLvl * 5;
    }
    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
    {
        nDuration = nLvl * 10;
    }

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    eDisplace = EffectConcealment(50);
    if (GetEffectType(eDisplace) != EFFECT_TYPE_INVALIDEFFECT)
    {
        effect eLink = EffectLinkEffects(eDisplace, eDur);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DISPLACEMENT, FALSE));

        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }

}




