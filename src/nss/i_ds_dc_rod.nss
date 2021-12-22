//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_dc_rod
//group:   Dream Coin system
//used as: DM DC rod activation script
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
#include "aps_include"
#include "amia_include"
#include "inc_ds_records"
#include "inc_nwnx_events"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------

//get number of coins on account
int GetAccount( object oTarget, object oUser );

//fires when you open the jump to convo
void SetSelection( object oUser );

// utility function
void CleanUpVars( object oUser );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_INSTANT:
        case X2_ITEM_EVENT_ACTIVATE:

            if(nEvent==X2_ITEM_EVENT_INSTANT)
                EVENTS_Bypass();

            // item activate variables
            object oUser      = InstantGetItemActivator();
            object oTarget    = InstantGetItemActivatedTarget();
            object oItem      = InstantGetItemActivated();
            location lTarget  = InstantGetItemActivatedTargetLocation();
            int nUserStatus   = GetDMStatus( GetPCPlayerName( oUser ) , GetPCPublicCDKey( oUser, TRUE ) );
            int nTargetStatus = GetDMStatus( GetPCPlayerName( oTarget ) , GetPCPublicCDKey( oTarget, TRUE ) );

            //init checks
            CleanUpVars( oUser );

            //test message
            //SendMessageToPC( oUser, "[debug (line 63): cleaned vars.]" );


            if ( nUserStatus < 1 ) {      //non-DMs shouldn't have DM rods

                SendMessageToAllDMs( GetName( oUser ) + " used the DC Rod but is not a DM!" );
                SendMessageToPC( oUser, "You shouldn't have this item and deserve a spanking!!!" );

                DestroyObject( oItem, 0.5 );

                return;
            }

            //test message
            //SendMessageToPC( oUser, "[debug (line 77): is a DM.]" );

            if ( oUser == oTarget ){      //used on self

                //set customs
                DelayCommand( 0.2, SetSelection( oUser ) );

                //set item
                SetLocalString( oUser, "ds_item", "DCrod" );

                //set action script on second node
                SetLocalString( oUser, "ds_action", "ds_searcher_act2" );

                //set target
                SetLocalObject( oUser, "ds_target", oUser );

                //test message
                //SendMessageToPC( oUser, "[debug (line 94): used on self.]" );

                //start convo
                DelayCommand( 1.0, AssignCommand( oUser, ActionStartConversation( oUser, "ds_dc_jump", TRUE, FALSE ) ) );

                return;
            }
            else if ( nTargetStatus > 0 && nUserStatus != 2 ) {  //only Admins can target other DMs

                SendMessageToPC( oUser, "You are not allowed to modify Dream Coins on other DMs." );
                //SendMessageToPC( oUser, "<c¥  >Test: nUserStatus="+IntToString( nUserStatus)+"</c>" );
                //SendMessageToPC( oUser, "<c¥  >Test: nTargetStatus="+IntToString( nTargetStatus)+"</c>" );

                return;
            }
            else if ( GetIsPC( oTarget ) ){  //used on PC

                //test message
                //SendMessageToPC( oUser, "[debug (line 112): used on PC.]" );

                //continue
            }
            else{   //targeted ground

               //get closest player
               oTarget = GetNearestCreatureToLocation( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, lTarget );

               if ( oTarget != OBJECT_INVALID ){

                    //target is a DM
                    if ( nTargetStatus > 0 ){

                        SendMessageToPC( oUser, "Closest target is a DM." );

                        return;
                    }
                }
                else{

                    SendMessageToPC( oUser, "There is no PC in this area!" );

                    return;
                }
            }

            //set check
            SetLocalInt( oUser, "ds_check_1", 1 );

            //set target
            SetLocalObject( oUser, "ds_target", oTarget );

            //set action script
            SetLocalString( oUser, "ds_action", "ds_dc_actions" );

            //get DC account
            int nAccount = GetAccount( oTarget, oUser );

            //session data
            int nRunTime       = GetLocalInt( oTarget, "ds_dc_lastdc" );

            if ( nRunTime > 0 ){

                int nLastDCTime    = ( GetRunTime() - nRunTime ) / 60;
                SendMessageToPC( oUser, "Last DC given " + IntToString( nLastDCTime ) + " minutes ago by "+ GetLocalString( oTarget, "ds_dc_lastdm" ) + "." );
            }

            //custom token
            SetCustomToken( 4100, GetName( oTarget ) );

            //test message
            //SendMessageToPC( oUser, "[debug (line 164): running convo.]" );

            //dialog
            DelayCommand( 0.5, AssignCommand( oUser, ActionStartConversation( oUser, "ds_dc_rod", TRUE, FALSE ) ) );

        break;
    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
//functions
//-------------------------------------------------------------------------------
int GetAccount( object oTarget, object oUser ){

    string sPCAccount   = SQLEncodeSpecialChars( GetPCPlayerName( oTarget ) );
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
        SendMessageToPC( oUser,  SQLDecodeSpecialChars( SQLGetData( 1 ) )+" currently has "+IntToString( nCoins )+" coins" );

        //store on PC for further use
        SetLocalInt( oTarget, "ds_dc_account", nCoins );
    }

    return nCoins;
}

//fires when you open the convo
void SetSelection( object oUser ){

     int nTotalPCs    = 0;
     int nSelectedPCs = 0;
     int i            = 0;

     //loop through all PCs
     object oOnlinePC = GetFirstPC();

     while ( GetIsObjectValid( oOnlinePC ) == TRUE ){

          nTotalPCs++;

          int nSuggested    = GetLocalInt( oOnlinePC, "dc_recommended" );

          //select correct PCs
          if ( nSuggested > 0 ){

               nSelectedPCs++;

               SetLocalObject( oUser, "ds_pc_"+IntToString( nSelectedPCs ), oOnlinePC );
               SetLocalInt( oUser, "ds_check_"+IntToString( nSelectedPCs ), 1 );
               SetCustomToken( ( 4000 + nSelectedPCs ), GetName( oOnlinePC )+" ("+IntToString( nSuggested )+", "+GetName( GetArea( oOnlinePC ) )+")" );
          }

          oOnlinePC = GetNextPC();
     }

    nSelectedPCs++;

    //clean up unused stored variables
    for ( i = nSelectedPCs; i < 28; ++i ) {

        DeleteLocalObject( oUser, "ds_pc_"+IntToString( i ) );
        DeleteLocalInt( oUser, "ds_check_"+IntToString( i ) );
        SetCustomToken( ( 4000 + i ), "" );
    }
}


//fires when a convo is closed
void CleanUpVars( object oUser ){

    int i = 0;

    DeleteLocalInt( oUser, "ds_action" );
    DeleteLocalInt( oUser, "ds_target" );

    for ( i = 1; i < 31; ++i ) {

        DeleteLocalObject( oUser, "ds_pc_"+IntToString( i ) );
        DeleteLocalObject( oUser, "ds_check_"+IntToString( i ) );
        DeleteLocalInt( oUser, "ds_section_"+IntToString( i ) );
    }
}


