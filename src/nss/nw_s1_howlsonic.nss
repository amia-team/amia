//::///////////////////////////////////////////////
//:: Howl: Sonic
//:: NW_S1_HowlSonic
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A howl emanates from the creature which affects
    all within 10ft unless they make a save.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 14, 2000
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "inc_td_shifter"
void main()
{
    // Expertise/Improved Expertise disabling for Shifters
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE, FALSE );
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE, FALSE );

    //Declare major variables
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);
    effect eHowl;
    effect eImpact = EffectVisualEffect(VFX_FNF_HOWL_WAR_CRY);
    int nHD = GetHitDice(OBJECT_SELF);
    nHD = GetNewCasterLevel( OBJECT_SELF, nHD );

    if( nHD < 8 )
    {
        nHD == 8;
    }

    int nAmount = nHD/4;

    if(nAmount == 0)
    {
        nAmount = 1;
    }
    int nDC = GetShifterDC( OBJECT_SELF, 10 + nAmount );
    int nDamage;
    float fDelay;
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {

        // Fixed by Selmak on 2011-10-04, affects only enemies now
        if(GetIsEnemy(oTarget) && oTarget != OBJECT_SELF)
        {
            fDelay = GetDistanceToObject(oTarget)/20;
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_HOWL_SONIC));

            // If caster is a shifter, use a different damage calculation
            if( GetIsPolymorphed( OBJECT_SELF ) )
            {
                nDamage = d6( nHD / 2 );
            }
            else
            {
                nDamage = d6(nAmount);
            }

            //Make a saving throw check
            if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_SONIC, OBJECT_SELF, fDelay))
            {
                nDamage = nDamage / 2;
            }
            //Set damage effect
            eHowl = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
            //Apply the VFX impact and effects
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHowl, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}


