//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            SetLocalInt( oPC, "ds_node", 0 );

            //set scriptname and start convo
            SetLocalString( oPC, "ds_action", "ds_spawnrod" );
            AssignCommand( oPC, ActionStartConversation( oPC, "ds_spawnrod", TRUE, FALSE ) );

            break;

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


