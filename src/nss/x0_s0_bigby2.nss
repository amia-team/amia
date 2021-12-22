//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  x0_s0_bigby2
//description: Rewritten bigby script: fort vs half damage(cap 10d6 ) fort vs kd cl/5 rounds. No SR.
//used as: Spellscript
//date:    20100822
//author:  Terra

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x0_i0_spells"
#include "x2_inc_spellhook"

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main( ){

    if( !X2PreSpellCastCode( ) )
        return;


    object  oTarget     = GetSpellTargetObject( );
    int     nCL         = GetCasterLevel( OBJECT_SELF );
    int     nMetaMagic  = GetMetaMagicFeat( );
    int     nDamage     = nCL > 10 ? d6( 10 ) : d6( nCL );
    int     nDuration   = nCL/5;
    int     nDC         = GetSpellSaveDC( );

    if( nMetaMagic == METAMAGIC_EXTEND ){

        nDuration = nDuration * 2;
    }
    else if( nMetaMagic == METAMAGIC_EMPOWER ){

        nDamage += (nDamage/2);
    }
    else if( nMetaMagic == METAMAGIC_MAXIMIZE ){

        nDamage = nCL > 10 ? 60 : nCL * 6;
    }

    if( !GetIsReactionTypeFriendly( oTarget ) ){

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_BIGBYS_FORCEFUL_HAND ), oTarget );

        SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, 460, TRUE ) );

        if( MySavingThrow( SAVING_THROW_FORT, oTarget, nDC ) ){
            FloatingTextStrRefOnCreature( 8967, OBJECT_SELF, FALSE );
            nDamage/2;
        }
        else{
            FloatingTextStrRefOnCreature( 8966, OBJECT_SELF, FALSE );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectKnockdown( ), oTarget, RoundsToSeconds( nDuration ) );

        }

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage( nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_PLUS_FIVE ), oTarget );

    }
}
