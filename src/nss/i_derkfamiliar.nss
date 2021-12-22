#include "x2_inc_switches"
#include "nwnx_dynres"


void main( ){

    // Variables.
    int nEvent  = GetUserDefinedItemEventNumber( );
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{

            object oPC = GetItemActivator();
            object oFamiliar = GetAssociate( ASSOCIATE_TYPE_FAMILIAR, oPC );

            if( !GetIsObjectValid( oFamiliar ) ){

                SendMessageToPC( oPC, "Unfortunate, you don't even have a familiar." );
                return;
            }

            if( GetLocalInt( oPC, "default_ac_app" ) == 0 ){
                SetLocalInt( oPC, "default_ac_app", GetAppearanceType( oFamiliar ) );
            }

            AssignCommand( oPC, ActionStartConversation( oPC, "derk_familiar", TRUE, FALSE ) );

            break;

        }

        default:{
            nResult = X2_EXECUTE_SCRIPT_CONTINUE;
            break;
        }

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}

