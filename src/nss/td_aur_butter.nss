//Aura heartbeat for butterflies of bewilderment
//see td_butterflies

#include "inc_ds_records"
#include "x2_inc_spellhook"
//custom spell constants
#include "inc_dc_spells"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "nwnx_effects"

void ButterflyPower( object oTarget, object oCaster, int nDC, int nCL );

void main(){

    object oCaster = GetAreaOfEffectCreator( );
    int nCL = GetLocalInt( oCaster, "ButterfliesCL" );
    if( nCL == 0 )
        nCL = 10;

    int nDC = 18 + GetAbilityModifier( ABILITY_WISDOM, oCaster );

    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster ) )
        nDC += 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster ) )
        nDC += 4;
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_CONJURATION, oCaster ) )
        nDC += 2;

    object oTarget = GetFirstInPersistentObject( );
    while( GetIsObjectValid( oTarget ) ){

        ButterflyPower( oTarget, oCaster, nDC, nCL );
        oTarget = GetNextInPersistentObject( );
    }
}

void ButterflyPower( object oTarget, object oCaster, int nDC, int nCL ){

    if( !GetIsReactionTypeHostile( oTarget, oCaster ) )
        return;

    SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_CLOUD_OF_BEWILDERMENT ) );

    //SendMessageToPC( oCaster, "Hello, I'm trying to hit "+GetName( oTarget ) );

    if( WillSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oCaster ) < 1 ){

        effect eDaze = EffectLinkEffects( EffectDazed( ), EffectVisualEffect( VFX_DUR_MIND_AFFECTING_NEGATIVE ) );
               eDaze = EffectLinkEffects( eDaze, EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE ) );

        eDaze = SetEffectCreator( eDaze, oCaster );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SetEffectSpellID( eDaze, 1238 ), oTarget, RoundsToSeconds( nCL ) );
    }

    if( ReflexSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oCaster ) < 1 ){

        effect eNoEyes = EffectLinkEffects( EffectBlindness( ), EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE ) );
        eNoEyes = SetEffectCreator( eNoEyes, oCaster );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SetEffectSpellID( eNoEyes, 1238 ), oTarget, RoundsToSeconds( nCL ) );
    }
}
