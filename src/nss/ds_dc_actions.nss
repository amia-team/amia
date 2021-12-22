//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_dc_actions
//group:   Dream Coin system
//used as: action script
//date:    apr 15 2007
//author:  disco

//-----------------------------------------------------------------------------
// changes
//-----------------------------------------------------------------------------
//2007-05-14    disco   Rewrote the recommendation routines
//2007-05-17    disco   XP compensation for ECL
//2007-12-02    disco   Using inc_ds_records now
//2015-04-25    PoS     Updated DC gold/XP amounts

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "cs_inc_xp"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//get number of coins of oTarget
int GetAccount( object oTarget, object oUser );

//gives oTarget nCoins coins
void GiveCoinsToPlayer( object oTarget, object oUser, int nCoins );

//takes nCoins from oTarget
void TakeCoinsFromPlayer( object oTarget, object oUser, int nCoins );

//get detailed info from oTarget
void GetInfoFromPlayer( object oTarget, object oUser );

//gives players close to oTarget 1 coin
void GiveCoinToNearbyPlayers( object oTarget, object oUser );

//recommends oTarget for good roleplaying
void RecommendPlayer( object oTarget, object oUser );

//store recommendation
void LogRecommendation( object oTarget, object oUser );

//burn a coin for xp and gold
void BurnCoin( object oUser );

//store/delete old Dream Coins
void AddCoinsToPurse( object oUser );

