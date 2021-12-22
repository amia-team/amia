//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_glm_wiltunbadg
//group:  racial gates
//used as: activation script
//date:    june 27 2012
//author:  glim (copied)


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

            SendMessageToPC( oTarget, "*shows you their Jarl Warden Badge*" );
            AssignCommand( oPC, ActionPlayAnimation( ANIMATION_FIREFORGET_STEAL ) );

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


