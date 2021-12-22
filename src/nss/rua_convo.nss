//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_qst"
#include "inc_ds_actions"


void main(){

    object oPC      = GetLastSpeaker();

    clean_vars( oPC, 1 );

    SetLocalString( oPC, "ds_action", "rua_act" );
    SetLocalObject( oPC, "ds_target", OBJECT_SELF );

    if ( GetTag( OBJECT_SELF ) == "rua_priest" && GetPCKEYValue( oPC, "rua_ring" ) == 1 ){

        SetLocalInt( oPC, "ds_check_1", 1 );
    }

    ActionStartConversation( oPC );
}

