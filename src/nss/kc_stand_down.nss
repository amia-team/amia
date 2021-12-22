// Knight Commander feat: Stand Down
//
// Removes all the active auras.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/22/2011 PoS              Initial Release.
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
                if( GetEffectSpellId( eEffects ) == 892  ||
                    GetEffectSpellId( eEffects ) == 894  ||
                    GetEffectSpellId( eEffects ) == 895  ||
                    GetEffectSpellId( eEffects ) == 896  ||
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
}
