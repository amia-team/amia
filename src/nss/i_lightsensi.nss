// Adds light sensitivity to a PC on acquiring it.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/11/2011 PaladinOfSune    Initial Release
//

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

            // Make the item undroppable.
            SetLocalInt( oPC, "LightSensitive", 1 );
            SendMessageToPC( oPC, "You have gained light sensitivity." );
            break;

        }

        case X2_ITEM_EVENT_UNACQUIRE:{

            // Variables.
            object oPC              = GetModuleItemLostBy( );

            // Make the item undroppable.
            SetLocalInt( oPC, "LightSensitive", 0 );
            SendMessageToPC( oPC, "You have lost your light sensitivity." );
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

