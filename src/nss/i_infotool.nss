//  20070630  Disco       Added item history tracer


#include "x2_inc_switches"
#include "X0_I0_PARTYWIDE"
#include "nw_i0_plot"
#include "inc_ds_info"
#include "inc_nwnx_events"

void main(){
    int nEvent = GetUserDefinedItemEventNumber();
    int nToggle;
    object oDM;
    object oItem;
    object oTarget;
    location lTarget;

    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            oDM     = InstantGetItemActivator();
            oItem   = InstantGetItemActivated();
            oTarget = InstantGetItemActivatedTarget();
            lTarget = InstantGetItemActivatedTargetLocation();


            //check for double-click
            if( GetLocalString( OBJECT_SELF, "sLastTarget" ) == GetName( oTarget ) ){

                DeleteLocalString( OBJECT_SELF,"sLastTarget");
                nToggle = 2;
            }
            else{

                nToggle=1;
                //store the last target on the rod for double-clicks
                SetLocalString( OBJECT_SELF, "sLastTarget", GetName( oTarget ) );
            }

            if (GetObjectType(oTarget)==OBJECT_TYPE_CREATURE){

                if (GetIsPC(oTarget)==TRUE){

                    if(nToggle==1){

                        GetPCInfo(oTarget,oDM );
                        GetCreatureInfo(oTarget,oDM );
                        SendMessageToPC( oDM, "\nClick this PC again for more info.");
                    }
                    else{

                        GetXPDC(oTarget,oDM );
                        GetNetWorth(oTarget,oDM );
                        GetParty(oTarget,oDM );
                        ReportXPStatus(oTarget,oDM );
                    }
                }
                else{

                    GetNpcInfo(oTarget, oDM );
                    GetCreatureInfo(oTarget,oDM );
                }
            }
            else if (GetObjectType(oTarget)==OBJECT_TYPE_ITEM){

                GetItemInfo(oTarget,oDM );
            }
            else if (GetObjectType(oTarget)==OBJECT_TYPE_DOOR){

                GetDoorInfo(oTarget, oDM );
            }
            else if (GetObjectType(oTarget)==OBJECT_TYPE_PLACEABLE){

                GetPlaceableInfo(oTarget, oDM );
            }
            else {

                GetAreaInfo( oDM, GetArea( oDM ) );
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}


