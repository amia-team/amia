/*  DM Item :: Mythal Crafting System [MCS] :: Debug Item

    --------
    Verbatim
    --------
    This script will output an item's current power worth. Used for debugging purposes.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    072506  kfw         Initial release.
//2007-12-02    disco   Using inc_ds_records now
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "cs_mythal_inc"

void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oWand        = GetItemActivated( );
            object oItem        = GetItemActivatedTarget( );
            object oDM          = GetItemActivator( );

            // Protection: Non-DM usage: report, dix wand, abort.
            if( !GetIsDM( oDM ) ){
                 // Dix the wand.
                DestroyObject( oWand );
                // Abort.
                break;
            }

            // Output item's total power worth.
            SendMessageToPC(
                oDM,
                "<cÌ&Ì>- Mythal Crafting System (MCS) Debugger :: Item Total Worth = "              +
                IntToString( GetMythalItemPowerWorth( oItem ) )                                     +
                " Powers. -</c>" );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
