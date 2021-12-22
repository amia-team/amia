//::///////////////////////////////////////////////
//:: Pulse Drown
//:: NW_S1_PulsDrwn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    CHANGED JANUARY 2003
     - does an actual 'drown spell' on each target
     in the area of effect.
     - Each use of this spells consumes 50% of the
     elementals hit points.

*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watmaniuk
//:: Created On: April 15, 2002
//:://////////////////////////////////////////////
//:: Updated 10/13/2012 by PoS - changed ability for Shifters.

#include "NW_I0_SPELLS"
#include "inc_td_shifter"

void Drown(object oTarget, int nDC, int nIsPoly)
{
    // Expertise/Improved Expertise disabling for Shifters
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_EXPERTISE, FALSE );
    if ( GetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE ) )
        SetActionMode( OBJECT_SELF, ACTION_MODE_IMPROVED_EXPERTISE, FALSE );

    // vars
    int nRacialType = GetRacialType( oTarget );
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);

    int nDamage = GetMaxHitPoints( oTarget ) / 4;
    if( nDamage > 150 )
    {
        nDamage = 150;
    }

    // * certain racial types and those with spell immnuty: drown are immune
    if( nRacialType != RACIAL_TYPE_CONSTRUCT            &&
        nRacialType != RACIAL_TYPE_UNDEAD               &&
        nRacialType != RACIAL_TYPE_ELEMENTAL            &&
        !GetLocalInt( oTarget, "cs_immunity_drown" )    ){

        //Make a fortitude save
        if(MySavingThrow(SAVING_THROW_FORT, oTarget, nDC) == FALSE)
        {
            //Apply the VFX impact and damage effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            if( nIsPoly == 1 )
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage( nDamage ), oTarget);
            }
            else
            {
                //Set damage effect to kill the target
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oTarget);
            }
         }
         else
         {
            if( nIsPoly == 1 )
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage( nDamage / 2 ), oTarget);
            }
         }
    }

    return;

}
void main ()
{
    // Major variables.
    effect      eImpact = EffectVisualEffect( VFX_IMP_PULSE_WATER );
    location    lLoc    = GetLocation( OBJECT_SELF );
    int         nIsPoly = GetIsPolymorphed( OBJECT_SELF );
    int         nDC;
    int         nDamage;

    if( nIsPoly == 1 )
    {
        nDamage = GetMaxHitPoints() / 10;
        nDC = 20 + ( GetNewCasterLevel( OBJECT_SELF ) / 2 );
    }
    else
    {
        nDamage = GetCurrentHitPoints() / 2;
        nDC = 20;
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nDamage ), OBJECT_SELF );

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc );
    while( GetIsObjectValid( oTarget ) == TRUE )
    {
        if( !GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF )
        {
            //Fire cast spell at event for the specified target
            SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, SPELLABILITY_PULSE_DROWN ) );
            Drown( oTarget, nDC, nIsPoly );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, lLoc );
    }
}


