//::///////////////////////////////////////////////
//:: Web: On Enter
//:: NW_S0_WebA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a mass of sticky webs that cling to
    and entangle targets who fail a Reflex Save
    Those caught can make a new save every
    round.  Movement in the web is 1/5 normal.
    The higher the creatures Strength the faster
    they move within the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://////////////////////////////////////////////
//:: Bug fixes by: PoS, On: July 10, 2013

//  12/4/2016   msheeler    Greater Shadow Conjuration Web: Targets affected by
//                          the web take 2d6 cold and negative damage per round while
//                          entangled. Greater and Epic spell focus add +1d6 to each
//                          damage type.
//  1/27/2017   msheeler    Reverse mathed the DCs so we can use Illusion spell feats
//                          for Greater Shadow Conjuration Web. Also moved the damage
//                          calculation to increase variance in the rolls.

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"
void main()
{

    //Declare major variables
    effect eWeb = EffectEntangle();
    effect eVis = EffectVisualEffect(VFX_DUR_WEB);
    effect eLink = EffectLinkEffects(eWeb, eVis);
    object oTarget = GetEnteringObject();
    object oCaster = GetAreaOfEffectCreator();
    effect eDex   =  EffectAbilityIncrease( ABILITY_DEXTERITY, 1 );
    int nDamage;
    int nDice = 2;
    int nDC = GetSpellSaveDC();
    effect eCold;
    effect eNeg;
    effect eColdVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eNegVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eLinkCold;
    effect eLinkNeg;
    string sWebTag = GetTag(OBJECT_SELF);

    //Determine Damage and proper DC for Greater Shadow Conj Web
    int nSpellId = GetLocalInt(OBJECT_SELF, "nSpellId");

    if (nSpellId == SPELL_GREATER_SHADOW_CONJURATION_WEB)
    {
        if (GetHasFeat (FEAT_SPELL_FOCUS_ILLUSION, oCaster))
        {
            nDC = nDC + 2;
        }
        if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_ILLUSION, oCaster))
        {
            nDice = 3;
            nDC = nDC + 2;
        }
        if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ILLUSION, oCaster))
        {
            nDice = 4;
            nDC = nDC + 2;
        }
        if (GetHasFeat (FEAT_SPELL_FOCUS_CONJURATION, oCaster))
        {
            nDC = nDC - 2;
        }
        if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster))
        {
            nDC = nDC - 2;
        }
        if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster))
        {
            nDC = nDC - 2;
        }
    }

    // * the lower the number the faster you go
    int nSlow = 65 - (GetAbilityScore(oTarget, ABILITY_STRENGTH)*2);
    if (nSlow <= 0)
    {
        nSlow = 1;
    }

    if (nSlow > 99)
    {
        nSlow = 99;
    }

    effect eSlow = EffectMovementSpeedDecrease(nSlow);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
         if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) &&(GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL) != TRUE) )
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), SPELL_WEB));
            //Spell resistance check
            if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
            {
                //Make a Fortitude Save to avoid the effects of the entangle.
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetShifterDC( GetAreaOfEffectCreator(),nDC)))
                {
                    //Entangle effect and Web VFX impact
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1));
                    // Fix dex
                    DelayCommand( 7.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDex, oTarget, 1.0 ) );
                    if (nSpellId == SPELL_GREATER_SHADOW_CONJURATION_WEB)
                        {
                            nDamage = d6(nDice);
                            eCold = EffectDamage (nDamage, DAMAGE_TYPE_COLD);
                            nDamage = d6(nDice);
                            eNeg = EffectDamage (nDamage, DAMAGE_TYPE_NEGATIVE);
                            eLinkCold = EffectLinkEffects (eCold, eColdVis);
                            eLinkNeg = EffectLinkEffects (eNeg, eNegVis);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkCold, oTarget);
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkNeg, oTarget);
                        }
                }
                //Slow down the creature within the Web
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
            }
        }
    }
}
