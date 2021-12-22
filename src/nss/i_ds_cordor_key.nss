//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_cordor_key
//group:  racial gates
//used as: activation script
//date:    feb 29 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oTarget   = GetItemActivatedTarget();

            SendMessageToPC( oTarget, "*shows you his Cordor Signet Ring*" );
            AssignCommand( oPC, ActionPlayAnimation( ANIMATION_FIREFORGET_STEAL ) );

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


