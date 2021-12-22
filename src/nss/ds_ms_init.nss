//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ms_init
//group:   messenger
//used as: starts dialog from rest
//date:    feb 27 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    //this script goes in the Rest convo
    object oPC = GetPCSpeaker();

    clean_vars( oPC, 4 );

    //run the convo
    ActionStartConversation( oPC, "ds_ms_dialog", TRUE, FALSE );

}
