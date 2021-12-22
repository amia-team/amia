//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_dc_recom
//group:   Dream Coin system
//used as: DM PC rod activation script
//date:    apr 15 2007
//author:  disco

//-----------------------------------------------------------------------------
// changes
//-----------------------------------------------------------------------------
//2007-05-14    disco   Rewrote the recommendation routines
//2007-12-02    disco   Using inc_ds_records now

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_records"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------

//get number of coins of oTarget
int GetAccount( object oUser, object oDM );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            object oUser     = GetItemActivator();
            object oTarget   = GetItemActivatedTarget();
            object oItem     = GetItemActivated();
            int nDMstatus    = GetDMStatus( GetPCPlayerName( oTarget ), GetPCPublicCDKey( oTarget ) );

            //init checks
            SetLocalInt( oUser, "ds_check_1", 0 );
            SetLocalInt( oUser, "ds_check_2", 0 );
            SetLocalInt( oUser, "ds_check_3", 0 );

            //old coins must be stored!
            if ( GetItemPossessedBy( oUser, "dreamcoin" ) != OBJECT_INVALID ){

                SetLocalInt( oUser, "ds_check_1", 1 );
            }

            if ( !GetIsPC( oTarget ) ){

                SendMessageToPC( oUser, "You can only target PCs with this item." );
            }
            else{

                if ( oTarget == oUser ){        //used in self

                    //get DC account
                    int nAccount = GetAccount( oUser, oTarget );

                    //set check
                    if ( nAccount > 0 ){

                        SetLocalInt( oUser, "ds_check_2", 1 );
                    }

                    //set target
                    SetLocalObject( oUser, "ds_target", oUser );

                    //set action script
                    SetLocalString( oUser, "ds_action", "ds_dc_actions" );

                    //custom token
                    SetCustomToken( 4103, IntToString( nAccount ) );

                    //dialog
                    AssignCommand( oUser, ActionStartConversation( oUser, "ds_dc_recom", TRUE, FALSE ) );

                }
                else if ( nDMstatus > 0 ) {

                    //target is a DM
                    SendMessageToPC( oUser, "You cannot recommend a DM's roleplay. Their egos are big enough as it is." );
                }
                else if ( GetLocalInt( oUser, "dc_recommender" ) <= 3 ){

                    //set target
                    SetLocalObject( oUser, "ds_target", oTarget );

                    //set item
                    SetLocalObject( oUser, "ds_dc_rod", oItem );

                    //set action script
                    SetLocalString( oUser, "ds_action", "ds_dc_actions" );

                    //set check
                    SetLocalInt( oUser, "ds_check_3", 1 );

                    //custom token
                    SetCustomToken( 4102, GetName( oTarget ) );

                    //dialog
                    AssignCommand( oUser, ActionStartConversation( oUser, "ds_dc_recom", TRUE, FALSE ) );
                }
                else{

                    SendMessageToPC( oUser, "You can only make one recommendation between two resets." );
                    return;
                }
            }

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
int GetAccount( object oUser, object oDM ){

    string sPCAccount   = SQLEncodeSpecialChars( GetPCPlayerName( oUser ) );
    int nCoins;

    string sQuery = "SELECT given_player, count( id ) AS account "
                   +"FROM dc_transactions "
                   +"WHERE given_player = '"+sPCAccount+"' "
                   +"AND isnull( taken_by)  "
                   +"GROUP BY given_player ";


    SQLExecDirect( sQuery );

    if( SQLFetch() != SQL_ERROR ){

        //get coin account
        nCoins = StringToInt( SQLGetData( 2 ) );

        //return account name from database to be sure
        SendMessageToPC( oDM,  SQLDecodeSpecialChars( SQLGetData( 1 ) )+" currently has "+IntToString( nCoins )+" coins" );

        //store on PC for further use
        SetLocalInt( oUser, "ds_dc_account", nCoins );
    }

    return nCoins;
}

