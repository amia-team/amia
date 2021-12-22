// Knight Commander feat: Barricade of Swords (OnEnter Aura)
//
// An aura that delivers damage back to attackers. Knight Commander gains this
// feat at level 1.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2011 PoS              Initial Release.
//

#include "x2_inc_spellhook"

void main(){

    // Variables.
    object oCreature    = GetEnteringObject( );
    object oPC          = GetAreaOfEffectCreator( );
    int    nCHA         = GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int    nClass       = GetLevelByClass( CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC );

    // Charisma bonus is capped to KC level.
    if ( nCHA > nClass )
        nCHA = nClass;

    // Prevent stacking.
    if ( GetHasSpellEffect( 892, oCreature ) )
        return;

    // Damage is equal to charisma modifier + class + 1d10
    int    nDamage       = nCHA + ( nClass * 2 );

    effect eShield  = EffectDamageShield( nDamage, DAMAGE_BONUS_1d10, DAMAGE_TYPE_SLASHING );
    effect eResist1 = EffectDamageImmunityIncrease( DAMAGE_TYPE_PIERCING, 5 + nCHA );
    effect eResist2 = EffectDamageImmunityIncrease( DAMAGE_TYPE_SLASHING, 5 + nCHA );
    effect eResist3 = EffectDamageImmunityIncrease( DAMAGE_TYPE_BLUDGEONING, 5 + nCHA );

    // Link the AOE and the effect to apply to the PC directly.
    effect eLink = EffectLinkEffects( eShield, eResist1 );
           eLink = EffectLinkEffects( eResist2, eLink );
           eLink = EffectLinkEffects( eResist3, eLink );

    // Apply if creature is friendly to the aura creator.
    if( GetIsFriend( oCreature, oPC ) )
    {
        // Apply the VFX impact and effects.
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( 677 ), oCreature );
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, ExtraordinaryEffect( eLink ), oCreature );
    }
}
