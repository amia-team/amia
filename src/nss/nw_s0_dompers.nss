// nw_s0_dompers - Dominate Person
// Copyright (c) 2001 Bioware Corp.
//
// Will save or the target is dominated for 1 round per caster level.
//
// Revision History
// Date       Name                Description
// ---------- ------------------  --------------------------------------------
// 01/29/2001 Preston Watamaniuk  Initial Release
// 08/16/2003 jpavelch            Added check for PC outsider subrace.
// 12/10/2005 kfw                 disabled SEI, True Races compatibility

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_domains"
//#include "subraces"


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
    effect eDom = EffectDominated();
    eDom = GetScaledEffect(eDom, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //added secondary effect for PCs
    effect eDecreaseWill  = EffectSavingThrowDecrease (SAVING_THROW_WILL, 2);

    //Link duration effects
    effect eLink = EffectLinkEffects(eMind, eDom);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
    int nMetaMagic = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDuration = 2 + nCasterLevel/3;
    //added secondary duration for effect vs. PC
    int nDurationPC = 5;
    nDuration = GetScaledDuration(nDuration, oTarget);
    int nRacial = GetRacialType(oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_PERSON, FALSE));
    //Make sure the target is a humanoid
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        if  ((nRacial == RACIAL_TYPE_DWARF) ||
            (nRacial == RACIAL_TYPE_ELF) ||
            (nRacial == RACIAL_TYPE_GNOME) ||
            (nRacial == RACIAL_TYPE_HALFLING) ||
            (nRacial == RACIAL_TYPE_HUMAN) ||
            (nRacial == RACIAL_TYPE_HALFELF) ||
            (nRacial == RACIAL_TYPE_HALFORC))
        {
            if ( GetIsPC(oTarget) && GetRacialType(oTarget)==RACIAL_TYPE_OUTSIDER )
                return;

           //Make SR Check
           if (!MyResistSpell(OBJECT_SELF, oTarget))
           {
                //Make Will Save
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, 1.0))
                {
                    //check for epic spell focus
                    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, OBJECT_SELF))
                    {
                        nDuration += 1;
                        nDurationPC += 1;
                    }
                    //Check for metamagic extension
                    if (nMetaMagic == METAMAGIC_EXTEND || GetHasFeat( FEAT_TYRANNY_DOMAIN_POWER, OBJECT_SELF))
                    {
                        nDuration = nDuration * 2;
                        nDurationPC = nDurationPC * 2;
                    }
                    //Apply linked effects and VFX impact
                    if (GetIsPC (oTarget))
                    {
                        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDurationPC)));
                        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDecreaseWill, oTarget, RoundsToSeconds(nDuration)));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                    else
                    {
                        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration)));
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    }
                }
            }
        }
    }
}
