//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_seatravel_ini
//group: travel
//used as: onconvo script
//date: 2008-09-13
//author: disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "amia_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC = GetLastSpeaker();

    clean_vars( oPC, 1 );

    SetLocalString( oPC, "ds_action", "ds_seatravel_act" );
    SetLocalObject( oPC, "ds_target", OBJECT_SELF );

    int i = 1;
    int nIndex = GetLocalInt( OBJECT_SELF, "st_"+IntToString( i )+"_index" );

    while ( nIndex ){

        SetLocalInt( oPC, "ds_check_"+IntToString( nIndex ), 1 );

        ++i;

        nIndex = GetLocalInt( OBJECT_SELF, "st_"+IntToString( i )+"_index" );
    }

    ActionStartConversation( oPC );
}

