//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_dms
//group:   DMS
//used as: activation script
//date:    20080930
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_dms"
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
            location lTarget = GetItemActivatedTargetLocation();

            if ( GetName( oItem ) == "DMS Copier" ){

                SetLocalInt( oPC, "ds_node", GetLocalInt( oPC, "ds_dms_node" ) );
                SetLocalInt( oPC, "ds_section", GetLocalInt( oPC, "ds_dms_section" ) );
                SetLocalObject( oPC, "ds_target", oTarget );
                SetLocalLocation( oPC, "ds_target", lTarget );

                ExecuteScript( "ds_dms", oPC );

                return;
            }

            //strip any remaining action variables
            clean_vars( oPC, 4 );

            SetLocalString( oPC, "ds_action", "ds_dms" );
            SetLocalObject( oPC, "ds_target", oTarget );
            SetLocalLocation( oPC, "ds_target", lTarget );

            /*
            //portals
            string sPC       = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
            int i;

            for ( i=1; i<11; ++i ){

                SetCustomToken( (4260+i), "" );
            }

            object oCache = GetCache( "ds_bindpoint_storage" );
            string sQuery = "SELECT (4260+slot), title, reference FROM dm_settings WHERE account='"+sPC+"' AND TYPE=8 AND reference > -1";

            if ( sQuery != "" ){

                SQLExecDirect( sQuery );

                while ( SQLFetch() == SQL_SUCCESS ){

                    if ( !GetIsObjectValid( GetLocalObject( oCache, "b_"+SQLGetData(3) ) ) ){

                        SetCustomToken( StringToInt( SQLGetData(1) ), "<cþ  >"+SQLDecodeSpecialChars( SQLGetData(2) )+"</c>" );
                    }
                    else{

                        SetCustomToken( StringToInt( SQLGetData(1) ), "<cþþ >"+SQLDecodeSpecialChars( SQLGetData(2) )+"</c>" );
                    }
                }
            }
            */

            //start convo
            AssignCommand( oPC, ActionStartConversation( oPC, "ds_dms", TRUE, FALSE ) );

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


