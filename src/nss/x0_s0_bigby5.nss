//::///////////////////////////////////////////////
//:: Bigby's Crushing Hand
//:: [x0_s0_bigby5]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Similar to Bigby's Grasping Hand.
    If Grapple succesful then will hold the opponent and do 2d6 + 12 points
    of damage EACH round for 1 round/level


   // Mark B's famous advice:
   // Note:  if the target is dead during one of these second-long heartbeats,
   // the DelayCommand doesn't get run again, and the whole package goes away.
   // Do NOT attempt to put more than two parameters on the delay command.  They
   // may all end up on the stack, and that's all bad.  60 x 2 = 120.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
//:: Update By: jpavelch
//:: Upated On: May 25, 2004
//:: Notes: Added concentration check.
// msheeler 7/1/2016    changed duration to 5 rounds and added checks for spell foci

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "x2_i0_spells"

int nSpellID = 463;



int ConcentrationCheck( object oVictim )
{
    if ( !GetIsObjectValid(oVictim) )
        return FALSE;

    object oCaster = GetLocalObject( oVictim, "AR_Bigby5_Caster" );
    if ( !GetIsObjectValid(oCaster) ) return FALSE;

    int nAction = GetCurrentAction( oCaster );
    // Caster doing anything that requires attention and breaks concentration.
    if ( nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT
        || nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT
        || nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP
        || nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL ) {

        return FALSE;
    }

    return TRUE;
}



void RunHandImpact(object oTarget, object oCaster, int nFirstRun )
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if ( nFirstRun == FALSE && ConcentrationCheck(oTarget) == FALSE ) {
        FloatingTextStringOnCreature(
            "* Concentration broken, Bigby dispelled *",
            oCaster
        );
        oCaster = OBJECT_INVALID;
    }

    if (GZGetDelayedSpellEffectsExpired(nSpellID,oTarget,oCaster))
    {
        return;
    }

    int nDam = MaximizeOrEmpower(6,2,GetMetaMagicFeat(), 12);

    //check for damage bonus for foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, oCaster))
    {
        int nDam = MaximizeOrEmpower(6,2,GetMetaMagicFeat(), 14);
    }

    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, oCaster))
    {
        int nDam = MaximizeOrEmpower(6,2,GetMetaMagicFeat(), 16);
    }

    effect eDam = EffectDamage(nDam, DAMAGE_TYPE_BLUDGEONING);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_L);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    DelayCommand(6.0f,RunHandImpact(oTarget,oCaster,FALSE));
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
    // End of Spell Cast Hook

    object oTarget = GetSpellTargetObject();

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one hand, that's enough
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(nSpellID,oTarget) ||  GetHasSpellEffect(462,oTarget)  )
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    int nDuration = 5;

    // check for epic spell focus
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nDuration = nDuration + 1;
    }

    int nMetaMagic = GetMetaMagicFeat();

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_BIGBYS_CRUSHING_HAND, TRUE));

        //SR
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            int nCasterRoll = d20(1)
                + nCasterModifier
                + GetCasterLevel(OBJECT_SELF) + 12 + -1;
            int nTargetRoll = GetAC(oTarget);

            // * grapple HIT succesful,
            if (nCasterRoll >= nTargetRoll)
            {
                // * now must make a GRAPPLE check
                // * hold target for duration of spell

                nCasterRoll = d20(1) + nCasterModifier
                    + GetCasterLevel(OBJECT_SELF) + 12 + 4;

                nTargetRoll = d20(1)
                             + GetBaseAttackBonus(oTarget)
                             + GetSizeModifier(oTarget)
                             + GetAbilityModifier(ABILITY_STRENGTH, oTarget);

                if (nCasterRoll >= nTargetRoll)
                {
                    effect eKnockdown = EffectParalyze();

                    // creatures immune to paralzation are still prevented from moving
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) ||
                        GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                    {
                        eKnockdown = EffectCutsceneImmobilize();
                    }

                    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_CRUSHING_HAND);
                    effect eLink = EffectLinkEffects(eKnockdown, eHand);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                        eLink, oTarget,
                                        RoundsToSeconds(nDuration));

                    object oSelf = OBJECT_SELF;
                    SetLocalObject( oTarget, "AR_Bigby5_Caster", oSelf );
                    RunHandImpact(oTarget, oSelf, TRUE);
                    FloatingTextStrRefOnCreature(2478, OBJECT_SELF);

                }
                else
                {
                    FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
                }
            }
        }
    }
}


