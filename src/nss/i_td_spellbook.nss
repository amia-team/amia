#include "inc_ds_actions"
#include "x2_inc_switches"
#include "inc_ds_records"

void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            object oUser      = GetItemActivator();
            object oItem      = GetItemActivated();

            clean_vars( oUser, 4, "td_act_spellbook" );
            SetLocalObject( oUser, "ds_target", oItem );

            SetLocalInt( oUser, "ds_check_1", GetLocalString( oItem, "owner" ) == "" );
            SetLocalInt( oUser, "ds_check_2", GetName( GetPCKEY( oUser ) ) == GetLocalString( oItem, "owner" ) );
            SetLocalInt( oUser, "ds_check_3", GetLocalString( oItem, "owner" ) != "" );

            AssignCommand( oUser, ActionStartConversation( oUser, "td_spellbook", TRUE, FALSE ) );

            break;
        }
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
