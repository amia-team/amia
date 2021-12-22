/*  Widget :: Renameable Sign :: Spawn Sign and Create Dialog to Rename Sign

    --------
    Verbatim
    --------
    This script creates a placeable sign in-game and permits the user to rename it.
    It also removes this same sign by activating the widget again.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    060306  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"

/* Constants */
const string PLC_SPAWNED        = "cs_plc_rm_sign_spawned";
const string PLC_REF            = "rm_plc_sign";
const string PLC_CONVO          = "c_rm_sign";


void main( ){

    // Variables.
    int nEvent                  = GetUserDefinedItemEventNumber( );
    int nResult                 = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC          = GetItemActivator( );
            location lOrigin    = GetItemActivatedTargetLocation( );
            object oSign        = OBJECT_INVALID;

            int nSpawned        = GetLocalInt( oPC, PLC_SPAWNED );

            // Sign not spawned, spawn it.
            if( !nSpawned ){
                // Spawn the sign.
                oSign = CreateObject( OBJECT_TYPE_PLACEABLE, PLC_REF, lOrigin );
                // Initiate conversation to rename sign.
                AssignCommand( oPC, ActionStartConversation( oSign, PLC_CONVO, TRUE, FALSE ) );
                // Notify the user the sign was created.
                SendMessageToPC( oPC, "- Your renameable sign was created. -" );
            }
            // Spawned, remove it.
            else{

                // Valid.
                if( GetIsObjectValid( ( oSign = GetNearestObjectByTag( PLC_REF, oPC ) ) ) ){
                    DestroyObject( GetNearestObjectByTag( PLC_REF, oPC ) );
                    // Notify the user the sign was removed.
                    SendMessageToPC( oPC, "- Your renameable sign was removed. -" );
                }
                // Invalid.
                else{
                    // Notify the user their sign wasn't removed and to move closer to it.
                    SendMessageToPC( oPC, "- Please go nearer to your renameable sign to remove it. -" );
                    // Bug out.
                    break;
                }

            }

            // Toggle spawn status control integer.
            SetLocalInt( oPC, PLC_SPAWNED, !nSpawned );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
