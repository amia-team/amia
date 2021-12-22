/*  Item :: Cordor Guard: Guard Pay: OnUse [Target]

    --------
    Verbatim
    --------
    This script will pop up a menu to allow the wage payer to issue wages to the Guards.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082906  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"


/* Constants. */
const string TARGET             = "cs_target";
const string CONVO_REF          = "c_guardpay";
const int GUARD_PAY_TARGET_NAME = 58315;


void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            object oGuard       = GetItemActivatedTarget( );


            // Filter: PC's only.
            if( !GetIsPC( oGuard ) ){
                // Notify the PC.
                SendMessageToPC( oPC, "- You may only use the Guard Pay wand on PC's! -" );
                break;
            }

            // Initialize variables and convo.
            SetLocalObject( oPC, TARGET, oGuard );
            SetCustomToken( GUARD_PAY_TARGET_NAME, GetName( oGuard ) );
            AssignCommand( oPC, ActionStartConversation( oPC, CONVO_REF, TRUE, FALSE ) );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}


