// Knight Commander feat: Barricade of Swords
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

void main( ) {

    object oPC      = OBJECT_SELF;

    // Get the KC level and charisma to determine the feat's strength.
    int    nCHA     = GetAbilityModifier( ABILITY_CHARISMA, oPC );
    int    nClass   = GetLevelByClass( CLASS_TYPE_PURPLE_DRAGON_KNIGHT, oPC );

    // Charisma bonus is capped to KC level.
    if ( nCHA > nClass )
        nCHA = nClass;

    // Cycle through targets in a sphere shape until the target is invalid.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), TRUE, OBJECT_TYPE_CREATURE );
    while ( GetIsObjectValid( oTarget ) )
    {
        effect eEffects = GetFirstEffect( oTarget );

        while( GetIsEffectValid( eEffects ) ){
            if ( GetEffectCreator( eEffects ) == oPC )
            {
                if( GetEffectSpellId( eEffects ) == 892  ||
                    GetEffectSpellId( eEffects ) == 895  ||
                    GetEffectSpellId( eEffects ) == 897  ){

                    // Remove all aura effects this PC has applied already.
                    RemoveEffect( oTarget, eEffects );
                }
            }
            eEffects = GetNextEffect( oTarget );
        }

        // Select the next target within the spell shape.
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), TRUE, OBJECT_TYPE_CREATURE );
    }

    // Damage is equal to charisma modifier + class + 1d10.
    int    nDamage = nCHA + ( nClass * 2 );

    effect eAOE     = EffectAreaOfEffect(36, "kc_barricade1", "****", "kc_barricade2");
    effect eShield  = EffectDamageShield( nDamage, DAMAGE_BONUS_1d10, DAMAGE_TYPE_SLASHING );
    effect eResist1 = EffectDamageImmunityIncrease( DAMAGE_TYPE_PIERCING, 5 + nCHA );
    effect eResist2 = EffectDamageImmunityIncrease( DAMAGE_TYPE_SLASHING, 5 + nCHA );
    effect eResist3 = EffectDamageImmunityIncrease( DAMAGE_TYPE_BLUDGEONING, 5 + nCHA );

    // Link the AOE and the effect to apply to the PC directly.
    effect eLink = EffectLinkEffects( eShield, eAOE );
           eLink = EffectLinkEffects( eResist1, eLink );
           eLink = EffectLinkEffects( eResist2, eLink );
           eLink = EffectLinkEffects( eResist3, eLink );

    eLink = ExtraordinaryEffect( eLink );

    // Apply the VFX impact and effects.
    DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC ) );
    DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( 677 ), oPC ) );
}
