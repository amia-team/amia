/*  DC Item :: Body Of Flame :: As per Book of Vile Darkness

    --------
    Verbatim
    --------
    This script will grant the player the following powers, for a duration specified as a float variable on the item:
        1. Immolation visual.
        2. 10/+5 DR.
        3. 100% immunity to fire damage.
        4. Immolate anyone who touches (hits) the player.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    071606  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"

/* Constants. */
const string IMMOLATED              = "cs_immolated";
const string DURATION               = "cs_duration";

void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        // Immolation.
        case X2_ITEM_EVENT_ONHITCAST:{

            // Variables.
            object oVictim          = GetSpellTargetObject( );

            // Prevent stacking.
            if( GetLocalInt( oVictim, IMMOLATED ) )
                break;
            else
                SetLocalInt( oVictim, IMMOLATED, TRUE );

            /* Apply 2d6 fire damage and initiate immolation on the victim. */

            // Impact.
            TLVFXPillar( VFX_IMP_FLAME_M, GetLocation( oVictim ), 5, 0.1, 0.0, 2.0 );

            // Immolation visual.
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( 498 ), oVictim, 6.0 );

            // Damage.
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d6( 2 ), DAMAGE_TYPE_FIRE ), oVictim );

            // Initialize immolation, in 6 seconds time.
            DelayCommand( 6.0, ExecuteScript( "cs_immolation", oVictim ) );

            break;

        }

        // Activate the Body of Flame.
        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables.
            object oItem            = GetItemActivated( );
            object oPC              = GetItemActivator( );
            float fDuration         = GetLocalFloat( oItem, DURATION );

            if ( fDuration == 0.0 ){

                return;
            }

            // Apply temporary effects for a temporary duration.

            // Impact.
            TLVFXPillar( VFX_IMP_FLAME_M, GetLocation( oPC ), 5, 0.1, 0.0, 2.0 );

            // Immolation visual.
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( 498 ), oPC, fDuration );

            // 10/+5 damage reduction.
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectDamageReduction( 10, DAMAGE_POWER_PLUS_FIVE ), oPC, fDuration );

            // 100% fire immunity.
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease( DAMAGE_TYPE_FIRE, 100 ), oPC, fDuration );

            // Apply temporary OnHit property to armor to facilitate Immolation.
            IPSafeAddItemProperty(
                oItem,
                ItemPropertyOnHitCastSpell( IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1 ),
                fDuration );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
