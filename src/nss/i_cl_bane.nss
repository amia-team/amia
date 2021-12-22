/*  Weapon :: Black Hand Of Bane :: OnEquip Red Aura VFX && Remove Aura OnUnEquip

    --------
    Verbatim
    --------
    This script will add/remove a red aura to a character in possession of this weapon.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062506  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"

void main( ){

    // Variables.
    int nEvent      = GetUserDefinedItemEventNumber( );
    int nResult     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_EQUIP:{

            // Variables.
            object oPC      = GetPCItemLastEquippedBy( );
            effect eAura    = SupernaturalEffect( EffectVisualEffect( VFX_IMP_AURA_NEGATIVE_ENERGY ) );

            // Give the Banite a red aura vfx.
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eAura, oPC );

            break;

        }

        case X2_ITEM_EVENT_UNEQUIP:{

            // Variables.
            object oPC      = GetPCItemLastUnequippedBy( );

            // Search for the red aura vfx and remove it
            effect eSeekEffect = GetFirstEffect( oPC );

            while( GetIsEffectValid( eSeekEffect ) ){

                if( GetEffectType( eSeekEffect ) == EFFECT_TYPE_VISUALEFFECT    &&
                    GetEffectSubType( eSeekEffect) == SUBTYPE_SUPERNATURAL      ){

                    RemoveEffect( oPC, eSeekEffect );

                    break;

                }

                eSeekEffect = GetNextEffect( oPC );

            }

            break;

        }

        default:{

            break;

        }

    }

    SetExecutedScriptReturnValue( nResult );

}
