//Fear arua thing: http://www.amiaworld.net/phpBB3/viewtopic.php?f=8&t=73025

#include "inc_ds_records"
#include "x2_inc_spellhook"
//custom spell constants
#include "inc_dc_spells"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"
#include "x0_i0_spells"
#include "x2_i0_spells"
#include "nwnx_effects"

void Focus( object oPC, int nID );

void main(){

    object oPC = OBJECT_SELF;

    int nCL = GetCasterLevel( oPC );

    SetLocalInt( oPC, "AOE_CL", nCL );

    int nID = GetSpellId();

    RemoveSpellEffects( nID, oPC, oPC );
    effect eScary = EffectLinkEffects( EffectAreaOfEffect( AOE_MOB_UNNATURAL, "td_aoe_harold", "****", "****" ), EffectVisualEffect( VFX_DUR_ANTI_LIGHT_10 ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eScary, oPC, RoundsToSeconds( nCL ) );
    DelayCommand( 6.0, Focus( oPC, nID ) );
}


void Focus( object oPC, int nID ){

    if ( !GetIsObjectValid( oPC ) || !GetHasSpellEffect( nID, oPC ) )
        return;

    int nAction = GetCurrentAction( oPC );
    if ( nAction == ACTION_DISABLETRAP || nAction == ACTION_TAUNT
        || nAction == ACTION_PICKPOCKET || nAction ==ACTION_ATTACKOBJECT
        || nAction == ACTION_COUNTERSPELL || nAction == ACTION_FLAGTRAP
        || nAction == ACTION_CASTSPELL || nAction == ACTION_ITEMCASTSPELL ) {

        RemoveSpellEffects( nID, oPC, oPC );

        return;
    }

    DelayCommand( 6.0, Focus( oPC, nID ) );
}

