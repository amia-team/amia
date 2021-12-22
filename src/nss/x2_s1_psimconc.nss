//::///////////////////////////////////////////////
//:: Psionics: Mass Concussion
//:: x2_s1_psimconc
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
   Mindflayer Power
   Cause hit dice / 2 points of damage to hostile creatures
   and objects in a RADIUS_SIZE_MEDIUM area around the caster

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-02
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"
void main()
{
    // Expertise/Improved Expertise disabling for Shifters
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE, FALSE );
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE, FALSE );

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetNewCasterLevel( oCaster, GetHitDice(OBJECT_SELF) );

    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_SCREEN_SHAKE);
    eExplode = EffectLinkEffects(EffectVisualEffect(VFX_FNF_LOS_NORMAL_10),eExplode);
    effect eVis = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
    effect eDam;
    //Get the spell target location as opposed to the spell tar get.
    location lTarget = GetSpellTargetLocation();
    object oTarget = GetSpellTargetObject();
    //Apply the explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);

    if( GetIsPolymorphed( oCaster ) )
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            nDamage = d3(nCasterLvl/2) + GetAbilityModifier(ABILITY_WISDOM);
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_ENERGY);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
        }
    }

    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, FALSE);
    //Cycle through the targets within the spell shape until an invalid object is captured.

    effect eKnockdown = EffectKnockdown();
    effect eAbilityDamage = EffectAbilityDecrease(ABILITY_WISDOM,3);
    effect eVisDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eLink = EffectLinkEffects(eVisDur,eAbilityDamage);

    int nDC = GetShifterDC( oCaster, 15 + (nCasterLvl/2) );
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            //Roll damage for each target
            if( GetIsPolymorphed( oCaster ) )
            {
                nDamage = d3(nCasterLvl/2) + GetAbilityModifier(ABILITY_WISDOM);
            }
            else
            {
                nDamage = d6(nCasterLvl/2) + GetAbilityModifier(ABILITY_WISDOM);
            }
            //Resolve metamagic
            //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
            //Set the damage effect
            eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING,DAMAGE_POWER_ENERGY);
            if(nDamage > 0)
            {
                // Apply effects to the currently selected target.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                //This visual effect is applied to the target object not the location as above.  This visual effect
                //represents the flame that erupts on the target not on the ground.
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            }
            if (!MySavingThrow(SAVING_THROW_WILL,oTarget,nDC, SAVING_THROW_TYPE_MIND_SPELLS))
            {
                if ( GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS, oCaster) == FALSE )
                {
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eKnockdown,oTarget,4.0f);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLink,oTarget,RoundsToSeconds(d6()+3));
                }
            }

        }
       //Select the next target within the spell shape.
       oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget,FALSE);
    }
}

