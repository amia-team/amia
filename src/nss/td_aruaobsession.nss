//http://www.amiaworld.net/phpBB3/viewtopic.php?f=8&t=72299
//Aura of Obsession

#include "nwnx_effects"
#include "x2_inc_spellhook"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "inc_td_appearanc"

void main(){

    int nCL = GetCasterLevel( OBJECT_SELF );
    effect eSwag = EffectLinkEffects( EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE ), EffectAreaOfEffect(  AOE_MOB_FROST, "****", "td_aur_charm", "****" ) );
    eSwag =  SetEffectSpellID( eSwag, 1237 );
    RemoveEffectsBySpell( OBJECT_SELF, 1237 );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSwag, OBJECT_SELF, TurnsToSeconds( nCL ) );
    SetLocalInt( OBJECT_SELF, "aura_cl_obs", nCL );
}
