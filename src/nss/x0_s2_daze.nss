//::///////////////////////////////////////////////
//:: [Shadow Daze]
//:: [x0_S2_Daze.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Shadow dancer.
//:: Will save or be dazed for 5 rounds.
//:: Can only daze humanoid-type creatures
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 23, 2002
//:://////////////////////////////////////////////
//:: Update Pass By:
//:: March 2003: Removed humanoid and level checks to
//:: make this a more powerful daze
// Updated by PaladinOfSune, Mar05 2012 - changed uses to give it a cooldown instead.
#include "X0_I0_SPELLS"
void main()
{
    object oPC       = OBJECT_SELF;

    //make sure feat is always available
    IncrementRemainingFeatUses( oPC, FEAT_SHADOW_DAZE );

    //check block time
    if ( GetIsBlocked( oPC, "ds_SD_b" ) > 0 )
    {
        string sRecharge = IntToString( GetIsBlocked( oPC, "ds_SD_b" ) );
        SendMessageToPC( oPC, "You cannot use your Shadow Daze ability for another " +sRecharge+ " seconds!" );
        return;
    }

    int nCD = 300;
    int sdClassAmount = GetLevelByClass( CLASS_TYPE_SHADOWDANCER, oPC);
    int pcDexMod = GetAbilityModifier(ABILITY_DEXTERITY,oPC);
    int nSD = sdClassAmount - 5;

    nSD = nSD * 18;

    nCD = nCD - nSD;

    DelayCommand( IntToFloat( nCD ), FloatingTextStringOnCreature( "<c þ >You can now Shadow Daze again!</c>", oPC, FALSE ) );

    //find SD adjustment to block time
    int nMin;

    while( nCD >= 60 )
    {
        nMin++;
        nCD = nCD - 60;
    }

    //apply the cooldown time
    SetBlockTime( oPC, nMin, nCD, "ds_SD_b" );

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDaze = EffectDazed();
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eDaze);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DAZED_S);
    int nMetaMagic = GetMetaMagicFeat();
    int nDuration = 5;
    int nRacial = GetRacialType(oTarget);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 475));
    //check meta magic for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = 4;
    }
    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
    {
       //Make SR check
       if (!MyResistSpell(OBJECT_SELF, oTarget))
       {
            //Make Will Save to negate effect
            if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, (10 + sdClassAmount + pcDexMod), SAVING_THROW_TYPE_MIND_SPELLS))
            {
                //Apply VFX Impact and daze effect
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}
