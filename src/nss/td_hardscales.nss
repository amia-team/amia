//Harden scales: http://www.amiaworld.net/phpBB3/viewtopic.php?f=8&t=72913
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
    int nCL = GetCasterLevel(oPC);
    effect eAwesome = EffectLinkEffects( EffectDamageReduction( 10 ,DAMAGE_POWER_PLUS_TWENTY, nCL*10 ), EffectDamageImmunityDecrease( DAMAGE_TYPE_COLD, 25 ) );
           eAwesome = EffectLinkEffects( eAwesome, EffectDamageImmunityDecrease( DAMAGE_TYPE_FIRE, 25 ) );
           eAwesome = EffectLinkEffects( eAwesome, EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE ) );

    PlaySound( "sim_magsuper" );

    RemoveEffectsBySpell( oPC, SPELL_PREMONITION );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, SetEffectSpellID( eAwesome, SPELL_PREMONITION ), oPC, TurnsToSeconds( nCL ) );
}
