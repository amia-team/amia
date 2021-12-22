//::///////////////////////////////////////////////
//:: Bigby's Grasping Hand
//:: [x0_s0_bigby3]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    make an attack roll. If succesful target is held for 1 round/level


*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: VFX Pass By:
//:: Update By: jpavelch
//:: Upated On: May 25, 2004
//:: Notes: Added concentration check.

#include "x0_i0_spells"
#include "x2_inc_spellhook"


void ConcentrationCheck( object oVictim )
{
    if ( !GetIsObjectValid(oVictim) )
        return;

    int nDuration = GetLocalInt( oVictim, "AR_Bigby3_Duration" ) - 1;
    if ( nDuration < 1 )
        return;
    else
        SetLocalInt( oVictim, "AR_Bigby3_Duration", nDuration );

    object oCaster = GetLocalObject( oVictim, "AR_Bigby3_Caster" );
    if ( !GetIsObjectValid(oCaster) ) return;

    int nAction = GetCurrentAction( oCaster );
    // Caster doing anything that requires attention and breaks concentration.
    if ( nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT
        || nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT
        || nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP
        || nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL ) {

        effect eEffect = GetFirstEffect( oVictim );
        while ( GetIsEffectValid(eEffect) ) {
            if ( GetEffectType(eEffect) == EFFECT_TYPE_PARALYZE  ||
                 GetEffectType(eEffect) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ) {
                RemoveEffect( oVictim, eEffect );
                FloatingTextStringOnCreature(
                    "* Concentration broken, Bigby dispelled *",
                    oCaster
                );
                return;
            }
            eEffect = GetNextEffect( oVictim );
        }
    }

    DelayCommand( 6.0, ConcentrationCheck(oVictim) );
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


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nDuration = 5;
    // check for epic spell focus
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nDuration = nDuration + 1;
    }
    int nMetaMagic = GetMetaMagicFeat();
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DISABLED);

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         nDuration = nDuration * 2;
    }

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 461, TRUE));

        // Check spell resistance
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // Check caster ability vs. target's AC

            int nCasterModifier = GetCasterAbilityModifier(OBJECT_SELF);
            int nCasterRoll = d20(1)
                + nCasterModifier
                + GetCasterLevel(OBJECT_SELF) + 10 + -1;

            int nTargetRoll = GetAC(oTarget);

            // * grapple HIT succesful,
            if (nCasterRoll >= nTargetRoll)
            {
                // * now must make a GRAPPLE check to
                // * hold target for duration of spell
                // * check caster ability vs. target's size & strength
                nCasterRoll = d20(1) + nCasterModifier
                    + GetCasterLevel(OBJECT_SELF) + 10 +4;

                nTargetRoll = d20(1)
                             + GetBaseAttackBonus(oTarget)
                             + GetSizeModifier(oTarget)
                             + GetAbilityModifier(ABILITY_STRENGTH, oTarget);

                if (nCasterRoll >= nTargetRoll)
                {
                    // Hold the target paralyzed
                    effect eKnockdown = EffectParalyze();

                    // creatures immune to paralyzation are still prevented from moving
                    if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS) ||
                        GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS))
                    {
                        eKnockdown = EffectCutsceneImmobilize();
                    }

                    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
                    effect eHand = EffectVisualEffect(VFX_DUR_BIGBYS_GRASPING_HAND);
                    effect eLink = EffectLinkEffects(eKnockdown, eDur);
                    eLink = EffectLinkEffects(eHand, eLink);
                    eLink = EffectLinkEffects(eVis, eLink);

                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                                        eLink, oTarget,
                                        RoundsToSeconds(nDuration));

    //                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,
    //                                        eVis, oTarget,RoundsToSeconds(nDuration));
                    FloatingTextStrRefOnCreature(2478, OBJECT_SELF);

                    SetLocalInt( oTarget, "AR_Bigby3_Duration", nDuration );
                    SetLocalObject( oTarget, "AR_Bigby3_Caster", OBJECT_SELF );
                    DelayCommand( 6.0, ConcentrationCheck(oTarget) );
                }
                else
                {
                    FloatingTextStrRefOnCreature(83309, OBJECT_SELF);
                }
            }
        }
    }
}


