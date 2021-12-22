//::///////////////////////////////////////////////
//:: Color Spray
//:: NW_S0_ColSpray.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A cone of sparkling lights flashes out in a cone
    from the casters hands affecting all those within
    the Area of Effect.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: July 25, 2001
//:://////////////////////////////////////////////

// 11/7/2016    msheeler    Color spray: Spell Focus adds +1d6 fire damage,
//                          Greater Spell Focus adds +1d6 Acid damage, Epic
//                          Spell Focus ads +1d6 electric damage and +1 round
//                          to the CC effects.

#include "X0_I0_SPELLS"
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
    int nMetaMagic = GetMetaMagicFeat();
    int nHD;
    int nDuration;
    int nDamage;
    float fDelay;
    float fDelayNew;
    object oTarget;
    effect eSleep = EffectSleep();
    effect eStun = EffectStunned();
    effect eBlind = EffectBlindness();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink1 = EffectLinkEffects(eSleep, eMind);

    effect eLink2 = EffectLinkEffects(eStun, eMind);
    eLink2 = EffectLinkEffects(eLink2, eDur);

    effect eLink3 = EffectLinkEffects(eBlind, eMind);

    effect eVis1 = EffectVisualEffect(VFX_IMP_SLEEP);
    effect eVis2 = EffectVisualEffect(VFX_IMP_STUN);
    effect eVis3 = EffectVisualEffect(VFX_IMP_BLIND_DEAF_M);

    //Get first object in the spell cone
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE);
    //Cycle through the target until the current object is invalid
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_COLOR_SPRAY));
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/30;
            fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/15;
            if(!MyResistSpell(OBJECT_SELF, oTarget, fDelay) && oTarget != OBJECT_SELF)
            {
                if(!MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
                {
                      nDuration = 3 + d4();
                      nDamage = d6(1);
                      //Enter Metamagic conditions
                      if (nMetaMagic == METAMAGIC_MAXIMIZE)
                      {
                         nDuration = 7;//Damage is at max
                         nDamage = 6;
                      }
                      // added for new effect
                      if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
                      {
                        nDuration = nDuration +1;
                      }
                      else if (nMetaMagic == METAMAGIC_EMPOWER)
                      {
                         nDuration = nDuration + (nDuration/2); //Damage/Healing is +50%
                         nDamage = nDamage + (nDamage/2);
                      }
                      else if (nMetaMagic == METAMAGIC_EXTEND)
                      {
                         nDuration = nDuration *2;  //Duration is +100%
                      }

                    //new effects
                    effect eFireDam = EffectDamage( nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_NORMAL);
                    effect eFireVis = EffectVisualEffect(VFX_IMP_FLAME_S);
                    effect eLinkFire = EffectLinkEffects(eFireDam, eFireVis);
                    effect eAcidDam = EffectDamage( nDamage, DAMAGE_TYPE_ACID, DAMAGE_POWER_NORMAL);
                    effect eAcidVis = EffectVisualEffect(VFX_IMP_ACID_S);
                    effect eLinkAcid = EffectLinkEffects(eAcidDam, eAcidVis);
                    effect eElecDam = EffectDamage( nDamage, DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_NORMAL);
                    effect eElecVis = EffectVisualEffect(VFX_IMP_LIGHTNING_S);
                    effect eLinkElec = EffectLinkEffects(eElecDam,eElecVis);

                    //apply new effects
                    if (GetHasFeat(FEAT_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
                    {
                        DelayCommand(fDelayNew, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkFire, oTarget));
                    }
                    if (GetHasFeat(FEAT_GREATER_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
                   {
                        DelayCommand(fDelayNew, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkAcid, oTarget));
                    }
                    if (GetHasFeat(FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF))
                    {
                        DelayCommand(fDelayNew, ApplyEffectToObject(DURATION_TYPE_INSTANT, eLinkElec, oTarget));
                    }


                    nHD = GetHitDice(oTarget);
                    if(nHD <= 2)
                    {
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis1, oTarget));
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink1, oTarget, RoundsToSeconds(nDuration)));
                    }
                    else if(nHD > 2 && nHD < 5)
                    {
                         nDuration = nDuration - 1;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis3, oTarget));
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink3, oTarget, RoundsToSeconds(nDuration)));                }
                    else
                    {
                         nDuration = nDuration - 2;
                         //Apply the VFX impact and effects
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                         DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink2, oTarget, RoundsToSeconds(nDuration)));
                    }

                }
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, GetSpellTargetLocation(), TRUE);
    }
}

