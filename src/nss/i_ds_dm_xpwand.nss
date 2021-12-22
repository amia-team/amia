//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_dm_xpwand
//group:   DM tools
//used as: activation script
//date:    20080930
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
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
            object oPC       = InstantGetItemActivator();
            object oItem     = InstantGetItemActivated();
            object oTarget   = InstantGetItemActivatedTarget();

            if ( !GetIsPC( oTarget ) && !GetIsPossessedFamiliar( oTarget ) ){

                SendMessageToPC( oPC, "You must target a PC or possessed familiar." );
                return;
            }

            SetLocalObject( oPC, "ds_target", oTarget );
            SetLocalString( oPC, "ds_action", "ds_dm_xpwand" );

            //start convo
            AssignCommand( oPC, ActionStartConversation( oPC, "ds_dm_xpwand", TRUE, FALSE ) );

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


