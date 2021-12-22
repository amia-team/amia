//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:
//group:
//used as: activation script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


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
            object oPC          = GetItemActivator();
            object oTarget      = GetItemActivatedTarget();
            int nFeedbackLevel  = GetLocalInt( oTarget, "ds_feedback" );

            if ( nFeedbackLevel > 3 ){

                nFeedbackLevel = 0;
            }
            else{

                ++nFeedbackLevel;
            }

            SetLocalInt( oTarget, "ds_feedback", nFeedbackLevel );

            SendMessageToPC( oPC, "Feedback level set to "+IntToString( nFeedbackLevel ) ) ;


        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//----------------------------

