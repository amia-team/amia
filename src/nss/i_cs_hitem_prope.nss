/*  Item : Harper Scouts :: Pet Rope

    --------
    Verbatim
    --------
    This script entangles a foe, Harper stuff.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080406  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"


void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables.
            object oPC          = GetItemActivator( );
            object oTarget      = GetItemActivatedTarget( );

            // Store target on the Harper.
            SetLocalObject( oPC, "HARPER_TARGET", oTarget );
            // Run touch attack.
            ExecuteScript( "cs_pet_rope_tatt", oPC );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
