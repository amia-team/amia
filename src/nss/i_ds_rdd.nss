//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:   i_ds_rdd
//group:    rdd customisers
//used as:  item activation script
//date:     2009-02-28
//author:   disco


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

    switch ( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oTarget   = GetItemActivatedTarget();

            SetLocalString( oPC, "ds_action", "ds_rdd_act" );
            SetLocalObject( oPC, "ds_target", oTarget );

            AssignCommand( oPC, ActionStartConversation( oPC, "ds_rdd", TRUE, FALSE ) );

        break;

    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue( nResult );
}



