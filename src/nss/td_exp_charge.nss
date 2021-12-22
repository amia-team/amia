//http://www.amiaworld.net/phpBB3/viewtopic.php?f=8&t=72771
//Expeditious Charge

#include "nwnx_effects"
#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "x2_i0_spells"

void main( ){

    location lTarget = GetSpellTargetLocation( );
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 30.0, lTarget );

    effect eEffect = EffectLinkEffects( EffectMovementSpeedIncrease( 20 ), EffectSavingThrowIncrease( SAVING_THROW_REFLEX, 2 ) );
           eEffect = EffectLinkEffects( eEffect, EffectVisualEffect( VFX_DUR_CESSATE_NEUTRAL ) );

    eEffect = SetEffectSpellID( eEffect, 1235 );

    int nCL = GetCasterLevel( OBJECT_SELF );
    if( GetMetaMagicFeat( ) == METAMAGIC_EXTEND )
        nCL = nCL * 2;

    ApplyEffectAtLocation( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_WIND ), lTarget );

    while( GetIsObjectValid( oTarget ) ){

        if( ( GetRacialType( oTarget ) == RACIAL_TYPE_DWARF || GetAppearanceType( oTarget ) == APPEARANCE_TYPE_DWARF ) && !GetIsReactionTypeHostile( oTarget ) ){
            RemoveEffectsBySpell( oTarget, 1235 );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oTarget, RoundsToSeconds( nCL ) );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_PULSE_WIND ), oTarget );
        }

        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 30.0, lTarget );
    }
}
