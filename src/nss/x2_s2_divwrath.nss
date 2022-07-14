//::///////////////////////////////////////////////
//:: Divine Wrath
//:: x2_s2_DivWrath
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The Divine Champion is able to channel a portion
    of their gods power once per day giving them a +3
    bonus on attack rolls, damage, and saving throws
    for a number of rounds equal to their Charisma
    bonus. They also gain damage reduction of +1/5.
    At 10th level, an additional +2 is granted to
    attack rolls and saving throws.

    Epic Progression
    Every five levels past 10 an additional +2
    on attack rolls, damage and saving throws is added. As well the damage
    reduction increases by 5 and the damage power required to penetrate
    damage reduction raises by +1 (to a maximum of /+5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 05, 2003
//:: Updated On: Jul 21, 2003 Georg Zoeller -
//                            Epic Level progession
//:: Updated On: May 18th, 2021 Maverick00053 - Rebalanced to Amia
//:://////////////////////////////////////////////

void coolDown(object oTarget); // Built in cool down

#include "nw_i0_spells"
#include "amx_fallcheck"

void main()
{
    //Declare major variables
    object oTarget = OBJECT_SELF;

    if ( (IsSpecificFallen(oTarget)) ||
         (!DeityCheck(oTarget)) ){
        FloatingTextStringOnCreature( "The plea to your deity is not heard...", oTarget, FALSE );
        return;
    }

    int nMod = GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    if(nMod < 0)
    {
      nMod=0;
    }
    int nDuration = 10 + nMod/2;
    //Check that if nDuration is not above 0, make it 1.
    if(nDuration <= 0)
    {
        FloatingTextStrRefOnCreature(100967,OBJECT_SELF);
        return;
    }

    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_HOLY);
    eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_GOOD_HELP),eVis);
    effect eAttack, eDamage, eSaving, eReduction;
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 621, FALSE));

    int nAttackB = 3;
    int nDamageB = DAMAGE_BONUS_3;
    int nSaveB = 3 ;
    int nDmgRedB = 5;
    int nDmgRedP = DAMAGE_POWER_PLUS_TWO;

    // --------------- Epic Progression ---------------------------

    int nLevel = GetLevelByClass(CLASS_TYPE_DIVINECHAMPION,oTarget) ;
    int cooldown = 300; // Flat 5 minute cool down
    int nLevelB = (nLevel / 5)-1;

    if (nLevelB <=0)
    {
        nLevelB =0;
    }
    else
    {
        nAttackB += (nLevelB*2); // +2 to attack every 5 levels past 5
        nSaveB += (nLevelB*2); // +2 to saves every 5 levels past 5
    }

    if(nLevel == 20)
    {
        nDmgRedP = DAMAGE_POWER_PLUS_SIX;
        nDmgRedB = 20;
        nDamageB = DAMAGE_BONUS_9;
        nDuration = nDuration + 5; // 20 DC adds an extra 5 rounds
    }
    else if(nLevel >= 19)
    {
       nDmgRedP = DAMAGE_POWER_PLUS_FIVE;
       nDmgRedB = 15;
       nDamageB = DAMAGE_BONUS_7;
    }
    else if(nLevel >= 15)
    {
       nDmgRedP = DAMAGE_POWER_PLUS_FOUR;
       nDmgRedB = 10;
       nDamageB = DAMAGE_BONUS_7;
    }
    else if(nLevel >= 10)
    {
       nDmgRedP = DAMAGE_POWER_PLUS_THREE;
       nDmgRedB = 10;
       nDamageB = DAMAGE_BONUS_5;
    }

    /*  Nwn default code
    if (nLevelB >6 )
    {
        nDmgRedP = DAMAGE_POWER_PLUS_FIVE;
        nDmgRedB = 7*5;
        nDamageB = DAMAGE_BONUS_17;
    }
    else if (nLevelB >5 )
    {
        nDmgRedP = DAMAGE_POWER_PLUS_FIVE;
        nDmgRedB = 6*5;
        nDamageB = DAMAGE_BONUS_15;
    }
    else if (nLevelB >4 )   // 30
    {
        nDmgRedP = DAMAGE_POWER_PLUS_FIVE;
        nDmgRedB = 5*5;
        nDamageB = DAMAGE_BONUS_13;
    }
    else if (nLevelB >3)   // 25
    {
        nDmgRedP = DAMAGE_POWER_PLUS_FOUR;
        nDmgRedB = 4*5;
        nDamageB = DAMAGE_BONUS_11;
    }
    else if (nLevelB >2)   // 20
    {
        nDmgRedP = DAMAGE_POWER_PLUS_THREE;
        nDmgRedB = 3*5;
        nDamageB = DAMAGE_BONUS_9;
    }
    else if (nLevelB >1)   // 15
    {
        nDmgRedP = DAMAGE_POWER_PLUS_TWO;
        nDmgRedB = 2*5;
        nDamageB = DAMAGE_BONUS_7;
    }
    else if (nLevelB >0)   // level 10
    {
        nDamageB = DAMAGE_BONUS_5;
    }
    */
    //--------------------------------------------------------------
    //
    //--------------------------------------------------------------

    eAttack = EffectAttackIncrease(nAttackB,ATTACK_BONUS_MISC);
    eDamage = EffectDamageIncrease(nDamageB, DAMAGE_TYPE_DIVINE);
    eSaving = EffectSavingThrowIncrease(SAVING_THROW_ALL,nSaveB, SAVING_THROW_TYPE_ALL);
    eReduction = EffectDamageReduction(nDmgRedB, nDmgRedP);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    effect eLink = EffectLinkEffects(eAttack, eDamage);
    eLink = EffectLinkEffects(eSaving,eLink);
    eLink = EffectLinkEffects(eReduction,eLink);
    eLink = EffectLinkEffects(eDur,eLink);
    eLink = SupernaturalEffect(eLink);

    // prevent stacking with self
    RemoveEffectsFromSpell(oTarget, GetSpellId());


    //Apply the armor bonuses and the VFX impact
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    SendMessageToPC(oTarget, "Divine Wrath will last " +FloatToString(RoundsToSeconds(nDuration),1,1)+ " seconds");
    SendMessageToPC(oTarget, "Divine Wrath will refresh in " +IntToString(cooldown)+ " seconds");
    DelayCommand(IntToFloat(cooldown),coolDown(oTarget));  // Refreshes

}

void coolDown(object oTarget)
{
  IncrementRemainingFeatUses(oTarget,FEAT_DIVINE_WRATH);
  SendMessageToPC(oTarget,"Divine Wrath refreshed!");
}