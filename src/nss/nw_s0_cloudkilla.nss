//::///////////////////////////////////////////////
//:: Cloudkill: On Enter
//:: NW_S0_CloudKillA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures with 3 or less HD die, those with
    4 to 6 HD must make a save Fortitude Save or die.
    Those with more than 6 HD take 1d10 Poison damage
    every round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////
//  7/11/2016   msheeler    added bonus max hd effected for spell focus

#include "X0_I0_SPELLS"

void main()
{


    //Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();
    int nHD = GetHitDice(oTarget);
    int nHDBonus = 0;
    effect eDeath = EffectDeath();
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eSpeed = EffectMovementSpeedDecrease(50);
    effect eVis2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eSpeed, eVis2);

    float fDelay= GetRandomDelay(0.5, 1.5);
    effect eDam;
    int nDam;
    int nDice;
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster))
    {
        nDice = 2;
    }
    else
    {
        nDice = 1;
    }
    nDam = MaximizeOrEmpower (10, nDice, GetMetaMagicFeat(), 0);

    if (GetHasFeat (FEAT_SPELL_FOCUS_CONJURATION, oCaster))
    {
        nHDBonus = 2;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster))
    {
        nHDBonus = 4;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster))
    {
        nHDBonus = 6;
    }

    eDam = EffectDamage(nDam, DAMAGE_TYPE_ACID);
    if(spellsIsTarget(oTarget,SPELL_TARGET_STANDARDHOSTILE , GetAreaOfEffectCreator()) )
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CLOUDKILL));
        //Make SR Check
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget, fDelay))
        {
            //Determine spell effect based on the targets HD
            if (nHD <= 3 + nHDBonus)
            {
                if(!GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                }
            }
            else if (nHD >= 4 + nHDBonus && nHD <= 6 + nHDBonus)
            {
                //Make a save or die
                if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_DEATH, OBJECT_SELF, fDelay))
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                else
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
                    if(!MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                    {
                        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget);
                    }
                }
            }
            else
            {
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eNeg, oTarget));
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSpeed, oTarget);
            }
        }
    }
}
