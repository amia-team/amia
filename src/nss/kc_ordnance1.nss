// Knight Commander feat: Ordnance Support
//
// An aura that gives nearby enemies an immunity decrease to elements, along with
// reducing their spell resistance.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2011 PoS              Initial Release.
//

#include "x2_inc_spellhook"

void main(){

    // Variables.
    object oCreature        = GetEnteringObject( );
    object oPC              = GetAreaOfEffectCreator( );
    int    nCHA             = GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int    nClass           = GetLevelByClass( CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC );

    // Charisma bonus is capped to KC level.
    if ( nCHA > nClass )
        nCHA = nClass;

    // Prevent stacking.
    if (GetHasSpellEffect( 896, oCreature ) )
        return;

    effect eDecrease1 = EffectDamageImmunityDecrease( DAMAGE_TYPE_ACID, 3 * nClass );
    effect eDecrease2 = EffectDamageImmunityDecrease( DAMAGE_TYPE_COLD, 3 * nClass );
    effect eDecrease3 = EffectDamageImmunityDecrease( DAMAGE_TYPE_ELECTRICAL, 3 * nClass );
    effect eDecrease4 = EffectDamageImmunityDecrease( DAMAGE_TYPE_FIRE, 3 * nClass );
    effect eDecrease5 = EffectDamageImmunityDecrease( DAMAGE_TYPE_SONIC, 3 * nClass );
    effect eSpellDecrease = EffectSpellResistanceDecrease( 2 * nCHA );

    effect eLink = EffectLinkEffects( eDecrease1, eDecrease2 );
    eLink = EffectLinkEffects( eDecrease3, eLink );
    eLink = EffectLinkEffects( eDecrease4, eLink );
    eLink = EffectLinkEffects( eDecrease5, eLink );
    eLink = EffectLinkEffects( eSpellDecrease, eLink );

    eLink = ExtraordinaryEffect( eLink );

    // Apply if creature is hostile to the KC.
    if( GetIsReactionTypeHostile( oCreature, oPC ) )
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_BREACH ), oCreature );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oCreature );
    }
}
