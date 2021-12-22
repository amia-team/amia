//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_qst_act
//group:   quest
//used as: action script
//date:    aug 02 2008
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_qst"
#include "inc_ds_actions"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = OBJECT_SELF;
    object oNPC     = GetLocalObject( oPC, "ds_target" );
    int nNextState  = qst_check( oPC, oNPC );
    int nNode       = GetLocalInt( oPC, "ds_node" );

    clean_vars( oPC, 4 );

    if ( nNextState == nNode ){

        qst_update( oPC, oNPC );
    }

}

