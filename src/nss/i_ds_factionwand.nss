//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_factionwand
//group:
//used as: activation script
//date:    july 02 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_porting"
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void faction_initiate( object oUser, object oTarget, object oItem );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            string sItemName = GetName(oItem);


            if ( sItemName == "Faction Wand: Unset" && GetIsDM( oPC ) ){

                object oCache       = GetCache( "ds_bindpoint_storage" );
                string sBP;
                string sTitle;
                int i;
                int nToken;

                //strip any remaining action variables
                clean_vars( oPC, 4 );

                SetLocalString( oPC, "ds_action", "ds_factionwand" );
                SetLocalObject( oPC, "ds_target", oItem );

                for ( i=1; i<=30; ++i ){

                    sBP         = GetLocalString( oCache, "f_" + IntToString( i ) );
                    sTitle      = GetLocalString( oCache, sBP );
                    nToken      = 4450+i;

                    if ( sTitle != "" ){

                        SetLocalInt( oPC, "ds_check_"+IntToString( i ), 1 );
                        SetCustomToken( nToken, sTitle );
                    }
                    else{

                        break;
                    }
                }

                AssignCommand( oPC, ActionStartConversation( oPC, "ds_factionwand", TRUE, FALSE ) );
            }
            else if ( sItemName == "Faction Wand: Unset" ){

                DestroyObject( oItem );
            }
            else{

                faction_initiate( oPC, oTarget, oItem );
            }

        break;
    }

    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

void faction_initiate( object oUser, object oTarget, object oItem ){

    // item activate variables
    object oCache          = GetCache( "ds_bindpoint_storage" );
    string sUserFaction    = IntToString( GetPCKEYValue( oUser, "bp_2" ) );
    string sTargetFaction  = IntToString( GetPCKEYValue( oTarget, "bp_2" ) );
    string sItemFaction    = GetLocalString( oItem, "faction" );
    string sWP             = "b_" + sItemFaction;
    string sResRef         = GetLocalString( oCache, "i_" + sItemFaction );
    string sOldResRef      = GetLocalString( oCache, "i_" + sTargetFaction );
    string sTitle;

    //check if it's used on a PC
    if ( !GetIsPC( oTarget ) ){

        //already has a faction
        SendMessageToPC( oUser, "You can only use this item on a PC." );

        return;
    }

    //check if it's used on a PC
    if ( !GetIsObjectValid( GetPCKEY( oTarget ) ) ){

        //already has a faction
        SendMessageToPC( oUser, "The PC needs to have a PCKEY." );

        return;
    }

    //check if the user is a faction member
    if ( sUserFaction != sItemFaction && !GetIsDM( oUser ) ){

        //already has a faction
        SendMessageToPC( oUser, "This item has been created to be used by members of another faction." );

        DestroyObject( oItem );

        return;
    }

    //make sure this PC is inside the faction area
    if ( !GetIsObjectValid( GetNearestObjectByTag( sWP, oUser ) ) ){

        SendMessageToPC( oUser, "You can only use this item inside your faction area." );

        return;
    }

    //check if the target is a faction member
    if ( sTargetFaction == sItemFaction ){

        //take away old items
        DestroyObject( GetItemPossessedBy( oTarget, "ds_insignia" ) );

        //take away faction wand
        DestroyObject( GetItemPossessedBy( oTarget, "ds_factionwand" ) );

        //take away faction key
        DestroyObject( GetItemPossessedBy( oTarget, sResRef ) );

        //delete faction
        SetPCKEYValue( oTarget, "bp_2", 0 );

        //feedback
        SendMessageToPC( oTarget, "You are no longer part of your faction!" );
        SendMessageToPC( oUser, "You removed "+GetName( oTarget )+" from your faction!" );

        return;
    }

    //check if the target is a faction member
    if ( sTargetFaction != "0" ){

        //already has a faction
        SendMessageToPC( oTarget, "You are no longer part of your previous faction!" );

        //take away old items
        DestroyObject( GetItemPossessedBy( oTarget, "ds_insignia" ) );

        //take away faction wand
        DestroyObject( GetItemPossessedBy( oTarget, "ds_factionwand" ) );

        //take away faction key
        DestroyObject( GetItemPossessedBy( oTarget, sResRef ) );
    }

    //store new faction
    SetPCKEYValue( oTarget, "bp_2", StringToInt( sItemFaction ) );

    sTitle    = GetLocalString( oCache, sWP );

    object oInsignia = CreateItemOnObject( "ds_insignia", oTarget );

    SetName( oInsignia, sTitle+" Insignia" );

    CreateItemOnObject( sResRef, oTarget );

    SetDescription( oInsignia, sResRef, FALSE );

    //feedback
    SendMessageToPC( oUser, "You made "+GetName( oTarget )+" member of your faction!" );
    SendMessageToPC( oTarget, "You are now part of the "+sTitle+"!" );

}
