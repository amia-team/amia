//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_barb_rages
//group:   classes
//used as: activation script
//date:    oct 10 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"
#include "inc_nwnx_events"
#include "inc_ds_records"
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch ( nEvent ){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            object oPC       = InstantGetItemActivator();
            object oItem     = InstantGetItemActivated();

            SendMessageToPC( oPC, "Item: " + GetName( oItem ) );

            // Playing with this while blocked's set screwed things... not risking it for now.
            if ( GetIsBlocked( oPC, "is_raging" ) > 0 ) {

                FloatingTextStringOnCreature( "<cþ>- You cannot focus on a different rage until you are calm again. -</c>", oPC, FALSE );
                return;
            }

            // item activate variables

            int nClassLevel  = GetLevelByClass( CLASS_TYPE_BARBARIAN, oPC );
            int nRageType    = GetPCKEYValue( oPC, "ds_rage_type" );



            if ( nRageType == 0 ){

                if ( nClassLevel > 9 ){

                    SendMessageToPC( oPC, " - Rage set to Unyielding Rage - " );
                    SetName( oItem, "Unyielding Rage" );
                    SetPCKEYValue( oPC, "ds_rage_type", 1 );
                }
                else{

                    SendMessageToPC( oPC, " - Rage set to Standard - " );
                    SetName( oItem, "Standard Rage" );
                }
            }

            else if ( nRageType == 1 ){

                if ( nClassLevel > 14 ){

                    SendMessageToPC( oPC, " - Rage set to Ferocity Attack - " );
                    SetName( oItem, "Ferocity Attack" );
                    SetPCKEYValue( oPC, "ds_rage_type", 2 );
                }
                else{

                    SendMessageToPC( oPC, " - Rage set to Standard - " );
                    SetName( oItem, "Standard Rage" );
                    SetPCKEYValue( oPC, "ds_rage_type", 0 );
                }
            }

            else if ( nRageType == 2 ){

                SendMessageToPC( oPC, " - Rage set to Standard - " );
                SetName( oItem, "Standard Rage" );
                SetPCKEYValue( oPC, "ds_rage_type", 0 );
            }


        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}



