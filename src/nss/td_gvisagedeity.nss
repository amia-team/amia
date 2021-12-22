//http://www.amiaworld.net/phpBB3/viewtopic.php?f=8&t=72573
//Greater Visage of the Deity

#include "nwnx_effects"
#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "inc_td_appearanc"

void main(){

    int nCL = GetCasterLevel( OBJECT_SELF );
    int nEye = GetEyeVFX( OBJECT_SELF, "white" );

    effect eSwag = EffectLinkEffects( EffectUltravision( ), EffectImmunity( IMMUNITY_TYPE_POISON ) );

    eSwag = EffectLinkEffects( eSwag, EffectDamageResistance( DAMAGE_TYPE_ACID, 10 ) );
    eSwag = EffectLinkEffects( eSwag, EffectDamageResistance( DAMAGE_TYPE_COLD, 10 ) );
    eSwag = EffectLinkEffects( eSwag, EffectDamageResistance( DAMAGE_TYPE_FIRE, 10 ) );
    eSwag = EffectLinkEffects( eSwag, EffectDamageResistance( DAMAGE_TYPE_ELECTRICAL, 10 ) );

    eSwag = EffectLinkEffects( eSwag, EffectDamageReduction( 10, DAMAGE_POWER_PLUS_FIVE ) );
    eSwag = EffectLinkEffects( eSwag, EffectSpellResistanceIncrease( 10+nCL ) );
    eSwag = EffectLinkEffects( eSwag, EffectAbilityIncrease( ABILITY_CHARISMA, 4 ) );
    eSwag = EffectLinkEffects( eSwag, EffectSkillIncrease( SKILL_PERSUADE, 10 ) );
    eSwag = EffectLinkEffects( eSwag, EffectSkillIncrease( SKILL_INTIMIDATE, 10 ) );

    if( nEye > 0 )
        eSwag = EffectLinkEffects( eSwag, EffectVisualEffect( nEye ) );

    eSwag = EffectLinkEffects( eSwag, EffectVisualEffect( VFX_DUR_DEATH_ARMOR ) );
    eSwag = EffectLinkEffects( eSwag, EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR ) );
    eSwag = EffectLinkEffects( eSwag, EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE ) );

    eSwag = SetEffectSpellID( eSwag, 1236 );

    RemoveEffectsBySpell( OBJECT_SELF, 1236 );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSwag, OBJECT_SELF, RoundsToSeconds( nCL ) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_SOUND_BURST_SILENT ), OBJECT_SELF );

    PlaySound( "sff_comtime" );
}
