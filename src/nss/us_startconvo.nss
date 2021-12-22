// Generic OnUsed event handler for starting a conversation between a PC
// and a placeable object.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/24/2003 jpavelch         Initial Release.
// 10/23/2004 jpavelch         Added the placeable object as a local var.
// 2008/08/18 disco            Added action script support

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_actions"



void main()
{
    object oPC = GetLastUsedBy( );

    if ( !GetIsPC(oPC) ) return;


    string sActionScript = GetLocalString( OBJECT_SELF, "ds_action" );

    if ( sActionScript == "" ){

        SetLocalObject( oPC, "AR_Target", OBJECT_SELF );
    }
    else{

        clean_vars( oPC, 3 );

        SetLocalObject( oPC, "ds_target", OBJECT_SELF );

        SetLocalString( oPC, "ds_action", sActionScript );
    }

    ActionStartConversation( oPC, "", TRUE, FALSE );
}

