/*  Item :: Prop

    --------
    Verbatim
    --------
    This script will not permit a player to pick this Item up.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    071306  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "amia_include"


void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACQUIRE:{

            // Variables.
            object oPC              = GetModuleItemAcquiredBy( );
            object oProp            = GetModuleItemAcquired( );

            // Create new instance.
            CopyObjectFixed( oProp, GetLocation( oPC ), OBJECT_INVALID, "prop" );
            // Destroy player instance.
            DestroyObject( oProp, 0.1 );

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

