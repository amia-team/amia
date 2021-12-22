/*
i_languages

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This script fires the language convo

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
06-29-2006      disco      Start of header
------------------------------------------------
*/

// Includes
#include "x2_inc_switches"


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    // Variables
    int nEvent          = GetUserDefinedItemEventNumber( );
    int nResult         = X2_EXECUTE_SCRIPT_END;



    // Which event did the Item trigger ?
    switch( nEvent ){

        // Use: Unique Power
        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC              = GetItemActivator( );
            object oTarget          = GetItemActivatedTarget();

            if ( GetIsPC( oTarget ) ){

                SetLocalObject( oPC, "ds_target", oTarget );
                SetLocalString( oPC, "ds_action", "ds_subrace_set" );

                AssignCommand( oPC, ActionStartConversation( oPC, "ds_subrace_clean", TRUE, FALSE ) );

            }
            break;

        }

        // Bug out on all other events
        default:
            return;

    }

}
