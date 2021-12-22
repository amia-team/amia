// Knight Commander feat: Bulwark of Vigilance
//
// An aura that slows down attackers in the radius, and applies a Tumble penalty.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2011 PoS              Initial Release.
//

#include "x2_inc_spellhook"

void main( ) {

    object oPC      = OBJECT_SELF;

    // Cycle through targets in a sphere shape until the target is invalid.
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), TRUE, OBJECT_TYPE_CREATURE );
    while ( GetIsObjectValid( oTarget ) )
    {
        effect eEffects = GetFirstEffect( oTarget );

        while( GetIsEffectValid( eEffects ) ){
            if ( GetEffectCreator( eEffects ) == oPC )
            {
                if( GetEffectSpellId( eEffects ) == 894  ||
                    GetEffectSpellId( eEffects ) == 896  ){

                    // Remove all aura effects this PC has applied already.
                    RemoveEffect( oTarget, eEffects );
                }
            }
            eEffects = GetNextEffect( oTarget );
        }

        // Select the next target within the spell shape.
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( oPC ), TRUE, OBJECT_TYPE_CREATURE );
    }

    effect eAOE = EffectAreaOfEffect(AOE_MOB_MENACE, "kc_bulwark1", "****", "kc_bulwark2");

    // Apply the VFX impact and effects.
    DelayCommand( 0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eAOE), oPC ) );
}
