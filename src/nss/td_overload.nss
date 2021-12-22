//Brain melt: http://www.amiaworld.net/phpBB3/viewtopic.php?f=8&t=72998

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

    //Doesnt work on undead or constructs
    if( GetRacialType( oTarget ) == IP_CONST_RACIALTYPE_UNDEAD ||
        GetRacialType( oTarget ) == IP_CONST_RACIALTYPE_ELEMENTAL ||
        GetRacialType( oTarget ) == IP_CONST_RACIALTYPE_CONSTRUCT )
        return;

    int nDC = 18 + GetAbilityModifier( ABILITY_INTELLIGENCE, oPC );

    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_ENCHANTMENT, oPC ) )
        nDC += 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_ENCHANTMENT, oPC ) )
        nDC += 4;
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_ENCHANTMENT, oPC ) )
        nDC += 2;

    if( MyResistSpell( oPC, oTarget ) > 0 )
        return;

    SignalEvent( oTarget, EventSpellCastAt( oPC, SPELL_HORRID_WILTING ) );

    if( WillSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC ) < 1 ){

        int nDamage = GetCurrentHitPoints( oTarget );
        //Only boss monsters has a CR higher then 40, do 6d20 instead
        if( GetChallengeRating( oTarget ) >= 40.0 )
            nDamage = d6( 20 );

        //Brain damage, stop doing what you're doing
        AssignCommand( oTarget, ClearAllActions( ) );
        AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_LOOPING_SPASM, 1.0, 3.0 ) );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nDamage, DAMAGE_TYPE_ELECTRICAL ), oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DISEASE_S ), oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DESTRUCTION ), oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HEAD_ELECTRICITY ), oTarget );
    }
}
