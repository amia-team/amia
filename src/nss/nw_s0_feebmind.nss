//::///////////////////////////////////////////////
//:: Feeblemind
//:: [NW_S0_FeebMind.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Target must make a Will save or take ability
//:: damage to Intelligence equaling 1d4 per 4 levels.
//:: Duration of 1 rounds per 2 levels.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 2, 2001
//:://////////////////////////////////////////////
// 7/18/2016   msheeler   fixed bioware miss calculation of maximze effect and added bonus drains for spell focus

#include "NW_I0_SPELLS"
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
    int nDuration = GetCasterLevel(OBJECT_SELF)/2;
    int nLoss = GetCasterLevel(OBJECT_SELF)/4;
    //Check to make at least 1d4 damage is done
    if (nLoss < 1)
    {
        nLoss = 1;
    }
    //nLoss = d4(nLoss);   <-- left this in here because its kinda funny how bad bioware screwed it up.
    //Check to make sure the duration is 1 or greater
    if (nDuration < 1)
    {
        nDuration == 1;
    }
    int nMetaMagic = GetMetaMagicFeat();
    effect eFeeb;
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eRay = EffectBeam(VFX_BEAM_MIND, OBJECT_SELF, BODY_NODE_HAND);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_FEEBLEMIND));
        //Make SR check
        if (!MyResistSpell(OBJECT_SELF, oTarget))
        {
            //Make an will save

            int nWillResult =  WillSave(oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS);
            if (nWillResult == 0)
            {
                 //Enter Metamagic conditions
                  if (nMetaMagic == METAMAGIC_MAXIMIZE)
                  {
                     nLoss =  nLoss * 4;
                  }
                  if (nMetaMagic == METAMAGIC_EMPOWER)
                  {
                     nLoss = d4(nLoss);
                     nLoss = nLoss + (nLoss/2);
                  }
                  if (nMetaMagic == METAMAGIC_EXTEND)
                  {
                     nDuration = nDuration * 2;
                  }
                  //Set the ability damage
                  eFeeb = EffectAbilityDecrease(ABILITY_INTELLIGENCE, nLoss);
                  effect eLink = EffectLinkEffects(eFeeb, eDur);

                  //Apply the VFX impact and ability damage effect.
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.0);
                  ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

                  //add bonnus effects for speel foci
                  if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_DIVINATION, OBJECT_SELF))
                  {
                     effect eFeebCHA = EffectAbilityDecrease(ABILITY_CHARISMA, nLoss);
                     ApplyEffectToObject (DURATION_TYPE_TEMPORARY, eFeebCHA, oTarget, RoundsToSeconds(nDuration));
                  }
                  if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_DIVINATION, OBJECT_SELF))
                  {
                     effect eFeebWIS = EffectAbilityDecrease (ABILITY_WISDOM, nLoss);
                     ApplyEffectToObject (DURATION_TYPE_TEMPORARY, eFeebWIS, oTarget, RoundsToSeconds(nDuration));
                  }
            }
            else
            // * target was immune
            if (nWillResult == 2)
            {
                SpeakStringByStrRef(40105, TALKVOLUME_WHISPER);
            }
        }
    }
}
