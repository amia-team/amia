//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_actions
//group:   transmutation
//used as: action script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

// Checks show many items the player has stored
// returns -1 on error
int GetStoredItems( object oPC );

// Stores an item in the database
// returns -1 on error
int StoreItem( object oPC, object oStorage, object oItem );

// Retrieves an item from the database
// returns -1 on error
int RetreiveItem( object oPC, object oStorage, object oReceipt );

// Removes an item from the database
// You better call this after creating the item
void DeleteStoredItem( object oPC, string sItemKey );

void TransferHistory( object oPC, object oItem1, object oItem2 );





//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

// Checks show many items the player has stored
// returns -1 on error
int GetStoredItems( object oPC ){

    string sPCKEY = GetName( GetPCKEY( oPC ) );

    if ( sPCKEY == "" ){

        SendMessageToPC( oPC, "No PCKEY found on you." );
        return -1;
    }

    string sQuery = "SELECT COUNT(id) as item_count FROM player_storage WHERE pckey = '"+sPCKEY+"'";

    //execute
    SQLExecDirect( sQuery );

    if ( SQLFetch() == SQL_SUCCESS ){

        return StringToInt( SQLGetData( 1 ) );
    }
    else{

        return 0;
    }

    return -1;
}


// Stores an item in the database
// returns -1 on error
int StoreItem( object oPC, object oStorage, object oItem ){

    //------------------------------------------------------------------
    //quick checks
    //------------------------------------------------------------------

    if ( !GetIsPC( oPC ) ){

        return -1;
    }

    if ( GetObjectType( oItem ) != OBJECT_TYPE_ITEM ){

        return -1;
    }

    if ( GetPlotFlag( oItem ) ){

        SendMessageToPC( oPC, "Refused "+GetName( oItem )+": Plot item." );
        return -1;
    }

    if ( GetResRef( oItem ) == "nw_it_gold001" ){

        SendMessageToPC( oPC, "Refused "+GetName( oItem )+": Gold." );
        return -1;
    }

    if ( GetHasInventory( oItem ) ){

        SendMessageToPC( oPC, "Refused "+GetName( oItem )+": Container." );
        return -1;
    }

    string sPCKEY = GetName( GetPCKEY( oPC ) );

    if ( sPCKEY == "" ){

        SendMessageToPC( oPC, "No PCKEY found on you." );
        return -1;
    }

    //lock box
    SetLocked( oStorage, TRUE );

    //------------------------------------------------------------------
    //variables
    //------------------------------------------------------------------
    object oReceipt;
    string sPC          = SQLEncodeSpecialChars( GetName( oPC ) );
    string sItemKey;
    string sItemName    = SQLEncodeSpecialChars( GetName( oItem ) );
    string sItemResRef  = GetResRef( oItem );
    string sItemPrice   = "";
    string sReceiptName = "";
    string sQuery       = "";
    string sOffice      = GetLocalString( oStorage, "office" );

    //------------------------------------------------------------------
    //create key
    //------------------------------------------------------------------

    sQuery = "SELECT CEIL(UTC_TIMESTAMP())";

    //execute query
    SQLExecDirect( sQuery );

    if ( SQLFetch() == SQL_SUCCESS ) {

        sItemKey = GetPCPublicCDKey( oPC ) + "_" + SQLGetData(1);
    }
    else{

        SetLocked( oStorage, FALSE );
        return -1;
    }

    //------------------------------------------------------------------
    //create receipt
    //------------------------------------------------------------------
    //identify and get price
    if ( !GetIdentified( oItem ) ){

        SetIdentified( oItem, TRUE );

        sItemPrice      = IntToString( GetGoldPieceValue( oItem ) );
        //sReceiptName    = "Receipt: " + GetItemBaseTypeName( oItem ) + " (" + sOffice + ")";

        SetIdentified( oItem, FALSE );

    }
    else{

        sItemPrice      = IntToString( GetGoldPieceValue( oItem ) );
        //sReceiptName    = "Receipt: " + GetName( oItem ) + " (" + sOffice + ")";
    }

    //I put the resref in the tag.
    //This will make sure the resref won't get lost due to crashing DMs.
    //oReceipt = CreateItemOnObject( "ds_receipt", oPC, 1, sItemKey );

    //SetName( oReceipt, sReceiptName );

    //DelayCommand( 0.3, SetLocalString( oReceipt, "office", sOffice ) );

    //DelayCommand( 0.6, TransferHistory( oPC, oItem, oReceipt ) );

    //------------------------------------------------------------------
    //store
    //------------------------------------------------------------------
    sQuery       = "INSERT INTO player_storage VALUES ( NULL, '"+
                    sPC+"', '"+
                    sPCKEY+"', '"+
                    sItemKey+"', '"+
                    sItemName+"', '"+
                    sItemResRef+"', "+
                    sItemPrice+", "+
                    "%s, NOW() )";
    //execute
    SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

    //sql hooks into BioWare campaign DB stuff
    StoreCampaignObject ( "NWNX", "-", oItem );


    //------------------------------------------------------------------
    //remove item
    //------------------------------------------------------------------
    DestroyObject( oItem, 5.0 );

    //unlock box
    DelayCommand( 5.0, SetLocked( oStorage, FALSE ) );


    DelayCommand( 5.0, SendMessageToPC( oPC, "Item stored!" ) );


    return 1;
}


