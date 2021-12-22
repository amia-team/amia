//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//description: conversation act for the DC item Shadow Affinity
//date:    2013-05-09
//author:  Terra

#include "nwnx_effects"
#include "inc_td_appearanc"

void main(){

    object oPC = OBJECT_SELF;
    int nNode = GetLocalInt( oPC, "ds_node" );

    int nSpellID = 8520+nNode;
    int nVis;

    switch( nNode ){

        case 1:nVis = VFX_DUR_PROT_SHADOW_ARMOR; break;
        case 2:nVis = VFX_DUR_TENTACLE; break;
        case 3:nVis = GetEyeVFX( oPC, "purple" );break;
        case 4:nVis = VFX_DUR_ANTI_LIGHT_10; break;
        default:break;
    }

    effect eEffect = GetFirstEffect( oPC );
    while( GetIsEffectValid( eEffect ) ){

        if( GetEffectSpellId( eEffect ) == nSpellID ){

            RemoveEffect( oPC, eEffect );
            return;
        }
        eEffect = GetNextEffect( oPC );
    }

    if( nVis <= 0 )
        return;

    eEffect = EffectVisualEffect( nVis );
    eEffect = SupernaturalEffect( eEffect );
    eEffect = SetEffectSpellID( eEffect, nSpellID );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eEffect, oPC );
}
