/*  Item :: Shadow Essence

    --------
    Verbatim
    --------
    This script will shroud the caster for 3d6 rounds.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080106  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "x2_inc_toollib"
#include "x2_inc_itemprop"

void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        // Activate the Shadow Essence.
        case X2_ITEM_EVENT_EQUIP:{

            // Variables.
            object oPC              = GetPCItemLastEquippedBy( );
            object oItem            = GetPCItemLastEquipped( );

            // Shadowshield VFX.
            AssignCommand(
                oItem,
                ApplyEffectToObject(
                    DURATION_TYPE_PERMANENT,
                    EffectVisualEffect( VFX_DUR_PROT_SHADOW_ARMOR ),
                    oPC ) );

            // Transparency VFX.
            AssignCommand(
                oItem,
                ApplyEffectToObject(
                    DURATION_TYPE_PERMANENT,
                    EffectVisualEffect( VFX_DUR_INVISIBILITY ),
                    oPC ) );

            // 10% Concealment VFX.
            AssignCommand(
                oItem,
                ApplyEffectToObject(
                    DURATION_TYPE_PERMANENT,
                    EffectConcealment( 20 ),
                    oPC ) );

            break;

        }

        // De-activate the Shadow Essence.
        case X2_ITEM_EVENT_UNEQUIP:{

            // Variables.
            object oPC              = GetPCItemLastUnequippedBy( );
            object oItem            = GetPCItemLastUnequipped( );

            effect eEffect          = GetFirstEffect( oPC );

            // Cycle effects and remove Shadow Essence.
            while( GetIsEffectValid( eEffect ) ){

                if( GetEffectCreator( eEffect ) == oItem )
                    RemoveEffect( oPC, eEffect );

                eEffect             = GetNextEffect( oPC );

            }

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