// Retrieves an item from the database
// returns -1 on error
int RetreiveItem( object oPC, object oStorage, object oReceipt ){

    //------------------------------------------------------------------
    //quick checks
    //------------------------------------------------------------------
    if ( GetResRef( oReceipt ) != "ds_receipt" ){

        SendMessageToPC( oPC, "Refused Item: Not a receipt." );

        return -1;
    }

    string sItemKey = GetTag( oReceipt );

    if ( sItemKey == "ds_receipt" || sItemKey == "" ){

        SendMessageToPC( oPC, "Refused Item: Not a valid receipt." );

        return -1;
    }

    SetLocked( oStorage, TRUE );

    //------------------------------------------------------------------
    //variables
    //------------------------------------------------------------------
    string sStoreOffice     = GetLocalString( oStorage, "office" );
    string sRetrieveOffice  = GetLocalString( oReceipt, "office" );
    string sQuery           = "";
    int nFee                = 5;
    object oItem;

    if ( sStoreOffice != sRetrieveOffice ){

        SendMessageToPC( oPC, "You will be charged for transport from "+sStoreOffice+" to "+sRetrieveOffice+"!" );
        nFee = nFee + 20;
    }

    if ( GetGold( oPC ) >= nFee ){

        sQuery = "SELECT item_data FROM player_storage WHERE item_key = '" + sItemKey + "' LIMIT 1";

        //execute
        SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

        //sql hooks into BioWare campaign DB stuff
        oItem =  RetrieveCampaignObject ("NWNX", "-", GetLocation( oPC ), oPC );

        //check object valid
        if ( !GetIsObjectValid( oItem ) ){

            SendMessageToPC( oPC, "This receipt did not result in an item. Keep it and show it to a DM." );

            SetLocked( oStorage, FALSE );

            return -1;
        }

        //take gold
        TakeGoldFromCreature( nFee, oPC, TRUE );

        //restore item vars
        DelayCommand( 0.6, TransferHistory( oPC, oReceipt, oItem ) );

        //delete from database
        DelayCommand( 3.0, DeleteStoredItem( oPC, sItemKey ) );

        //delete receipt
        DestroyObject( oReceipt, 3.0 );

        //unlock box
        DelayCommand( 3.0, SetLocked( oStorage, FALSE ) );

        return 1;
    }
    else{

        SendMessageToPC( oPC, "Not enough gold!" );

        SetLocked( oStorage, FALSE );

        return -1;
    }
}

// Removes an item from the database
// You better call this after creating the item
void DeleteStoredItem( object oPC, string sItemKey ){

    if ( sItemKey == "" || sItemKey == "0" ){

        SendMessageToPC( oPC, "Not a valid entry." );
        return;
    }

    string sKey = GetName( GetPCKEY( oPC ) );

    if ( sKey == "" ){

        SendMessageToPC( oPC, "No PCKEY found on you." );
        return;
    }

    string sQuery = "DELETE FROM player_storage WHERE item_key = '"+sItemKey+"' LIMIT 1";

    //execute
    SQLExecDirect( sQuery );
}

void TransferHistory( object oPC, object oItem1, object oItem2 ){

    int nOwners = GetLocalInt( oItem1, "ds_os" );
    int i;
    string sVar;
    string sVal;
    float fDelay;

    SetLocalInt( oItem2, "ds_os", nOwners );

    for( i=1; i<=nOwners; ++i ){

        sVar = "ds_os_"+IntToString( i );
        sVal = GetLocalString( oItem1, sVar );

        fDelay = 1/10.0;

        //DelayCommand( fDelay, SendMessageToPC( oPC, sVar + "=" + sVal ) );
        DelayCommand( fDelay, SetLocalString( oItem2, sVar, sVal ) );
    }

    fDelay = 1.0 + fDelay;

    DestroyObject( oItem1, fDelay );
}



