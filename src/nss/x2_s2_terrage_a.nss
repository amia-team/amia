//::///////////////////////////////////////////////
//:: Terrifying Rage Script
//:: x2_s2_terrage_a.nss
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Upon entering the aura of the creature the player
    must make a will save or be struck with fear because
    of the creatures presence.

    - Save DC is a Intimidate check result of the raging character

    - If the creature has less HitDice than the barbarian they freeze in terror 1d3 rounds

    - if the creature has less HD than the BarbarianHD*2, they are shaken (-2 to attack, -2 to saves)

    - if the creature has more than double HD than the Barb, they are immune to the effect

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-10
//:://////////////////////////////////////////////
#include "NW_I0_SPELLS"
#include "x2_i0_spells"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
    effect eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink;

    object oBarb =GetAreaOfEffectCreator();
    int nHD = GetHitDice(GetAreaOfEffectCreator());
    effect eImmunity = EffectImmunity(IMMUNITY_TYPE_FEAR);
    int nDC = 8 + ( GetSkillRank(SKILL_INTIMIDATE,oBarb,TRUE)/2 ) + ( GetLevelByClass(CLASS_TYPE_BARBARIAN,oBarb)/2 );
    int nDuration = d3();

    if(GetIsEnemy(oTarget, oBarb))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oBarb, GetSpellId()));
        //Make a saving throw check

          if(!MySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_FEAR))
            {
                // Hit dice below barb.... run like hell!
                if (GetHitDice(oTarget)< GetHitDice(oBarb))
                {
                    //Apply the VFX impact and effects
                    effect eParalyze = EffectParalyze();
                    effect eFear = EffectFrightened();
                    eLink = EffectLinkEffects(eVis, eDur);
                    eLink = EffectLinkEffects(eLink, eDur2);

                    // New vfxs
                    float fDuration=RoundsToSeconds(nDuration);

                    // Candy (Fear skulls)
                    ApplyEffectToObject(
                        DURATION_TYPE_TEMPORARY,
                        eLink,
                        oTarget,
                        fDuration);

                    // VFX i: Paralysis
                    ApplyEffectToObject(
                        DURATION_TYPE_TEMPORARY,
                        eParalyze,
                        oTarget,
                        fDuration);

                    // VFX ii: Fear
                    ApplyEffectToObject(
                        DURATION_TYPE_TEMPORARY,
                        eFear,
                        oTarget,
                        fDuration);

                    //eLink = ExtraordinaryEffect(eLink);
                    //ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                    //ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    PlayVoiceChat(VOICE_CHAT_HELP,oTarget);
                    DelayCommand(RoundsToSeconds(nDuration),ApplyEffectToObject(
                        DURATION_TYPE_TEMPORARY,
                        eImmunity,
                        oTarget,
                        RoundsToSeconds(5)));
                }
                // Up to twice the barbs HD ... shaken
                else if (GetHitDice(oTarget)< GetHitDice(oBarb)*2)
                {
                    effect eShake1 = EffectSavingThrowDecrease(SAVING_THROW_ALL,2);
                    effect eShake2 = EffectAttackDecrease(2);
                    eLink = EffectLinkEffects(eShake1, eDur);
                    eLink = EffectLinkEffects(eLink, eShake2);
                    eLink = EffectLinkEffects(eLink, eDur2);
                    //eLink = ExtraordinaryEffect(eLink);
                    FloatingTextStrRefOnCreature(83583,oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    DelayCommand(RoundsToSeconds(nDuration),ApplyEffectToObject(
                        DURATION_TYPE_TEMPORARY,
                        eImmunity,
                        oTarget,
                        RoundsToSeconds(5)));
                 }
                 else
                 {

                    // They gain immunity to fear for 5 rounds
                    ApplyEffectToObject(
                        DURATION_TYPE_TEMPORARY,
                        eImmunity,
                        oTarget,
                        RoundsToSeconds(5));
                 }
          }
      }

}
