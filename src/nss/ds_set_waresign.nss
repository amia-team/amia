//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_set_waresign
//group:   market
//used as: OnUse
//date:    march 22 2008
//author:  disco

//------------------------------------------------------------------------------
// changelog
//------------------------------------------------------------------------------
// date       name   description
// 08/28/12   Glim   Added the option of a widget-requirment check for opening a
//                   store on certain stalls (faction/citizen/permission only)
//
//


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "inc_ds_actions"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC     = GetLastUsedBy();
    string sChest  = "mkt_chest_"+GetLocalString( OBJECT_SELF, "number" );
    object oChest  = GetNearestObjectByTag( sChest );
    string sPermit = GetLocalString( OBJECT_SELF, "permit" );
    object oPermit = GetItemPossessedBy( oPC, sPermit );

    if ( sPermit == "" || oPermit != OBJECT_INVALID ){

        clean_vars( oPC, 1 );

        if ( GetName( OBJECT_SELF ) == "Closed" ){

            SetLocalInt( oPC, "ds_check_1", 1 );
        }
        else {

            object oUser = GetLocalObject( oChest, "mkt_user" );

            if ( oUser == oPC || GetArea( OBJECT_SELF ) != GetArea( oUser ) ){

                SetLocalInt( oPC, "ds_check_2", 1 );
            }
        }

        ActionStartConversation( oPC, "ds_wares", TRUE, FALSE );
    }

    if ( oPermit == OBJECT_INVALID && sPermit != "" )
    {
        SendMessageToPC( oPC, "This stall seems to be reserved for only those merchants with a permit to use it." );
    }
}
