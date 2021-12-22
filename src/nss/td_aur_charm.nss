//Aura enter script. See td_aruaobsession

#include "nwnx_effects"
#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "inc_td_appearanc"

void Pow( object oTarget, object oPC, int nCL, int nDC ){

    if( !GetIsReactionTypeHostile( oTarget, oPC ) || GetHitDice( oTarget ) > (nCL*2) || GetHasSpellEffect( SPELL_MASS_CHARM, oTarget ) ){

        return;
    }

    if( MyResistSpell( oPC, oTarget ) > 0 )
        return;

    SignalEvent( oTarget, EventSpellCastAt( oPC, SPELL_MASS_CHARM ) );

    if( WillSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC ) < 1 ){

        effect eBad = EffectLinkEffects( EffectDazed(), EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED ) );
            eBad = EffectLinkEffects( eBad, EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE ) );

        RemoveEffectsBySpell( oTarget, SPELL_MASS_CHARM );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SetEffectSpellID( eBad, SPELL_MASS_CHARM ), oTarget, RoundsToSeconds( nCL ) );
    }
}

void main(){

    object oPC = GetAreaOfEffectCreator( );

    int nCL = GetLocalInt( oPC, "aura_cl_obs" );
    int nDC = 19 + GetAbilityModifier( ABILITY_INTELLIGENCE, oPC );

    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oPC ) )
        nDC += 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oPC ) )
        nDC += 4;
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_ENCHANTMENT, oPC ) )
        nDC += 2;

    object oTarget = GetFirstInPersistentObject();
    while( GetIsObjectValid( oTarget ) ){
        AssignCommand( oPC, Pow( oTarget, oPC, nCL, nDC ) );
        oTarget = GetNextInPersistentObject();
    }
}
