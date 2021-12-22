/*  Item :: Undroppable

    --------
    Verbatim
    --------
    This script will not permit a player to drop this Item.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    071706  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"


void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACQUIRE:{

            // Variables.
            object oPC              = GetModuleItemAcquiredBy( );
            object oItem            = GetModuleItemAcquired( );

            // Make the item undroppable.
            SetDroppableFlag( oItem, FALSE );

            break;

        }

        default:{
            nResult = X2_EXECUTE_SCRIPT_CONTINUE;
            break;
        }

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}

