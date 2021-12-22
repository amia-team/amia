//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_fund_act
//group:   convo action stuff
//used as: onclose script
//date:    nov 22 2009
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int StoreItem( object oPC, object oItem, object oStorage, float fDelay );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oFund     = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    string sPC       = SQLEncodeSpecialChars( GetName( oPC ) );
    string sFund     = SQLEncodeSpecialChars( GetName( oFund ) );
    string sQuery;
    string sList;
    float fDelay     = 0.5;

    if ( nNode == 1 ){

        SetLocked( oFund, TRUE );

        object oItem = GetFirstItemInInventory( oFund );

        while ( StoreItem( oPC, oItem, oFund, fDelay ) ){

            fDelay += 0.1;

            oItem = GetNextItemInInventory( oFund );
        }

        fDelay += 0.5;

        //unlock box
        DelayCommand( fDelay, SetLocked( oFund, FALSE ) );

    }
    else if ( nNode == 2 ){

        sQuery = "SELECT item, count FROM funding WHERE fund = '"+sFund+"' AND pc ='"+sPC+"'";

        //execute
        SQLExecDirect( sQuery );

        while ( SQLFetch() == SQL_SUCCESS ){

            sList += SQLDecodeSpecialChars( SQLGetData( 1 ) )+": "+SQLGetData( 2 )+"\n";
        }

        SetCustomToken( 4380, GetName( oFund ) );
        SetCustomToken( 4381, GetName( oPC ) );

        SetCustomToken( 4382, sList );
    }
    else if ( nNode == 3 ){

        sQuery = "SELECT pc, SUM(count) as items FROM funding WHERE fund = '"+sFund+"' AND item != 'Gold Piece' GROUP BY pc";

        //execute
        SQLExecDirect( sQuery );

        while ( SQLFetch() == SQL_SUCCESS ){

            sList += SQLDecodeSpecialChars( SQLGetData( 1 ) )+": "+SQLGetData( 2 )+"\n";
        }

        SetCustomToken( 4383, GetName( oFund ) );

        SetCustomToken( 4384, sList );
    }
    else if ( nNode == 4 ){

        sQuery = "SELECT item, SUM(count) as items FROM funding WHERE fund = '"+sFund+"' GROUP BY item";

        //execute
        SQLExecDirect( sQuery );

        while ( SQLFetch() == SQL_SUCCESS ){

            sList += SQLDecodeSpecialChars( SQLGetData( 1 ) )+": "+SQLGetData( 2 )+"\n";
        }

        SetCustomToken( 4385, GetName( oFund ) );

        SetCustomToken( 4386, sList );
    }
    else if ( nNode == 5 ){

        sQuery = "SELECT pc, SUM(count) as items FROM funding WHERE fund = '"+sFund+"' AND item = 'Gold Piece' GROUP BY pc";

        //execute
        SQLExecDirect( sQuery );

        while ( SQLFetch() == SQL_SUCCESS ){

            sList += SQLDecodeSpecialChars( SQLGetData( 1 ) )+": "+SQLGetData( 2 )+" GP\n";
        }

        SetCustomToken( 4387, GetName( oFund ) );

        SetCustomToken( 4388, sList );
    }

}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

// Stores an item in the database
// returns -1 on error
int StoreItem( object oPC, object oItem, object oFund, float fDelay ){

    //------------------------------------------------------------------
    //quick checks
    //------------------------------------------------------------------

    if ( !GetIsPC( oPC ) ){

        return FALSE;
    }

    if ( GetObjectType( oItem ) != OBJECT_TYPE_ITEM ){

        return FALSE;
    }

    if ( GetPlotFlag( oItem ) ){

        SendMessageToPC( oPC, "Refused "+GetName( oItem )+": Plot item." );
        return FALSE;
    }
    /*
    if ( GetResRef( oItem ) == "nw_it_gold001" ){

        SendMessageToPC( oPC, "Refused "+GetName( oItem )+": Gold." );
        return FALSE;
    }
    */

    if ( GetHasInventory( oItem ) ){

        SendMessageToPC( oPC, "Refused "+GetName( oItem )+": Container." );
        return FALSE;
    }

    string sPCKEY = GetName( GetPCKEY( oPC ) );

    if ( sPCKEY == "" ){

        SendMessageToPC( oPC, "No PCKEY found on you." );
        return FALSE;
    }

    //lock box
    SetLocked( oFund, TRUE );

    //------------------------------------------------------------------
    //variables
    //------------------------------------------------------------------
    object oReceipt;
    string sPC          = SQLEncodeSpecialChars( GetName( oPC ) );
    string sItem        = SQLEncodeSpecialChars( GetName( oItem ) );
    string sFund        = SQLEncodeSpecialChars( GetName( oFund ) );
    string sQuery;
    int nCount          = GetItemStackSize( oItem );


    //------------------------------------------------------------------
    //store
    //------------------------------------------------------------------
    sQuery       = "INSERT INTO funding VALUES ( '"+
                    sFund+"', '"+
                    sPC+"', "+
                    "REPLACE( REPLACE( '"+sItem+"', '<cþ¥ >', '' ), '</c>', '' ), "+IntToString( nCount )+", NOW() ) "+
                    "ON DUPLICATE KEY UPDATE count=count+"+IntToString( nCount )+", updated=NOW()";

    DelayCommand( fDelay, SQLExecDirect( sQuery ) );


    //------------------------------------------------------------------
    //remove item
    //------------------------------------------------------------------
    fDelay += 0.5;

    DestroyObject( oItem, fDelay );

    DelayCommand( fDelay, SendMessageToPC( oPC, "Item stored!" ) );

    return TRUE;
}
