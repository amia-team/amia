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

    // Declare major variables.
    effect eAOE = EffectAreaOfEffect(AOE_MOB_MENACE, "kc_ordnance1", "****", "kc_ordnance2");

    // Apply the VFX impact and effects.
    DelayCommand( 0.1, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(eAOE), oPC ) );
}
