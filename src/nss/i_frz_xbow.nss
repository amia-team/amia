
// Frizzy's Zapping Repeater +3, Smokey VFX onEquip, Remove onUnEquip

/*  <Script Title>

    --------
    Verbatim
    --------
    <Script details>

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    030406  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"

void main( ){

    // Variables
    int nEvent      = GetUserDefinedItemEventNumber( );
    int nResult     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_EQUIP:{

            // Variables
            object oPC      = GetPCItemLastEquippedBy( );
            effect eSmokey  = SupernaturalEffect( EffectVisualEffect( VFX_DUR_SMOKE ) );

            // Give the Xbow wielder a smokey vfx
            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eSmokey, oPC, 0.0 );

            break;

        }

        case X2_ITEM_EVENT_UNEQUIP:{

            // Variables
            object oPC      = GetPCItemLastUnequippedBy( );

            // Search for the smokey vfx and remove it
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
