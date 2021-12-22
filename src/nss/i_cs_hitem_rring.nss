/*  Item : Harper Scouts :: Reflective Ring

    --------
    Verbatim
    --------
    This script relays a message to another player to get their attention, Harper stuff.

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

            // Reflect message.
            SendMessageToPC(
                oTarget,
                "- The light reflecting off " + GetName( oPC ) + "'s ring catches your eye." );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