//helper for AddCoinsToPurse()
void StoreDeleteCoin( object oUser, object oItem );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main( ){

    //variables
    object oUser    = OBJECT_SELF;
    object oTarget  = GetLocalObject( oUser, "ds_target" );
    int nNode       = GetLocalInt( oUser, "ds_node" );

    if ( oTarget == OBJECT_INVALID ){

        return;
    }

    switch ( nNode ) {

        //DM gives coins
        case 10: GiveCoinsToPlayer( oTarget, oUser, 1 );    break;
        case 11: GiveCoinsToPlayer( oTarget, oUser, 2 );    break;
        case 12: GiveCoinsToPlayer( oTarget, oUser, 3 );    break;
        case 13: GiveCoinsToPlayer( oTarget, oUser, 5 );    break;
        case 14: GiveCoinsToPlayer( oTarget, oUser, 10 );   break;

        //DM takes coins
        case 20: TakeCoinsFromPlayer( oTarget, oUser, 1 );    break;
        case 21: TakeCoinsFromPlayer( oTarget, oUser, 2 );    break;
        case 22: TakeCoinsFromPlayer( oTarget, oUser, 3 );    break;
        case 23: TakeCoinsFromPlayer( oTarget, oUser, 5 );    break;
        case 24: TakeCoinsFromPlayer( oTarget, oUser, 10 );    break;

        //DM/player requests account info
        case 03: GetInfoFromPlayer( oTarget, oUser );    break;

        //DM gives a coin to players around oTarget
        case 04: GiveCoinToNearbyPlayers( oTarget, oUser );    break;

        //DM gives a coin to a specific player
        case 05: GiveCoinsToPlayer( oTarget, oUser, 1 );     break;

        //player burns a coin for xp and gold
        case 07: BurnCoin( oUser );    break;

        //player recommends other player
        case 08: RecommendPlayer( oTarget, oUser );    break;

        //player cleans up old coins
        case 09: AddCoinsToPurse( oUser );    break;
    }
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------
int GetAccount( object oTarget, object oUser ){

    //variables
    string sPlayer   = SQLEncodeSpecialChars( GetPCPlayerName( oTarget ) );
    int nCoins;

    //SQL
    string sQuery = "SELECT given_player, count( id ) AS account "
                   +"FROM dc_transactions "
                   +"WHERE given_player = '"+sPlayer+"' "
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

void GiveCoinsToPlayer( object oTarget, object oUser, int nCoins ){

    //variables
    string sPC          = SQLEncodeSpecialChars( GetName( oTarget ) );
    string sPlayer      = SQLEncodeSpecialChars( GetPCPlayerName( oTarget ) );
    string sDM          = SQLEncodeSpecialChars( GetPCPlayerName( oUser ) );
    string sArea        = SQLEncodeSpecialChars( GetName( GetArea( oTarget ) ) );
    int nAccount        = GetLocalInt( oTarget, "ds_dc_account" );
    int i;

    //SQL
    string sQuery = "INSERT INTO dc_transactions "
                   +"( id , given_dm , given_player , given_character , given_area , taken_by , insert_at , updated_at )"
                   +" VALUES "
                   +"( NULL , '"+sDM+"', '"+sPlayer+"', '"+sPC+"', '"+sArea+"', NULL ,NOW() , NULL )";

    if ( nCoins > 1 ){

        for ( i=1; i<nCoins; ++i ){

            sQuery = sQuery + ", ( NULL , '"+sDM+"', '"+sPlayer+"', '"+sPC+"', '"+sArea+"', NULL ,NOW() , NULL )";

        }
    }

    SQLExecDirect( sQuery );

    //update local account
    nAccount = nAccount + nCoins;
    SetLocalInt( oTarget, "ds_dc_account", nAccount );
    DelayCommand( 0.1, SetLocalInt( oTarget, "ds_dc_lastdc", GetRunTime() ) );
    DelayCommand( 0.2, SetLocalString( oTarget, "ds_dc_lastdm", GetPCPlayerName( oUser ) ) );

    //feedback
    SendMessageToPC( oTarget, "You have received "+IntToString( nCoins )+" DC." );
    SendMessageToPC( oUser, IntToString( nCoins )+" DC given to "+GetName( oTarget)+"." );

    //remove recommendations
    DeleteLocalInt( oTarget, "dc_recommended" );
    DeleteLocalInt( oTarget, "dc_recomm_time" );
    DeleteLocalString( oTarget, "dc_recomm_pc" );
}

void TakeCoinsFromPlayer( object oTarget, object oUser, int nCoins ){

    //variables
    string sPlayer  = SQLEncodeSpecialChars( GetPCPlayerName( oTarget ) );
    string sDM      = SQLEncodeSpecialChars( GetPCPlayerName( oUser ) );
    int nAccount    = GetLocalInt( oTarget, "ds_dc_account" );

    if ( nCoins > nAccount ){

        nCoins = nAccount;
    }

    //SQL
    string sQuery = "UPDATE  dc_transactions SET taken_by  = '"+sDM+"', updated_at = NOW() "
                   +"WHERE given_player = '"+sPlayer+"' AND isnull( taken_by ) LIMIT "+IntToString( nCoins );

    SQLExecDirect( sQuery );

    //update local account
    nAccount = nAccount-nCoins;
    SetLocalInt( oTarget, "ds_dc_account", nAccount );

    //feedback
    SendMessageToPC( oTarget, IntToString( nCoins )+" DC taken, "+IntToString( nAccount )+" left." );

    if( oTarget != oUser ){

        SendMessageToPC( oUser, IntToString( nCoins )+" DC taken, "+IntToString( nAccount )+" left." );
    }
}

void GetInfoFromPlayer( object oTarget, object oUser ){

    //variables
    string sPlayer   = SQLEncodeSpecialChars( GetPCPlayerName( oTarget ) );
    string sDM;
    int nCoinsLeft;
    int nCoinsUsed;

    //SQL
    string sQuery = "SELECT given_dm, count(given_dm) as given, count(taken_by) as taken FROM dc_transactions "
                   +"WHERE given_player = '"+sPlayer+"' GROUP BY given_dm";


    SQLExecDirect( sQuery );

    while ( SQLFetch() == SQL_SUCCESS ){

        sDM = SQLGetData( 1 );

        if ( sDM == "" ){

            sDM = "Anonymous";
        }

        SendMessageToPC( oUser, "  "+ sDM + ": "+SQLGetData( 2 )+" coins" );

        nCoinsUsed = nCoinsUsed + StringToInt( SQLGetData( 3 ) );
        nCoinsLeft = nCoinsLeft + StringToInt( SQLGetData( 2 ) ) - StringToInt( SQLGetData( 3 ) );
    }

    SendMessageToPC( oUser, "Total used: "+IntToString( nCoinsUsed )+" coins" );
    SendMessageToPC( oUser, "Total left: "+IntToString( nCoinsLeft )+" coins" );

    //store on PC for further use
    SetLocalInt( oTarget, "ds_dc_account", nCoinsLeft );
}

void GiveCoinToNearbyPlayers( object oTarget, object oUser ){

    //variables
    effect eVis     = EffectVisualEffect( VFX_DUR_FREEDOM_OF_MOVEMENT );
    object oObject  = GetFirstObjectInShape( SHAPE_SPHERE, 5.0, GetLocation( oTarget ), TRUE, OBJECT_TYPE_CREATURE );
    int nAccount;
    int nDMstatus;
    float fDelay;

    while( GetIsObjectValid( oObject ) ){

        if( GetIsPC( oObject ) ){

            nDMstatus   = GetDMStatus( GetPCPlayerName( oObject ), GetPCPublicCDKey( oObject ) );

            if ( nDMstatus > 0 ){

                SendMessageToPC( oUser, "Can't award DM: "+GetName( oObject )+"!" );
            }
            else{

                fDelay = fDelay + 0.1;

                //make receiving PCs visible
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oObject, 10.0 );

                //store on PC for further use
                DelayCommand( fDelay, GiveCoinsToPlayer( oObject, oUser, 1 ) );
            }
        }

        oObject = GetNextObjectInShape( SHAPE_SPHERE, 5.0, GetLocation( oTarget ), TRUE, OBJECT_TYPE_CREATURE );
    }
}

void RecommendPlayer( object oTarget, object oUser ){

    //variables
    object oItem       = GetLocalObject( oUser, "ds_dc_rod" );
    string sLastKey    = GetLocalString( oItem, "dc_recommended" );
    int nRecommends    = GetLocalInt( oTarget, "dc_recommended" );

    if ( sLastKey == GetPCPublicCDKey( oTarget ) ){

        SendMessageToPC( oUser, "You cannot recommend the same player twice in a row." );
        return;
    }
    else{

        //block this PC from using the rod again
        SetLocalInt( oUser, "dc_recommender", 1 );

        //set variables on target
        SetLocalInt( oTarget, "dc_recommended", ( nRecommends + 1 ) );
        SetLocalInt( oTarget, "dc_recomm_time", GetRunTime() );
        SetLocalString( oTarget, "dc_recomm_pc", GetName( oUser ) );

        //make sure this guy isn't recommending the same player too often
        SetLocalString( oItem, "dc_recommended", GetPCPublicCDKey( oTarget ) );

        //database the whole bunch
        LogRecommendation( oTarget, oUser );

        //feedback
        SendMessageToPC( oUser, "You recommended "+GetName( oTarget )+" for good roleplay!" );
        SendMessageToAllDMs( GetName( oUser )+" recommended "+GetName( oTarget )+" for good roleplay!" );
    }
}

void LogRecommendation( object oTarget, object oUser ){

    //SQL
    string sQuery = "INSERT INTO dc_recommend  VALUES ( NULL, '"
                    + SQLEncodeSpecialChars( GetPCPlayerName( oTarget ) ) + "', '"
                    + SQLEncodeSpecialChars( GetPCPlayerName( oUser ) ) + "', 1, NOW() )"
                    +" ON DUPLICATE KEY UPDATE count=count+1, update_at=NOW()";

    //execute query
    SQLExecDirect( sQuery );
}

void BurnCoin( object oUser ){

    //variables
    int nAccount    = GetLocalInt( oUser, "ds_dc_account" );

    if ( nAccount > 0 ){

        //variables
        struct _ECL_STATISTICS ecl  = GetECL( oUser );
        int nECL                    = FloatToInt( ecl.fECL );
        int nLevel                  = GetHitDice( oUser );
        int nNextLevel              = GetHitDice( oUser ) + 1;
        int nCurrentXP              = GetXP( oUser );
        int nGold                   = nLevel * 1500;
        int nXP;

        int nXP_Limit = ( 500 * nNextLevel ) * nLevel;

        // Prevent exploits for more XP
        if ( nCurrentXP >= nXP_Limit ) {
            SendMessageToPC( oUser, "Please level-up before using another Dream Coin." );
            return;
        }

        // Full XP to next level granted if <21, half XP if <30, otherwise 0 given
        if ( nECL <= 20 ) {
            nXP = nLevel * 1000;
        } else if ( nECL <= 29 ) {
            nXP = ( nLevel * 1000 ) / 2;
        } else {
            nXP = 0;
        }

        //take a coin
        TakeCoinsFromPlayer( oUser, oUser, 1 );

        //Give gold
        GiveGoldToCreature( oUser, nGold );

        //Give XP if any to give
        if ( nXP > 0 ) {
            GiveExactXP( oUser, nXP, "DC" );
        } else {
            SendMessageToPC( oUser, "Dream Coins do not give XP at maximum level." );
        }

        UpdateModuleVariable( "DCGold", nGold );
    }
    else {
        SendMessageToPC( oUser, "You don't have a single coin to burn." );
    }
}

void AddCoinsToPurse( object oUser ){

    object oItem = GetFirstItemInInventory( oUser );
    float fDelay        = 0.0;

    while ( GetIsObjectValid( oItem ) ) {

        if ( GetTag( oItem ) == "dreamcoin" ) {

            fDelay = fDelay + 0.1;

            DelayCommand( fDelay, StoreDeleteCoin( oUser, oItem ) );
        }

        oItem = GetNextItemInInventory( oUser );
    }

    DelayCommand( 0.5, ExportSingleCharacter( oUser ) );
}

void StoreDeleteCoin( object oUser, object oItem ){

    //double check, we don't want any errors here
    if ( oItem != OBJECT_INVALID && GetTag( oItem ) == "dreamcoin" ){

        //variables
        string sPC          = SQLEncodeSpecialChars( GetName( oUser ) );
        string sPlayer      = SQLEncodeSpecialChars( GetPCPlayerName( oUser ) );
        string sDM          = SQLEncodeSpecialChars( GetLocalString( oItem, "DC_GivenBy" ) );
        string sArea        = "Inventory Cleanup";
        int nAccount        = GetLocalInt( oUser, "ds_dc_account" );

        //SQL
        string sQuery = "INSERT INTO dc_transactions "
                       +"( id , given_dm , given_player , given_character , given_area , taken_by , insert_at , updated_at )"
                       +" VALUES "
                       +"( NULL , '"+sDM+"', '"+sPlayer+"', '"+sPC+"', '"+sArea+"', NULL ,NOW() , NULL )";


        SQLExecDirect( sQuery );

        //update local account
        nAccount = nAccount+1;
        SetLocalInt( oUser, "ds_dc_account", nAccount );

        //feedback
        SendMessageToPC( oUser, "Coin stored. Current account: "+IntToString( nAccount )+" DC." );

        DestroyObject( oItem, 0.2 );
    }
}


