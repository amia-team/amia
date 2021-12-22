//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_qst"
#include "inc_ds_actions"


void main(){

    object oPC      = GetLastSpeaker();
    int nNextState  = qst_check( oPC );

    clean_vars( oPC, 1 );

    if ( nNextState > 0 ){

        SetLocalInt( oPC, "ds_check_"+IntToString( nNextState ), 1 );
        SetLocalString( oPC, "ds_action", "ds_qst_act" );
        SetLocalObject( oPC, "ds_target", OBJECT_SELF );
    }

    ActionStartConversation( oPC );
}

