/*  Amia :: DM Item :: Platinum Wand :: OnUse [Target] : Initialization

    --------
    Verbatim
    --------
    This script sets up variables for the Platinum Wand and initializes it's conversation.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    081906  kfw         Initial release.
//2007-12-02    disco   Using inc_ds_records now
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "inc_ds_records"

/* Constants */
const string CONVO_REF              = "c_pwand";
const string TARGET                 = "c_pwand_target";
const int PWAND_CONVO_VAR           = 17834;

void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oWand            = GetItemActivated( );
            object oDM              = GetItemActivator( );
            object oTarget          = GetItemActivatedTarget( );
            string szTargetName     = GetName( oTarget );
            int nDMstatus           = GetDMStatus( GetPCPlayerName( oDM ), GetPCPublicCDKey( oDM ) );

            // DM-only Wand user.
            if( nDMstatus < 1 ){

                return;
            }

            // PC-only Target.
            if( !GetIsPC( oTarget ) ){
                // Notify
                SendMessageToPC( oDM, "- Error: Target may only be a player character. -" );
                // Exit.
                break;
            }

            // Store target pointer.
            SetLocalObject( oDM, TARGET, oTarget );
            // Initialize conversation and it's variables.
            SetCustomToken( PWAND_CONVO_VAR, szTargetName );
            AssignCommand( oDM, ActionStartConversation( oDM, CONVO_REF, TRUE, FALSE ) );

            break;
        }

        default: break;
    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
