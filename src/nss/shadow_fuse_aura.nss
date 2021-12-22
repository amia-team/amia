//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  shadow_fuse_aura
//description: Custom aura for the Shadow Fusion Custom Feat
//used as: Custom aura for Heartbeat

/*
---------
Changelog
---------
Date         Name        Reason
------------------------------------------------------------------
2012-09-20   Glim        Start
------------------------------------------------------------------
*/

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "amia_include"
#include "nw_i0_generic"
#include "inc_dc_feats"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------
void ExtraFire( object oPC );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main()
{
    object oTarget;
    object oPC  = GetAreaOfEffectCreator( OBJECT_SELF );
    location lPC = GetLocation( oPC );
    effect ePulse = EffectVisualEffect( VFX_IMP_PDK_GENERIC_PULSE );

    if(GetStealthMode( oPC ) != STEALTH_MODE_ACTIVATED )
    {
        ApplyEffectAtLocation( DURATION_TYPE_INSTANT, ePulse, lPC );
    }

    oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lPC, FALSE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        if( oTarget != oPC )
        {
            effect eDamage = EffectDamage( d6(6), DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_NORMAL );
            effect eImpact = EffectVisualEffect( VFX_IMP_DESTRUCTION );
            effect eLink = EffectLinkEffects( eDamage, eImpact );

            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);

            SignalEvent( oTarget, EventSpellCastAt( oPC, DC_FEAT_ACT ) );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lPC, FALSE, OBJECT_TYPE_CREATURE );
    }

    CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "cus_shadow_fuse", lPC, FALSE, "", 6.0 );
    DelayCommand( 3.0, ExtraFire( oPC ) );
}

void ExtraFire( object oPC )
{
    location lPC = GetLocation( oPC );

    CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "cus_shadow_fuse", lPC, FALSE, "", 6.0 );
}
