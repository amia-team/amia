/*  DC Item :: SFX Effector :: Visual & Sound Animation, Visual and Sound Refs Stored On Item

    --------
    Verbatim
    --------
    This script will execute each animation by using the variables stored on the item itself.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    071906  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"

/* Constants */
const string VFX                    = "cs_vfx";
const string SFX                    = "cs_sfx";

void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oItem            = GetItemActivated( );
            object oPC              = GetItemActivator( );
            int nVFX                = GetLocalInt( oItem, VFX );
            string szSFX            = GetLocalString( oItem, SFX );


            // Candy.
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( nVFX ), oPC );
            // Audio effect.
            AssignCommand( oPC, PlaySound( szSFX ) );

            break;

        }

        default:{
            nResult                 = X2_EXECUTE_SCRIPT_CONTINUE;
            break;
        }

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
