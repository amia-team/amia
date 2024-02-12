//::///////////////////////////////////////////////
//:: Color of Spring
//:: amx_csp_colsprin.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Color of Spring (Transmutation)
Level: Druid 6
Components: V,S
Range: Personal
Area of effect: Large
Duration: Instantaneous
Valid Metamagic: Still, Extend, Silent, Empower, Maximize
Save: Special
Spell Resistance: No/Yes (See Description)

This spell brings new beginnings to those around the caster. Centered around the caster, all natural living allies (as in not undead, constructs, outsiders, or abberations) in a 20 foot radius will be subject to a restoration spell and be healed 1d8+caster level hit points.

Any enemy undead in the radius will need to make a will save or be turned for 1d6 rounds.
Any enemy abberations in the radius will need to make a will save or be stunned for 1d6 rounds.
Any enemy constructs in the radius will need to make a fortitude save or be knocked down for 1d6 rounds
Any enemy outsiders in the radius will need to make a fortitude save or be dazed for 1d6 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: Feb 12, 2024
//:://////////////////////////////////////////////
//::

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"


int isUnnatural(object oCreature) {
    int iRtype = GetRacialType(oCreature);

    if (iRtype == RACIAL_TYPE_ABERRATION || iRtype == RACIAL_TYPE_CONSTRUCT ||
        iRtype == RACIAL_TYPE_OUTSIDER || iRtype == RACIAL_TYPE_UNDEAD) {
        return TRUE;
    }
    return FALSE;
}

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

    //Declare major variables
    effect eHeal;
    effect eVis = EffectVisualEffect(VFX_IMP_HEALING_L);
    effect eSR;
    effect eNature = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);

    int nRand, nNumDice;
    int nCasterLevel = GetNewCasterLevel(OBJECT_SELF);
    //Determine spell duration as an integer for later conversion to Rounds, Turns or Hours.
    int nMetaMagic = GetMetaMagicFeat();
    float fDelay;
    //Set off fire and forget visual
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eNature, GetLocation(OBJECT_SELF));

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        //Check to see how the caster feels about the targeted object
        if(GetIsFriend(oTarget)) {
            if (isUnnatural(oTarget) == FALSE) {
              //Fire cast spell at event for the specified target
              SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NATURES_BALANCE, FALSE));
              nRand = d8(1) + nCasterLevel;
              //Enter Metamagic conditions
              if (nMetaMagic == METAMAGIC_MAXIMIZE)
              {
                 nRand = 8 + nCasterLevel;//Damage is at max
              }
              else if (nMetaMagic == METAMAGIC_EMPOWER)
              {
                 nRand = nRand + nRand/2; //Damage/Healing is +50%
              }
              eHeal = EffectHeal(nRand);
              //Apply heal effects
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, oTarget));
              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
              DelayCommand(fDelay, ExecuteScript("nw_s0_restore",oTarget));
            }
        } else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))  {
            if (isUnnatural(oTarget)) {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NATURES_BALANCE));
                if(!GetIsReactionTypeFriendly(oTarget)) {
                    if (!MyResistSpell(OBJECT_SELF, oTarget)) {
                        //Check for saving throw
                        int iRType = GetRacialType(oTarget);
                        if (iRType == RACIAL_TYPE_UNDEAD) {
                            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC() )))
                            {
                              int nRounds = d6(1);
                              //Enter Metamagic conditions
                              if (nMetaMagic == METAMAGIC_EXTEND)
                              {
                                 nRounds = nRounds * 2;
                              }
                              effect eDebuff = EffectTurned();
                              effect eVis2 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);

                              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oTarget, RoundsToSeconds(nRounds)));
                              DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                            }
                        } else if (iRType == RACIAL_TYPE_ABERRATION) {
                            if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC() )))
                                {
                                  int nRounds = d6(1);
                                  //Enter Metamagic conditions
                                  if (nMetaMagic == METAMAGIC_EXTEND)
                                  {
                                     nRounds = nRounds * 2;
                                  }
                                  effect eDebuff = EffectStunned();
                                  //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                                  //effect eLink = EffectLinkEffects(eDebuff, eDur);
                                  effect eVis2 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);

                                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oTarget, RoundsToSeconds(nRounds)));
                                  DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                            }
                        } else if (iRType == RACIAL_TYPE_CONSTRUCT) {
                            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC() )))
                            {
                               int nRounds = d6(1);
                               //Enter Metamagic conditions
                               if (nMetaMagic == METAMAGIC_EXTEND)
                               {
                                  nRounds = nRounds * 2;
                               }
                               effect eDebuff = EffectKnockdown();
                               //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                               //effect eLink = EffectLinkEffects(eDebuff, eDur);
                               effect eVis2 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);

                               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oTarget, RoundsToSeconds(nRounds)));
                               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                            }
                        } else if (iRType == RACIAL_TYPE_OUTSIDER) {
                            if (!MySavingThrow(SAVING_THROW_FORT, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC() )))
                            {
                               int nRounds = d6(1);
                               //Enter Metamagic conditions
                               if (nMetaMagic == METAMAGIC_EXTEND)
                               {
                                  nRounds = nRounds * 2;
                               }
                               effect eDebuff = EffectDazed();
                               //effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                               //effect eLink = EffectLinkEffects(eDebuff, eDur);
                               effect eVis2 = EffectVisualEffect(VFX_FNF_GAS_EXPLOSION_NATURE);

                               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDebuff, oTarget, RoundsToSeconds(nRounds)));
                               DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                            }
                        }
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE);
    }
}
