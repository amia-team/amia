//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_pm_widget
//group:   classes
//used as: activation script
//date:    dec 06 2007
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

    switch ( nEvent ){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            // item activate variables
            object oPC       = InstantGetItemActivator();
            int nClassLevel  = GetLevelByClass( CLASS_TYPE_PALE_MASTER, oPC );
            int nArmType     = GetLocalInt( oPC, "pm_attack" );

            SendMessageToPC( oPC, "widget activated" );
            SendMessageToPC( oPC, "attack type = "+IntToString( nArmType ) );

            if ( nArmType == 0 ){

                if ( nClassLevel > 5 ){

                    SendMessageToPC( oPC, " *crack* - Arm set to Weakening Touch - " );
                    SetLocalInt( oPC, "pm_attack", 1 );
                }
                else{

                    SendMessageToPC( oPC, " - Arm stays where it is - " );
                }
            }

            if ( nArmType == 1 ){

                if ( nClassLevel > 6 ){

                    SendMessageToPC( oPC, " *crack* - Arm set to Degenerative Touch - " );
                    SetLocalInt( oPC, "pm_attack", 2 );
                }
                else{

                    SendMessageToPC( oPC, " *crack* - Arm set to Paralysing Touch - " );
                    SetLocalInt( oPC, "pm_attack", 0 );
                }
            }

            if ( nArmType == 2 ){

                if ( nClassLevel > 7 ){

                    SendMessageToPC( oPC, " *crack* - Arm set to Commanding Touch - " );
                    SetLocalInt( oPC, "pm_attack", 3 );
                }
                else{

                    SendMessageToPC( oPC, " *crack* - Arm set to Paralysing Touch - " );
                    SetLocalInt( oPC, "pm_attack", 0 );
                }
            }

            if ( nArmType == 3 ){

                if ( nClassLevel > 8 ){

                    SendMessageToPC( oPC, " *crack* - Arm set to Destructive Touch - " );
                    SetLocalInt( oPC, "pm_attack", 4 );
                }
                else{

                    SendMessageToPC( oPC, " *crack* - Arm set to Paralysing Touch - " );
                    SetLocalInt( oPC, "pm_attack", 0 );
                }
            }

            if ( nArmType == 4 ){

                SendMessageToPC( oPC, " *crack* - Arm set to Paralysing Touch - " );
                SetLocalInt( oPC, "pm_attack", 0 );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}



