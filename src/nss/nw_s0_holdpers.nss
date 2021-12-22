//::///////////////////////////////////////////////
//:: Hold Person
//:: NW_S0_HoldPers
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
//:: The target freezes in place, standing helpless.
//:: He is aware and breathes normally but cannot take any physical
//:: actions, even speech. He can, however, execute purely mental actions.
//:: winged creature that is held cannot flap its wings and falls.
//:: A swimmer can't swim and may drown.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Soleski
//:: Created On: Jan 18, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 10, 2001
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: updated:   6/17/2016   msheeler    added secondary effects and adjusted durations

#include "NW_I0_SPELLS"
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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLvl = GetCasterLevel(OBJECT_SELF);
    int nMeta = GetMetaMagicFeat();
    //split durations for secondary effects
    int nDuration1 = 2;
    int nDuration2 = nCasterLvl;
    effect eParal = EffectParalyze();
    effect eVis = EffectVisualEffect(82);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eDur2 = EffectVisualEffect(VFX_DUR_PARALYZED);
    effect eDur3 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
    effect eSlow = EffectMovementSpeedDecrease(20);

    effect eLink = EffectLinkEffects(eDur2, eDur);
    eLink = EffectLinkEffects(eLink, eParal);
    eLink = EffectLinkEffects(eLink, eVis);
    eLink = EffectLinkEffects(eLink, eDur3);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HOLD_PERSON));
        //Make sure the target is a humanoid
        if (GetIsPlayableRacialType(oTarget) ||
            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_GOBLINOID ||
            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_MONSTROUS ||
            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_ORC ||
            GetRacialType(oTarget) == RACIAL_TYPE_HUMANOID_REPTILIAN)
        {
            //Make SR Check
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                //Make Will save
                if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
                {
                    //check for epic spell focus
                     if (GetHasFeat( FEAT_SPELL_FOCUS_ENCHANTMENT, OBJECT_SELF ))
                     {
                        effect eSlow = EffectMovementSpeedDecrease(25);
                     }
                     if (GetHasFeat( FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, OBJECT_SELF ))
                     {
                        effect eSlow = EffectMovementSpeedDecrease(30);
                     }
                     if (GetHasFeat( FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, OBJECT_SELF ))
                     {
                        effect eSlow = EffectMovementSpeedDecrease(35);
                        nDuration1 = nDuration1 + 1;
                        nDuration2 = nDuration2 + 1;
                     }

                    //Make metamagic extend check
                    if (nMeta == METAMAGIC_EXTEND)
                    {
                        nDuration1 = nDuration1 * 2;
                        nDuration2 = nDuration2 * 2;
                    }
                    //Apply paralyze effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration1));
                    if (GetIsImmune (oTarget, IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF) == FALSE)
                    {
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds(nDuration2));
                    }
                }
            }
        }
    }
}
