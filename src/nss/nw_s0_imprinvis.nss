///::///////////////////////////////////////////////
//:: Improved Invisibility
//:: NW_S0_ImprInvis.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Target creature can attack and cast spells while
    invisible
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "inc_td_shifter"
#include "inc_domains"

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
    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_MIND);

    effect eInvis = EffectInvisibility(INVISIBILITY_TYPE_NORMAL);

    effect eVis = EffectVisualEffect(VFX_DUR_INVISIBILITY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eCover = EffectConcealment(50);
    effect eLink = EffectLinkEffects(eDur, eCover);
    eLink = EffectLinkEffects(eLink, eVis);


    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_IMPROVED_INVISIBILITY, FALSE));
    int iCL = GetIsObjectValid(oCasterItem)?GetCasterLevel(OBJECT_SELF):GetNewCasterLevel(OBJECT_SELF);
    int nDuration = iCL;
    int nMetaMagic = GetMetaMagicFeat();
    //Enter Metamagic conditions
    if (GetIsPolymorphed(OBJECT_SELF)){/*Disable metamagic if shifted*/}
    else if (nMetaMagic == METAMAGIC_EXTEND || GetHasFeat( FEAT_ILLUSION_DOMAIN_POWER, OBJECT_SELF) == TRUE || GetHasFeat( FEAT_GNOME_DOMAIN_POWER, OBJECT_SELF) == TRUE)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //BH: If polymorphed, whatever they cast is created by their skin
    if(GetIsPolymorphed( OBJECT_SELF )&&
       !GetIsObjectValid(oCasterItem))
    {
        eLink = EffectShifterEffect( eLink, OBJECT_SELF);
        eInvis = EffectShifterEffect( eInvis, OBJECT_SELF);
    }

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInvis, oTarget, TurnsToSeconds(nDuration));
}


