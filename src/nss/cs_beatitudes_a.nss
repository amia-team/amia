// Beatitudes OnEnter script - custom spell.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/14/2013 PoS              Initial Release.
//

#include "x2_inc_spellhook"

void main(){

    // Variables.
    object oCreature    = GetEnteringObject( );
    object oPC          = GetAreaOfEffectCreator( );

    if ( GetHasSpellEffect( 888, oCreature ) )
        return;

    effect eWeak1   = EffectDamageImmunityDecrease( DAMAGE_TYPE_PIERCING, 15 );
    effect eWeak2   = EffectDamageImmunityDecrease( DAMAGE_TYPE_SLASHING, 15 );
    effect eWeak3   = EffectDamageImmunityDecrease( DAMAGE_TYPE_BLUDGEONING, 15 );
    effect eWeak4   = EffectDamageImmunityDecrease( DAMAGE_TYPE_ACID, 15 );
    effect eWeak5   = EffectDamageImmunityDecrease( DAMAGE_TYPE_COLD, 15 );
    effect eWeak6   = EffectDamageImmunityDecrease( DAMAGE_TYPE_ELECTRICAL, 15 );
    effect eWeak7   = EffectDamageImmunityDecrease( DAMAGE_TYPE_FIRE, 15 );
    effect eWeak8   = EffectDamageImmunityDecrease( DAMAGE_TYPE_SONIC, 15 );

    effect eVFX     = EffectVisualEffect( VFX_IMP_CONFUSION_S );

    effect eLink = EffectLinkEffects( eWeak1, eWeak2 );
    eLink        = EffectLinkEffects( eWeak3, eLink );
    eLink        = EffectLinkEffects( eWeak4, eLink );
    eLink        = EffectLinkEffects( eWeak5, eLink );
    eLink        = EffectLinkEffects( eWeak6, eLink );
    eLink        = EffectLinkEffects( eWeak7, eLink );
    eLink        = EffectLinkEffects( eWeak8, eLink );


    // Apply if creature is not friendly to the aura creator.
    if( GetIsReactionTypeHostile( oCreature, oPC ) )
    {
        // Apply the VFX impact and effects.
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oCreature ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eVFX, oPC ) );
    }
}
