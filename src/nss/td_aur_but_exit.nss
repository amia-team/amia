//Aura exit script for butterflies of bewilderment
//see: td_butterflies

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

    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetExitingObject();

    RemoveSpellEffects( 1238, oCaster, oTarget );
}
