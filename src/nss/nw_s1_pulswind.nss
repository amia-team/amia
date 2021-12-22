//::///////////////////////////////////////////////
//:: Pulse Whirlwind
//:: NW_S1_PulsWind
//:: Copyright (c) 2001 Bioware Corp.
//::///////////////////////////////////////////////
/*
    All those that fail a save of DC 14 are knocked
    down by the elemental whirlwind.

     * made this make the knockdown last 2 rounds instead of 1
     * it will now also do d3(hitdice/2) damage
*/
//::///////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 8, 2002
//::///////////////////////////////////////////////
// 10/13/2012: Redesigned by PoS for Shifters.

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
    effect  eKD     = EffectKnockdown();
    effect  eVFX    = EffectVisualEffect( VFX_IMP_PULSE_WIND );

    int     nDamage;
    effect  eDamage;

    int     nDC;

    if( GetIsPolymorphed( OBJECT_SELF ) )
    {
        nDamage = GetNewCasterLevel( OBJECT_SELF );
        eDamage = EffectDamage( d3( nDamage ), DAMAGE_TYPE_SLASHING );
        nDC = 20 + ( GetNewCasterLevel( OBJECT_SELF ) / 2 );
    }
    else
    {
        nDamage = GetHitDice( OBJECT_SELF ) / 2;
        eDamage = EffectDamage( d3( nDamage ), DAMAGE_TYPE_SLASHING );
        nDC = 14;
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, OBJECT_SELF );

    //Get first target in spell area
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation( OBJECT_SELF ) );
    while( GetIsObjectValid( oTarget ) )
    {
        if( !GetIsReactionTypeFriendly( oTarget ) && oTarget != OBJECT_SELF )
        {
            //Make a saving throw check
            if( !MySavingThrow( SAVING_THROW_REFLEX, oTarget, nDC ) )
            {
                //Apply the VFX impact and effects

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eKD, oTarget, RoundsToSeconds( 1 ) );
                DelayCommand( 0.01, ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget ) );
            }
            //Get next target in spell area
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation( OBJECT_SELF ) );
    }
}
