//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_fund_ini
//group:   faction stuff
//used as: onclose script
//date:    nov 22 2009
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oFund    = OBJECT_SELF;
    object oPC     = GetLastClosedBy();

    clean_vars( oPC, 4 );

    SetLocalString( oPC, "ds_action", "ds_fund_act" );
    SetLocalObject( oPC, "ds_target", oFund );

    AssignCommand( oPC, ActionStartConversation( oPC, "ds_fund", TRUE, FALSE ) );
}



