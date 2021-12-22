/*  Item :: Supernatural Ability: Thousand Faces :: Initialize Conversation

    --------
    Verbatim
    --------
    This script initalizes the Thousand Faces item conversation.
    If its the first use of the item it'll store the character's original form.
    It allows the character to morph into a variety of forms.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062506  kfw         Initial release.
    081706  Terra       Added ds_action support / clean up.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "x2_inc_switches"
#include "amia_include"


void main( ){

    // Variables.
    int nEvent                      = GetUserDefinedItemEventNumber( );
    int nResult                     = X2_EXECUTE_SCRIPT_END;

    switch( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:{



            // Variables
            object oItem        = GetItemActivated( );
            object oPC          = GetItemActivator( );

            int nFirstUse       = GetLocalInt( oItem, "cs_first_use" );

            // First use?
            if( !nFirstUse ){
                SendMessageToPC( oPC ,"Head: "+ IntToString(GetCreatureBodyPart( CREATURE_PART_HEAD, oPC ) )+" Saved!" );
                // Store character's original appearance.
                SetLocalInt( oItem, "cs_original_appearance", GetAppearanceType( oPC ) );
                // Store head appearance value.
                SetLocalInt( oItem, "cs_original_head", GetCreatureBodyPart( CREATURE_PART_HEAD, oPC ) );
                // Store character's original appearance.
                SetLocalInt( oItem, "cs_original_tail", GetCreatureTailType( oPC ) );
                // Sanity.
                SetLocalInt( oItem, "cs_first_use", 1 );

            }

            if( !GetLocalInt( oItem, "td_1kfcolor" ) ){

                SendMessageToPC( oPC, "Saved colors!\nSkin: "+IntToString( GetColor( oPC, COLOR_CHANNEL_SKIN ) )+"\nHair: "+IntToString( GetColor( oPC, COLOR_CHANNEL_HAIR ) ) );
                SetLocalInt( oItem, "td_orginal_haircolor", GetColor( oPC, COLOR_CHANNEL_HAIR ) );
                SetLocalInt( oItem, "td_orginal_skincolor", GetColor( oPC, COLOR_CHANNEL_SKIN ) );
                SetLocalInt( oItem, "td_1kfcolor", 1 );     ExportSingleCharacter( oPC );

            }

            if( GetLocalInt( oItem, "td_1kfhead" ) < 1 )
                SetLocalInt( oItem, "td_1kfhead", 1 );

            //Catch the item as it holds what we need later in the convo
            SetLocalObject( oPC ,"1kfaces", oItem );

            // Initialize ds_nodes.
            SetLocalString( oPC, "ds_action", "ca_thousandfaces");

            SetLocalInt( oPC, "1kf_head_sel", 0 );

            SendMessageToPC(oPC, "<cþ þ>Stored Head: "+IntToString( GetLocalInt( oItem , "cs_original_head" ) ) );
            SendMessageToPC(oPC, "<cþ þ>Stored Appearance: "+IntToString( GetLocalInt( oItem, "cs_original_appearance" ) ) );
            SendMessageToPC(oPC, "<cþ þ>Stored Tail: "+IntToString( GetLocalInt( oItem, "cs_original_tail" ) ) );
            SendMessageToPC(oPC, "<cþ þ>Stored Hair Color: "+IntToString( GetLocalInt( oItem , "td_orginal_haircolor" ) ) );
            SendMessageToPC(oPC, "<cþ þ>Stored Skin Color: "+IntToString( GetLocalInt( oItem, "td_orginal_skincolor" ) ) );
            // Initialize conversation.
            AssignCommand( oPC, ActionStartConversation( oPC, "c_1000faces", TRUE, FALSE ) );

            break;

        }

        default: break;

    }

    SetExecutedScriptReturnValue( nResult );

    return;

}
