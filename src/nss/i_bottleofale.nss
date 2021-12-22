/*  Bottle of Ale.

    --------
    Verbatim
    --------
    This script will make the drinker tipsy.

    ---------
    Changelog
    ---------
    Date    Name                Reason
    ----------------------------------------------------------------------------
    050106  kfw/Discosux   Initial & bug tested.
    ----------------------------------------------------------------------------

*/

// Includes
#include "x2_inc_switches"

void main( ){

    // Variables
    int nEvent              = GetUserDefinedItemEventNumber( );
    int nResult             = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC      = GetItemActivator( );

            // Drowsyness
            ApplyEffectToObject(
                                DURATION_TYPE_TEMPORARY,
                                EffectSleep( ),
                                oPC,
                                60.0f );

            break;

        }

        default:    break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
