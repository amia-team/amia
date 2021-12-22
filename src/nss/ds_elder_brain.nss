//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_elder_brain
//group:   underdark
//used as: on attacked script, simulates Elder Brain death
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    int nBlock = GetLocalInt( OBJECT_SELF, "block" );

    if ( !nBlock ){

        SetLocalInt( OBJECT_SELF, "block", 1 );

        object oBrain       = OBJECT_SELF;

        effect eBash        = EffectVisualEffect(VFX_COM_CHUNK_GREEN_MEDIUM);
        effect eAOE         = EffectAreaOfEffect(AOE_PER_FOGSTINK);
        effect eDeath       = EffectVisualEffect(VFX_FNF_HOWL_MIND);

        location lVfx1      = GetLocation(GetObjectByTag("q2d4_vfx_deadbrain"));
        location lVfx2      = GetLocation(GetObjectByTag("q2d4_vfx_deadbrain1"));
        location lVfx3      = GetLocation(GetObjectByTag("q2d4_vfx_deadbrain2"));
        location lSelf      = GetLocation(oBrain);

        //Apply Brain Bashing effects
        DelayCommand( 1.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBash, lVfx1 ) );
        DelayCommand( 3.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBash, lVfx1 ) );
        DelayCommand( 5.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eBash, lVfx1 ) );
        DelayCommand( 1.0, PlaySound( "bf_squish" ) );
        DelayCommand( 3.0, PlaySound( "bf_squish" ) );
        DelayCommand( 5.0, PlaySound( "bf_squish" ) );
        DelayCommand( 1.5, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lVfx1, 30.0 ) );
        DelayCommand( 3.5, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lVfx2, 30.0 ) );
        DelayCommand( 5.5, ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eAOE, lVfx3, 30.0 ) );
        DelayCommand( 7.0, ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eDeath, lVfx1 ) );
        DelayCommand( 7.0, AssignCommand( GetLastAttacker(), ClearAllActions() ) );
        DelayCommand( 10.0, FloatingTextStringOnCreature( "The Elder Brain is destroyed...", GetLastAttacker(), TRUE ) );
        DelayCommand( 10.0, DestroyObject( OBJECT_SELF ) );
    }
}
