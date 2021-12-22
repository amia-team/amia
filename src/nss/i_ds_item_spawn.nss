void main (){}
/*
//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_item_spawn
//group:
//used as: activation script
//date:    apr 02 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "aps_include"
#include "x2_inc_itemprop"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int StoreItem( object oPC, string sPCKEY, object oItem );
string CreateItemKey( object oPC );
void SetConvo( object oPC, object oItem );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch ( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oPC       = GetItemActivator();
            object oItem     = GetItemActivated();
            object oTarget   = GetItemActivatedTarget();
            location lTarget = GetItemActivatedTargetLocation();
            int nStoredItems = GetLocalInt( oItem, "is_items" );
            string sItemKey  = GetLocalString( oItem, "is_key" );

            if ( sItemKey == "" ){

                sItemKey = CreateItemKey( oPC );

                SetLocalString( oItem, "is_key", sItemKey );
                SendMessageToPC( oPC, "Starting item storage. Use the widget on yourself when you are done." );
                SetName( oItem, "Item Spawner: Initialised" );
            }

            if ( GetName( oItem ) == "Item Spawner: Initialised" ){
            //if ( GetIsDM( oPC ) ){

                //store items in database
                if ( nStoredItems > 5 ){

                    SendMessageToPC( oPC, "You can store up to 6 items in this widget!" );

                    SetName( oItem, "Item Spawner: Full" );

                    IPRemoveAllItemProperties( oItem, DURATION_TYPE_PERMANENT );

                    itemproperty ipUses = ItemPropertyCastSpell( IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY );

                    IPSafeAddItemProperty( oItem, ipUses );

                    return;
                }

                if ( oTarget == oPC ){

                    SendMessageToPC( oPC, "Widget completed! You can give it a better name in the Renamer area." );

                    SetName( oItem, "Item Spawner: Completed" );

                    IPRemoveAllItemProperties( oItem, DURATION_TYPE_PERMANENT );

                    itemproperty ipUses = ItemPropertyCastSpell( IP_CONST_CASTSPELL_UNIQUE_POWER_SELF_ONLY, IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY );

                    IPSafeAddItemProperty( oItem, ipUses );

                    return;
                }

                if ( GetObjectType( oTarget ) != OBJECT_TYPE_ITEM ){

                    SendMessageToPC( oPC, "You can only store items in this widget!" );

                    return;
                }

                ++nStoredItems;

                sItemKey = sItemKey + "_" + IntToString( nStoredItems );

                int nResult = StoreItem( oPC, sItemKey, oTarget );

                if ( nResult == 1 ){


                    SetLocalInt( oItem, "is_items", nStoredItems );
                    SetLocalString( oItem, "is_item_"+IntToString( nStoredItems ), GetName( oTarget ) );

                    SendMessageToPC( oPC, "Stored item "+IntToString( nStoredItems ) + ": "+ GetName( oTarget ) + "." );
                }
                else{

                    SendMessageToPC( oPC, "Couldn't store this item!" );
                }
            }
            else{

                SetConvo( oPC, oItem );
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//----------------------------

string CreateItemKey( object oPC ){

    string sQuery = "SELECT CEIL(UTC_TIMESTAMP())";
    string sItemKey;

    //execute query
    SQLExecDirect( sQuery );

    if ( SQLFetch() == SQL_SUCCESS ) {

        sItemKey = GetPCPublicCDKey( oPC ) + "_" + SQLGetData(1);
    }

    return sItemKey;
}

int StoreItem( object oPC, string sItemKey, object oItem ){

    SetIdentified( oItem, TRUE );

    string sPC    = SQLEncodeSpecialChars( GetName( oPC ) );

    string sQuery = "INSERT INTO object_storage VALUES ( NULL, '"+
                    sPC+"', '"+
                    sItemKey+"', "+
                    "%s, NOW() )";
    //execute
    SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

    //sql hooks into BioWare campaign DB stuff
    return StoreCampaignObject ( "NWNX", "-", oItem );
}

void SetConvo( object oPC, object oItem ){

    int i;
    int nResult;
    string sName;


    for( i=1; i<7; ++i ){

        sName = GetLocalString( oItem, "is_item_"+IntToString( i ) );

        if ( sName != "" ){

            SetCustomToken( ( 4730 + i ), sName );

            SetLocalInt( oPC, "ds_check_"+IntToString( i ), 1 );

            nResult = 1;
        }
        else{

            DeleteLocalInt( oPC, "ds_check_"+IntToString( i ) );
        }
    }

    if ( nResult ){

        SetLocalString( oPC, "ds_action", "ds_item_spawn" );

        SetLocalObject( oPC, "ds_target", oItem );

        AssignCommand( oPC, ActionStartConversation( oPC, "ds_item_spawn", TRUE, FALSE ) );
    }
}*/



