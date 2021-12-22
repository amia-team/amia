//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: kohl_travel_ini
//group: travel
//used as: onuse script
//date: 2019-06-18
//author: Jes


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC = GetLastUsedBy();
    int i;

    clean_vars( oPC, 1 );

    SetLocalString( oPC, "ds_action", "kohl_travel_act" );
    SetLocalObject( oPC, "ds_target", OBJECT_SELF );

    int nCheck = GetLocalInt( OBJECT_SELF, "check" );

    if ( nCheck > 0 ){

        SetLocalInt( oPC, "ds_check_"+IntToString( nCheck ), 1 );
    }

    ActionStartConversation( oPC );
}
