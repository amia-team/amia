//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_qst_onconvplc
//description: allows a placeable object (PLC) to run a conversation as part of
//   a quest
//used as: ?
//date:    Jun 15 2012
//author:  Xaviera

//-------------------------------------------------------------------------------
// This script is a modification of Disco's ds_qst_onconv for PCs.
// Place it in the OnUsed script slot of a PLC to run the conversation file
//   listed on the Advanced tab of that placeable when clicked on by a PC

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_qst"
#include "inc_ds_actions"


void main(){

    object oObject  = OBJECT_SELF;
    object oPC      = GetLastUsedBy();
    int nNextState  = qst_check( oPC );

    clean_vars( oPC, 1 );

    if ( nNextState > 0 ){

        SetLocalInt( oPC, "ds_check_"+IntToString( nNextState ), 1 );
        SetLocalString( oPC, "ds_action", "ds_qst_act" );
        SetLocalObject( oPC, "ds_target", OBJECT_SELF );
    }

// runs the conversation listed on the PLC (oObject) with which the PC (oPC)
//   is interacting

    AssignCommand ( oPC, ActionStartConversation( oObject ));
}

