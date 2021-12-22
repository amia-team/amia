//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  td_pc_namechange
//description: actionscript for the PC namechanger
//used as: conversation ds_action script
//date:    oct 05 2008
//author:  Terra

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "cs_inc_leto"

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------
void main(){

    /*//Vars
    object  oPC     = OBJECT_SELF;

    int     nNode   = GetLocalInt( oPC, "ds_node" );

    string sValue;
    string sField;
    string sPath;

    switch( nNode ){

    // select name to alter
    case 1:

        SetLocalString( GetModule(), "td_bic_tuse", "FirstName" );
    break;

    case 2:

        SetLocalString( GetModule(), "td_bic_tuse", "LastName" );

    break;

    // set CUSTOM13000
    case 3:

        SetCustomToken( 13000,  GetLocalString( oPC, "td_color_chat" ) );

        SetLocalString( GetModule(), "td_color_chat", GetLocalString( oPC, "td_color_chat" ) );

        AR_ExportPlayer( oPC );
        break;

    // do change
    case 4:

        sValue      = GetLocalString( GetModule( ), "td_color_chat" );

        sField      = GetLocalString( GetModule( ), "td_bic_tuse" );

        AssignCommand( GetModule(), SetBicFieldValue( oPC, sField, sValue ) );

        break;

    // start listener
    case 5:

    SetLocalInt( oPC, "td_styler_listener", TRUE );

    FloatingTextStringOnCreature( "Speak the new name into the <c þ >SHOUT</c  channel now.", oPC, FALSE );

    AssignCommand(oPC,ActionPauseConversation());
    break;

    // default case, do nothing
    default:return;

    }*/
}
