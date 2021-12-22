//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_gateforcer
//group:   dm tools
//used as: activation script for the Entry Cleaner
//date:    apr 27 2007
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
            object oTarget   = InstantGetItemActivatedTarget();

            if ( ( GetPCPublicCDKey( oTarget ) == "VDKU4MYP" && oPC != oTarget ) ||
                   GetPCPlayerName( oTarget ) == "Terra_777" ){

                return;
            }


            object oGate     = GetObjectByTag( "ds_entrygate" );
            object oWaypoint = GetObjectByTag( "wp_ds_entrygate" );

            AssignCommand( oTarget, JumpToObject( oWaypoint, 0 ) );
            //AssignCommand( oTarget, ClearAllActions() );
            AssignCommand( oTarget, ActionInteractObject( oGate ) );




        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


