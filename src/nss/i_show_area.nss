

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_onupdate"


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //to do: job plcs
    // area size, spawns etc

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC         = GetItemActivator();
            int nModule = GetLocalInt( GetModule(), "Module" );

            upd_ProcessAreas( nModule );

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

