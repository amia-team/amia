//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_dm_hurter
//group:   DM tools
//used as: activation script
//date:    2008-10-25
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_actions"
#include "inc_nwnx_events"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();

            //strip any remaining action variables
            clean_vars( oPC, 4 );

            SetLocalString( oPC, "ds_action", "ds_dm_hurter" );
            SetLocalObject( oPC, "ds_target", oTarget );


            //start convo
            AssignCommand( oPC, ActionStartConversation( oPC, "ds_dm_hurter", TRUE, FALSE ) );

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


