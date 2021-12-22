//http://www.amiaworld.net/phpBB3/viewtopic.php?f=8&t=71830
//Soul Blast

#include "inc_ds_records"
#include "x2_inc_spellhook"
//custom spell constants
#include "inc_dc_spells"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "nwnx_effects"

void main(){

    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject( );

    if( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE || !GetIsReactionTypeHostile( oTarget, oPC ) )
        return;

    int nDC = 13 + GetAbilityModifier( ABILITY_CHARISMA, oPC );

    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_NECROMANCY, oPC ) )
        nDC += 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_NECROMANCY, oPC ) )
        nDC += 4;
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_NECROMANCY, oPC ) )
        nDC += 2;

    if( MyResistSpell( oPC, oTarget ) > 0 )
        return;

    SignalEvent( oTarget, EventSpellCastAt( oPC, SPELL_SEARING_LIGHT ) );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_HIT_DIVINE ), oTarget );

    int nDamage = d6( 10 );
    int nMeta = GetMetaMagicFeat( );
    int nDur = 1;

    if( nMeta == METAMAGIC_MAXIMIZE )
        nDamage = 60;
    else if( nMeta == METAMAGIC_EMPOWER )
        nDamage = nDamage + (nDamage/2);
    else if( nMeta == METAMAGIC_EXTEND )
        nDur = 2;

    if( FortitudeSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC ) >= 1 ){
        nDamage = nDamage/2;
    }
    if( FortitudeSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC ) < 1 ){

        effect eBad = EffectLinkEffects( EffectStunned(), EffectVisualEffect( VFX_DUR_AURA_PULSE_GREY_WHITE ) );
        eBad = EffectLinkEffects( eBad, EffectVisualEffect( VFX_DUR_CESSATE_NEGATIVE ) );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBad, oTarget, RoundsToSeconds( nDur ) );
    }

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nDamage, DAMAGE_TYPE_POSITIVE ), oTarget );


}
