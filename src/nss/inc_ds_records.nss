
//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_ds_records
//group:   database
//used as: library
//date:    aug 21 2007
//author:  disco

// 2008-03-25 : updated to use the module number for dual server
// 2009-01-12 : added deity ring support
// 2009-02-21 : added DeletePCKeyValue
// 2009-08-28 : some optimalisations
// 2009-09-04 : added player count on areas
// 2020-08-15 : removed quest journal functions for now (EE)

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "inc_runtime_api"
#include "cs_inc_xp"
#include "x2_inc_itemprop"
#include "nwnx_time"

//-------------------------------------------------------------------------------
// constants
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//find chaches and chaches them on the module
object CacheCache( string sStorage );
object GetCache( string sStorage );

//caches db data on waypoints in OnModuleLoad
void CacheBannedCDKEY();
void CacheBannedIP();
void CacheDMs();
void CacheDates();
void CacheContraband();
void CacheBindpoints( );
void CacheUpdates();
void CachePatrols();

//refreshes db data on waypoints
void FlushKeyBanCache( );
void FlushIPBanCache( );
void FlushDMCache( );
void FlushContrabandCache( );

//check if a cdkey is banned
int GetIsKeyBanned( string sCDKEY );

//check if an IP address is banned
int GetIsIPBanned( string sIP );

//check if sAccount + sCDKEY belong to a DM
//returns 1 for a DM, and 2 for an Admin
int GetDMStatus( string sAccount, string sCDKEY );

//not used yet
int GetIsBannedItem( object oPC, string sTag );

//checks if a player has indicated he has updated his ha
//use nHasUpdated = TRUE to affirm this
int GetHasUpdated( object oPC, string sCDKEY, int nHasUpdated=FALSE );

//closes open records after a crash
void CloseRecords( object oModule );

//updates player on module entry
void StartPlayerRunTime( object oPC, object oModule );

//placeholder: updates player on area entry
void UpdatePlayerRunTime( object oPC, object oModule );

//this function does the actual work
void DelayedUpdatePlayerRunTime( object oPC, object oModule );

//placeholder: updates player on module exit
void ClosePlayerRunTime( object oPC, object oModule, string sCDKEY );

//this function does the actual work
void DelayedClosePlayerRunTime( string sAccount, string sName, string sGold, object oModule, string sDamage );

//update account/cdkey/ip table
void UpdateIdentities( object oPC );

//records pc on level up
void RecordPC( object oPC );

//strips last part from an IP address
string StripIP( string sIP );

//creates key object on PC
object CreatePCKEY( object oPC );

//caches key object
object CachePCKEY( object oPC, object oKey );

//gets key from cache
object GetPCKEY( object oPC );

//cleans cache
void FlushPCKEY( object oPC, string sKey );

//loads settings from database
void RefreshPCKEY( object oPC, object oKey );

//Same as SetLocalInt on key, but with database backup
void SetPCKEYValue( object oPC, string sVariable, int nValue );

//Same as SetLocalInt on key, but with database check if no value is found
int GetPCKEYValue( object oPC, string sVariable );

//Same as DeleteLocalInt on key, but with database delete as well
void DeletePCKEYValue( object oPC, string sVariable );

//sets journal on entry and checks if unset variables are available
void ImportJournal( object oPC, object oKey );

//used in ImportJournal
void ImportVariable( object oPC, object oKey, string sQuest, int nSetJournal=1 );

//exports journal and brochure variables
void ExportJournal( object oPC, object oKey );

//used in ExportJournal
void ExportVariable( object oPC, object oJournal, object oKey, string sVariable );

//used in ExportJournal
void FinishExport( object oPC, object oKey );

//gets home location of PC
string GetStartWaypoint( object oPC, int nOverrideWithFaction=FALSE );

//translates old 1-8 homes to real bindpoints
int TranslateStartWaypoint( int nHome );

//checks if oPC has nBindpoint available in a porting slot
int HasBindPoint( object oPC, int nBindpoint );

// Updates database on area transition
void db_onTransition( object oPC, object oArea );

// Updates database on shop access
void db_trace_shop( object oPC, object oShop, object oShopkeeper );

//gets (modifier=0) and sets (modifier!=0) reputation. Used in Forrstakkr.
int tha_reputation( object oPC, int nModifier );

//gets (nValue=0) and sets (nValue>0) quest status and sets journal
int ds_quest( object oPC, string sQuest, int nValue=0 );

//This function should only be used in the module heartbeat script!
//It runs the first available execution in the server_commands table
void RunServerCommand();

//used in RunServerCommand();
object GetPCByAccount( string sAccount );

//used in RunServerCommand();
void Messenger();

// Sets player hit points on log in and manages WP jumping
void ResolveLoginStatus( object oPC, object oPCKEY, object oModule );

//jumps to starting location if oPC isn't in the same area
//or deals with porting location
//returns TRUE if oPC is being moved and FALSE if nothing happens
int ResolveTransport( object oPC, object oArea );

//reads DM messages from other server
void InformDMs( string sModule );

//checks cdkey and pckey to see if the player is authorised to play oPC
//returns 1 on success
int AuthorisePC( object oPC, object oPCKEY, string sCDKEY, string sAccount );

//checks if a new PC is added to the right account
//returns 1 on success
int AuthoriseNewPC( object oPC, string sCDKEY, string sAccount, string sIP );

//can go after we changed the portal system
object GetInsigniaB( object oPC );
object GetInsigniaWaypointB( object oPC );

//stores a new deity ring in the DB
void StoreRing( object oRing );

//creates a deity ring in oContainer
//search allows you to input soemthing like "mas" and get a Ring of Mask
//mind that it picks the first available match
void CreateRing( object oContainer, string sSearch="" );

//Imports rules from database and assigns them to custom token 1234
void ImportRules();

//used in ImportRules
void ImportRule( int nCategory, object oRules=OBJECT_INVALID );

//adds all the rule categories to the journal
void AddRulesToJournal( object oPC );

//swaps ~ with ' and ^ with \n
string DecodeSpecialChars( string sString );

//returns the area with resref sResref
//including the area list object makes this function faster
object GetAreaByResRef( string sResRef, object oAreaList=OBJECT_INVALID );

//returns the Nth (starts with 1) area in the module
//including the area list object makes this function faster
object GetNthArea( int n, object oAreaList=OBJECT_INVALID );

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

object CacheCache( string sStorage ){

    object oModule  = GetModule();
    object oStorage = GetWaypointByTag( sStorage );

    if ( !GetIsObjectValid( oStorage ) ){

        log_to_exploits( GetModule(), "Caching Error 1", sStorage );

        return OBJECT_INVALID;
    }
    else{

        SetLocalObject( oModule, sStorage, oStorage );

        return oStorage;
    }
}

object GetCache( string sStorage ){

    object oModule  = GetModule();
    object oStorage = GetLocalObject( oModule, sStorage );

    if ( !GetIsObjectValid( oStorage ) ){

        oStorage = CacheCache( sStorage );

        //log_to_exploits( GetModule(), "Caching Error 2", sStorage );

        if ( !GetIsObjectValid( oStorage ) ){

            log_to_exploits( GetModule(), "Caching Error 3", sStorage );

            return OBJECT_INVALID;
        }
        else{

            SetLocalObject( oModule, sStorage, oStorage );

            return oStorage;
        }
    }
    else{

        return oStorage;
    }
}

void CacheBannedCDKEY(){

    object oStorage     = CacheCache( "ds_cdkey_storage" );

    if ( !GetIsObjectValid( oStorage ) ){

        return;
    }

    string sSQL         = "SELECT cdkey,login FROM banned";
    string sCDKEY       = "";
    int nCounter        = 0;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        sCDKEY = SQLGetData( 1 );

        if ( sCDKEY != "" ){

            ++nCounter;

            SetLocalInt( oStorage, sCDKEY, 1 );
        }
    }

    SetLocalInt( oStorage, "ds_count", nCounter );
    SendMessageToAllDMs( "[" + IntToString( nCounter ) + " banned CDKEYS cached.]" );
}

void CacheBannedIP(){

    object oStorage     = CacheCache( "ds_ip_storage" );

    if ( !GetIsObjectValid( oStorage ) ){

        return;
    }

    string sSQL         = "SELECT ip_range FROM banned_range";
    string sIPRange     = "";
    int nCounter        = 0;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        sIPRange = StripIP( SQLGetData( 1 ) );

        if ( sIPRange != "" ){

            ++nCounter;

            SetLocalInt( oStorage, sIPRange, 1 );
        }
    }

    SetLocalInt( oStorage, "ds_count", nCounter );
    SendMessageToAllDMs( "[" + IntToString( nCounter ) + " banned IP ranges cached.]" );
}

void CacheDMs(){

    object oStorage         = CacheCache( "ds_dm_storage" );

    if ( !GetIsObjectValid( oStorage ) ){

        return;
    }

    string sSQL             = "SELECT account, cdkey, highlevel FROM dm";
    string sKey             = "";
    int nLevel              = 0;
    int nCounter            = 0;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        sKey   = SQLGetData( 1 ) + SQLGetData( 2 );
        nLevel = StringToInt( SQLGetData( 3 ) ) + 1;

        if ( nLevel > 0 ){

            ++nCounter;
            SetLocalInt( oStorage, sKey, nLevel );
        }
    }

    SetLocalInt( oStorage, "ds_count", nCounter );
    SendMessageToAllDMs( "[" + IntToString( nCounter ) + " DM IDs cached.]" );
}

void CacheDates(){

    object oStorage         = GetModule();
    string sSQL             = "SELECT WEEK( NOW() ), YEAR( NOW() )";

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        SetLocalInt( oStorage, "ds_week", StringToInt( SQLGetData( 1 ) ) );
        SetLocalInt( oStorage, "ds_year", StringToInt( SQLGetData( 2 ) ) );
        SetLocalInt( oStorage, "ds_saved", StringToInt( SQLGetData( 3 ) ) );
        SetLocalString( oStorage, "ds_period", SQLGetData( 2 ) + "_" + SQLGetData( 1 ) );
    }

    SetLocalInt( oStorage, "ds_start", GetRunTime() );
}

void CacheContraband(){

    object oStorage     = CacheCache( "ds_item_storage" );

    if ( !GetIsObjectValid( oStorage ) ){

        return;
    }

    string sSQL         = "SELECT tag FROM contraband";
    string sItem        = "";
    int nCounter        = 0;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        sItem = SQLGetData( 1 );

        if ( sItem != "" ){

            ++nCounter;

           SetLocalInt( oStorage, sItem, 1 );
        }
    }

    SetLocalInt( oStorage, "ds_count", nCounter );
    SendMessageToAllDMs( "[" + IntToString( nCounter ) + " banned items cached.]" );
}

void CacheBindpoints(){

    object oStorage     = CacheCache( "ds_bindpoint_storage" );
    int nModule         = GetLocalInt( GetModule(), "Module" );

    if ( !GetIsObjectValid( oStorage ) ){

        return;
    }

    string sSQL         = "SELECT id, title, is_faction, module, item_resref FROM bindpoints WHERE module != -1";
    int nCounter        = 0;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        string sBindpoint = "b_"+SQLGetData( 1 );

        if ( SQLGetData( 3 ) == "1" ){

            ++nCounter;

            //mark bindpoint as faction
            SetLocalString( oStorage, "f_" + IntToString( nCounter ), sBindpoint );

            //faction key
            if ( SQLGetData( 5 ) != "" ){

                SetLocalString( oStorage, "i_"+SQLGetData( 1 ), SQLGetData( 5 ) );
            }
        }

        SetLocalString( oStorage, sBindpoint, SQLDecodeSpecialChars( SQLGetData( 2 ) ) );

        if ( nModule == StringToInt( SQLGetData( 4 ) ) || StringToInt( SQLGetData( 4 ) ) == 3 ){

            SetLocalObject( oStorage, sBindpoint, GetWaypointByTag( sBindpoint ) );
        }
    }

    SetLocalInt( oStorage, "ds_count", nCounter );
    SendMessageToAllDMs( "[" + IntToString( nCounter ) + " faction bindpoints cached.]" );
}

void CacheUpdates(){

    object oStorage     = CacheCache( "ds_update_storage" );
    string sVersion     = GetLocalString( GetModule(), "hak" );

    if ( !GetIsObjectValid( oStorage ) ){

        return;
    }

    //clean up old records on an update
    string sSQL         = "DELETE FROM hak_update WHERE version != "+sVersion;
    int nCounter        = 0;

    SQLExecDirect( sSQL );

    //cache people who have indicated not to be warned again this round
    sSQL         = "SELECT cdkey FROM hak_update";

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        //mark bindpoint as faction
        SetLocalInt( oStorage, SQLGetData( 1 ), 1 );
    }
}

void CachePatrols(){

    object oStorage     = CacheCache( "ds_patrol_storage" );
    int nModule         = GetLocalInt( GetModule(), "Module" );

    if ( !GetIsObjectValid( oStorage ) ){

        return;
    }


    //cache patrol areas
    string sSQL         = "SELECT resref, patrol_tag FROM area_patrol WHERE module ="+IntToString( nModule );
    int nTriggers;

    SQLExecDirect( sSQL );

    while( SQLFetch( ) == SQL_SUCCESS ){

        //mark bindpoint as faction
        SetLocalString( oStorage, SQLGetData( 1 ), SQLGetData( 2 ) );
    }
}

void FlushKeyBanCache( ){

    object oStorage     = GetCache( "ds_cdkey_storage" );
    location lStorage   = GetLocation( oStorage );

    DestroyObject( oStorage );

    CreateObject( OBJECT_TYPE_WAYPOINT, "ds_storage", lStorage, FALSE, "ds_cdkey_storage" );

    DelayCommand( 1.3, CacheBannedCDKEY() );
}

void FlushIPBanCache( ){

    object oStorage     = GetCache( "ds_ip_storage" );
    location lStorage   = GetLocation( oStorage );

    DestroyObject( oStorage );

    CreateObject( OBJECT_TYPE_WAYPOINT, "ds_storage", lStorage, FALSE, "ds_ip_storage" );

    DelayCommand( 1.3, CacheBannedIP() );
}

void FlushDMCache( ){

    object oStorage     = GetCache( "ds_dm_storage" );
    location lStorage   = GetLocation( oStorage );

    DestroyObject( oStorage );

    CreateObject( OBJECT_TYPE_WAYPOINT, "ds_storage", lStorage, FALSE, "ds_dm_storage" );

    DelayCommand( 1.3, CacheDMs() );
}

void FlushContrabandCache( ){

    object oStorage     = GetCache( "ds_item_storage" );
    location lStorage   = GetLocation( oStorage );

    DestroyObject( oStorage );

    CreateObject( OBJECT_TYPE_WAYPOINT, "ds_storage", lStorage, FALSE, "ds_item_storage" );

    DelayCommand( 1.3, CacheContraband() );
}

int GetIsKeyBanned( string sCDKEY ){

    object oStorage  = GetCache( "ds_cdkey_storage" );
    int nCount       = GetLocalInt( oStorage, "ds_count" );

    if ( !GetIsObjectValid( oStorage ) ){

        //no cache found, switch to database queries
        nCount = -1;
    }

    if ( nCount == -1 ){

        string sSQL = "SELECT cdkey FROM banned where cdkey = '" + sCDKEY + "'";

        SQLExecDirect( sSQL );

        if ( SQLFetch( ) == SQL_SUCCESS ){

            return TRUE;
        }
    }
    else if ( GetLocalInt( oStorage, sCDKEY ) == 1 ){

        return TRUE;
    }

    return FALSE;
}

int GetIsIPBanned( string sIP ){

    object oStorage  = GetCache( "ds_ip_storage" );
    int nCount       = GetLocalInt( oStorage, "ds_count" );

    if ( !GetIsObjectValid( oStorage ) ){

        //no cache found, switch to database queries
        nCount = -1;
    }

    if ( nCount == -1 ){

        string sSQL = "SELECT ip_range FROM banned_range";

        SQLExecDirect( sSQL );

        while( SQLFetch( ) == SQL_SUCCESS ){

            string sIPRange    = SQLGetData( 1 );

            if( StripIP( sIPRange ) == StripIP( sIP ) ){

                return( TRUE );
            }
        }
    }
    else if ( GetLocalInt( oStorage, StripIP( sIP ) ) == 1 ){

        return TRUE;
    }

    return FALSE;
}

int GetDMStatus( string sAccount, string sCDKEY ){

    object oStorage = GetCache( "ds_dm_storage" );
    int nCount      = GetLocalInt( oStorage, "ds_count" );
    sAccount        = SQLEncodeSpecialChars( sAccount );

    if ( !GetIsObjectValid( oStorage ) ){

        //no cache found, switch to database queries
        nCount = -1;
    }

    if ( nCount == -1 ){

        string sSQL = "SELECT highlevel FROM dm WHERE account='" + sAccount + "' AND cdkey='" + sCDKEY + "'";

        SQLExecDirect( sSQL );

        if ( SQLFetch( ) == SQL_SUCCESS ){

            return StringToInt( SQLGetData( 1 ) ) + 1;
        }
    }
    else {

        string sKey     = sAccount + sCDKEY;

        return GetLocalInt( oStorage, sKey );
    }

    return 0;
}

int GetIsBannedItem( object oPC, string sTag ){

    if ( !GetIsPC( oPC ) ){

        return 0;
    }

    object oStorage  = GetCache( "ds_item_storage" );
    int nCount       = GetLocalInt( oStorage, "ds_count" );
    string sSQL      = "";

    if ( nCount == -1 ){

        sSQL = "SELECT tag FROM contraband where tag = '" + sTag + "'";

        SQLExecDirect( sSQL );

        if ( SQLFetch( ) == SQL_SUCCESS ){

            if ( SQLGetData( 1 ) == sTag ){

                return TRUE;
            }
        }
    }
    else if ( GetLocalInt( oStorage, sTag ) == 1 ){

        return TRUE;
    }

    return FALSE;
}

int GetHasUpdated( object oPC, string sCDKEY, int nHasUpdated=FALSE ){

    if ( !GetIsPC( oPC ) ){

        return 0;
    }

    if ( GetLocalInt( oPC, "hak" ) != 1 ){

        SetLocalInt( oPC, "hak", 1 );
    }
    else if ( nHasUpdated != TRUE ){

        return TRUE;
    }

    object oStorage  = GetCache( "ds_update_storage" );

    if ( GetLocalInt( oStorage, sCDKEY ) == 1 ){

        return TRUE;
    }

    if ( nHasUpdated ){

        SQLExecDirect( "INSERT INTO hak_update VALUES ('"+sCDKEY+"', '"+GetLocalString( GetModule(), "hak" )+"' )" );

        SetLocalInt( oStorage, sCDKEY, 1 );
    }

    return FALSE;
}

void CloseRecords( object oModule ){

    int nState = GetLocalInt( oModule, "Module" );

    if ( !nState ){

        nState = 1;
    }

    string sSQL = "UPDATE player_runtime SET state=0, area='' WHERE state="+IntToString( nState );

    SQLExecDirect( sSQL );
}

void StartPlayerRunTime( object oPC, object oModule ){

    //database variables
    string sAccount    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sCDKEY      = GetPCPublicCDKey( oPC, TRUE );
    string sName       = SQLEncodeSpecialChars( GetName( oPC ) );
    string sPeriod     = GetLocalString( oModule, "ds_period" );
    string sArea       = SQLEncodeSpecialChars( GetName( GetArea( oPC ) ) );
    string sGold       = IntToString( GetGold( oPC ) );
    int nState         = GetLocalInt( oModule, "Module" );
    string sDamage     = IntToString( GetMaxHitPoints( oPC ) - GetCurrentHitPoints( oPC ) );

    if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - inc_ds_records 749: StartPlayerRunTime has started..." );

    if ( !nState ){

        nState = 1;
    }

    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

        //this pools a DM's logins under one name
        sName       = "DM Avatar";
    }

    //make a new record once a week or
    //update the login status (there won't be a lot of login time)
    string sSQL = "INSERT INTO player_runtime VALUES "+
                  "('"+sAccount+"', '"+sName+"', '"+sPeriod+"', "+IntToString(nState)+", "+sDamage+", 0, 1, '"+sArea+"', '"+sGold+"', NOW() )"+
                  "ON DUPLICATE KEY UPDATE state="+IntToString(nState)+", area='"+sArea+"', gold="+sGold;

    if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - inc_ds_records 768: Checking logins are only set once..." );
    //make sure logins are only set on client entry and once a session
    if ( GetLocalString( oPC, "ds_account" ) == "" ){

        sSQL = sSQL + ",logins=logins+1";
        DelayCommand( 0.3, UpdateIdentities( oPC ) );
    }

    if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - inc_ds_records 776: Executing SQL..." );
    SQLExecDirect( sSQL );
    if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - inc_ds_records 778: Done executing SQL!" );

    //change to ds_cdkey
    SetLocalString( oPC, "ds_cdkey", sCDKEY );
    SetLocalString( oPC, "ds_account", SQLEncodeSpecialChars( sAccount ) );
    if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - inc_ds_records 783: StartPlayerRunTime has finished!" );
}

void UpdatePlayerRunTime( object oPC, object oModule ){

    DelayCommand( 1.0, DelayedUpdatePlayerRunTime( oPC, oModule ) );
}

void DelayedUpdatePlayerRunTime( object oPC, object oModule ){

    //database variables
    string sAccount    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sName       = SQLEncodeSpecialChars( GetName( oPC ) );
    string sPeriod     = GetLocalString( oModule, "ds_period" );
    string sArea       = SQLEncodeSpecialChars( GetName( GetArea( oPC ) ) );
    string sGold       = IntToString( GetGold( oPC ) );
    int nState         = GetLocalInt( oModule, "Module" );
    string sDamage     = IntToString( GetMaxHitPoints( oPC ) - GetCurrentHitPoints( oPC ) );

    if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - inc_ds_records 802: DelayedUpdatePlayerRunTime has started..." );

    if ( !nState ){

        nState = 1;
    }

    if ( GetIsPossessedFamiliar( oPC ) ){

        sName = SQLEncodeSpecialChars( GetName( GetMaster( oPC ) ) );
    }

    if ( GetIsDM( oPC )  || GetIsDMPossessed( oPC ) ){

        //this pools a DM's logins under one name
        sName       = "DM Avatar";
    }

    string sSQL = "UPDATE player_runtime "+
                  "SET runtime = ( runtime + TIME_TO_SEC( TIMEDIFF( NOW( ) , updated_at ) ) ), damage="+sDamage+", area='"+sArea+"', gold="+sGold+" "+
                  "WHERE account='"+sAccount+"' AND pc='"+sName+"' AND period='"+sPeriod+"' AND state="+IntToString(nState)+" "+
                  "LIMIT 1";

    SQLExecDirect( sSQL );

     if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - inc_ds_records 827: DelayedUpdatePlayerRunTime has finished!" );
}

void ClosePlayerRunTime( object oPC, object oModule, string sCDKEY ){

    //database variables
    string sAccount    = GetLocalString( oPC, "ds_account" );
    string sName       = SQLEncodeSpecialChars( GetName( oPC ) );
    string sGold       = IntToString( GetGold( oPC ) );
    string sDamage     = IntToString( GetMaxHitPoints( oPC ) - GetCurrentHitPoints( oPC ) );
    string sPCKEY      = GetName( GetPCKEY( oPC ) );
    string sSessionid  = GetLocalString( oModule, "sessionid" );
    string sTarget     = GetLocalString( oPC, "p_target" );
    string sGold2      = IntToString( GetLocalInt( oPC, "p_gold" ) );
    string sSQL;

    if ( GetIsDM( oPC )  || GetIsDMPossessed( oPC ) ){

        sName       = "DM Avatar";

        sSQL = "INSERT INTO player_exit VALUES "+
               "( NULL, '"+sCDKEY+"', '"+sSessionid+"', '"+sTarget+"', 0, 0, NOW() ) "+
               "ON DUPLICATE KEY UPDATE session_id='"+sSessionid+"', target='"+sTarget+"'";

        SQLExecDirect( sSQL );
    }
    else if ( sPCKEY != "" ){


        if ( sDamage == "" ){

            sDamage = "0";
        }

        if ( sGold2 == "" ){

            sGold2 = "0";
        }


        sSQL = "INSERT INTO player_exit VALUES "+
               "( NULL, '"+sPCKEY+"', '"+sSessionid+"', '"+sTarget+"', "+sGold2+", "+sDamage+", NOW() ) "+
               "ON DUPLICATE KEY UPDATE session_id='"+sSessionid+"', target='"+sTarget+"', gold="+sGold2+", damage="+sDamage;

        SQLExecDirect( sSQL );
    }

    DelayCommand( 0.0, DelayedClosePlayerRunTime( sAccount, sName, sGold, oModule, sDamage ) );
}

void DelayedClosePlayerRunTime( string sAccount, string sName, string sGold, object oModule, string sDamage ){

    string sPeriod = GetLocalString( oModule, "ds_period" );
    string sState  = IntToString( GetLocalInt( oModule, "Module" ) );

    string sSQL = "UPDATE player_runtime "+
                  "SET runtime = ( runtime + TIME_TO_SEC( TIMEDIFF( NOW( ) , updated_at ) ) ), state=0, damage="+sDamage+", area='', gold= "+sGold+" "+
                  "WHERE account='"+sAccount+"' AND pc='"+sName+"' AND period='"+sPeriod+"' AND state="+sState+" "+
                  "LIMIT 1";

    SQLExecDirect( sSQL );
}


void UpdateIdentities( object oPC ){

    //database variables
    string sAccount    = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sCDKEY      = GetPCPublicCDKey( oPC );
    string sIP         = GetPCIPAddress( oPC );

    string sSQL = "INSERT INTO player_identity VALUES "+
                  "('"+sAccount+"', '"+sCDKEY+"', '"+sIP+"', 1, NOW() )"+
                  "ON DUPLICATE KEY UPDATE logins=logins+1";

    SQLExecDirect( sSQL );
}

void RecordPC( object oPC ){

    string sAccount         = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sPC              = SQLEncodeSpecialChars( GetName( oPC ) );
    string sCDKEY           = GetPCPublicCDKey( oPC );
    string sIP              = GetPCIPAddress( oPC );
    string sHP              = IntToString( GetMaxHitPoints( oPC ) );
    string sRace            = IntToString( GetRaceInteger( GetRacialType( oPC ), GetSubRace( oPC ) ) );
    string sDeity           = SQLEncodeSpecialChars( GetDeity( oPC ) );
    string sGoodEvil        = IntToString( GetGoodEvilValue( oPC ) );
    string sLawChaos        = IntToString( GetLawChaosValue( oPC ) );

    string sAbilities       = IntToString( GetAbilityScore( oPC, ABILITY_STRENGTH, TRUE ) )+","
                            + IntToString( GetAbilityScore( oPC, ABILITY_DEXTERITY, TRUE ) )+","
                            + IntToString( GetAbilityScore( oPC, ABILITY_CONSTITUTION, TRUE ) )+","
                            + IntToString( GetAbilityScore( oPC, ABILITY_INTELLIGENCE, TRUE ) )+","
                            + IntToString( GetAbilityScore( oPC, ABILITY_WISDOM, TRUE ) )+","
                            + IntToString( GetAbilityScore( oPC, ABILITY_CHARISMA, TRUE ) );

    string sClasses         = IntToString( GetClassByPosition( 1, oPC ) )+"_"
                            + IntToString( GetLevelByPosition( 1, oPC ) )+","
                            + IntToString( GetClassByPosition( 2, oPC ) )+"_"
                            + IntToString( GetLevelByPosition( 2, oPC ) )+","
                            + IntToString( GetClassByPosition( 3, oPC ) )+"_"
                            + IntToString( GetLevelByPosition( 3, oPC ) );

    int i;
    int nRank;
    string sSkills;

    for ( i=0; i<27; ++i ){

        nRank = GetSkillRank( i, oPC, TRUE );

        if ( nRank > 0 ){

            sSkills = sSkills + IntToString( i ) + "_" + IntToString( nRank ) + ",";
        }
    }

    string sFeats;

    for ( i=0; i<1210; ++i ){

        if ( GetHasFeat( i, oPC ) ){

            sFeats = sFeats + IntToString( i ) + ",";
        }
    }

    string sQuery           = "INSERT INTO player_levelup VALUES ( '"
                            + sAccount + "', '"
                            + sPC + "', '"
                            + sCDKEY + "', '"
                            + sIP + "', "
                            + sHP + ", "
                            + sRace + ", '"
                            + sDeity + "', "
                            + sGoodEvil + ", "
                            + sLawChaos + ", '"
                            + sAbilities + "', '"
                            + sClasses + "', '"
                            + sSkills + "', '"
                            + sFeats + "', "
                            + "NOW() )";

    //run queries with delay
    SQLExecDirect( sQuery );
}

string StripIP( string sIP ){

    int i;
    int nStart;
    string sResult = sIP;

    for ( i=0; i<3; ++i ){

        sResult = GetSubString( sResult, ( FindSubString( sResult, "." ) + 1 ), GetStringLength( sResult ) );
    }

    return GetStringLeft( sIP, ( GetStringLength( sIP ) - GetStringLength( sResult ) -1 ) );
}

object CreatePCKEY( object oPC ){

    object oKey = GetItemPossessedBy( oPC, "ds_pckey" );

    if ( GetIsObjectValid( oKey ) ){

        SendMessageToPC( oPC, "You already have a key. Using this one instead of creating a new key." );
        return CachePCKEY( oPC, oKey );
    }

    string sQuery = "SELECT CEIL(UTC_TIMESTAMP())";
    string sKey;

    sKey = GetPCPublicCDKey( oPC ) + "_" + GetRandomUUID();

    oKey = CreateItemOnObject( "ds_pckey", oPC );

    SetName( oKey, sKey );

    if ( GetName( oKey ) == sKey ){

        //ExportJournal( oPC, oKey );
        return CachePCKEY(  oPC, oKey );
    }
    else{

        return OBJECT_INVALID;
    }
}

object CachePCKEY( object oPC, object oKey ){

    string sPCKEY = GetLocalString( oPC, "pckey" );

    if ( GetName( oKey ) == sPCKEY && sPCKEY != "" ){


        //SendMessageToPC( oPC, "[PCKEY "+sPCKEY+" is already cached]" );

        return oKey;
    }

    return GetPCKEY( oPC );
}


object GetPCKEY( object oPC ){

    object oStorage = GetCache( "ds_pckey_storage" );
    object oPCKEY;
    string sPCKEY = GetLocalString( oPC, "pckey" );

    if ( sPCKEY == "" ){

        //hasn't logged in this reset
        oPCKEY = GetItemPossessedBy( oPC, "ds_pckey" );

        if ( GetIsObjectValid( oPCKEY ) ){

            //store key
            sPCKEY = GetName( oPCKEY );

            //SendMessageToPC( oPC, "[Caching PCKEY "+sPCKEY+"]" );

            SetLocalObject( oStorage, sPCKEY, oPCKEY );
            SetLocalString( oPC, "pckey", sPCKEY );
        }

        return oPCKEY;
    }
    else{

        //retrieve key
        oPCKEY = GetLocalObject( oStorage, sPCKEY );

        //check
        if ( sPCKEY == GetName( oPCKEY ) ){

            //SendMessageToPC( oPC, "[Loading PCKEY "+sPCKEY+" from cache]" );
            return oPCKEY;
        }
        else{

            //hasn't logged in this reset
            oPCKEY = GetItemPossessedBy( oPC, "ds_pckey" );

            if ( GetIsObjectValid( oPCKEY ) ){

                //store key
                sPCKEY = GetName( oPCKEY );

                //SendMessageToPC( oPC, "Recaching PCKEY "+sPCKEY+"]" );

                SetLocalObject( oStorage, sPCKEY, oPCKEY );
                SetLocalString( oPC, "pckey", sPCKEY );
            }

            return oPCKEY;
        }
    }

    return OBJECT_INVALID;
}


void FlushPCKEY( object oPC, string sKey ){

    object oStorage = GetCache( "ds_pckey_storage" );

    SendMessageToPC( oPC, "[" + sKey + " flushed from cache]" );

    DeleteLocalObject( oStorage, sKey );

    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

        SetLocalInt( oPC, "ds_done", 0 );
    }
}

//loads settings from database
void RefreshPCKEY( object oPC, object oKey ){

    string sQuery = "SELECT variable, value FROM player_journal WHERE pckey ='"+GetName( oKey )+"'";

    //execute retrieval
    SQLExecDirect( sQuery );

    //loop through commands
    while( SQLFetch( ) == SQL_SUCCESS ){

        SetLocalInt( oKey, SQLGetData(1), StringToInt( SQLGetData(2) ) );
        SendMessageToPC( oPC, SQLGetData(1)+" set to "+SQLGetData(2) );
    }
}


void SetPCKEYValue( object oPC, string sVariable, int nValue ){

    //dms won't work for various reasons
    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

        SetLocalInt( oPC, sVariable, nValue );
        return;
    }

    //I store the reference to the key in a module wide cache
    //this makes it possible to reach it from a polied character
    object oKey = GetPCKEY( oPC );

    //check if key item is cached
    if ( GetIsObjectValid( oKey ) == FALSE ){

        //SendMessageToPC( oPC, "[Can't find PCKEY!]" );
        return;
    }

    //backup value in database
    string sQuery = "INSERT INTO player_journal VALUES ( '"
                    +GetName( oKey )+"', '"
                    +sVariable+"', "+IntToString( nValue )+", NOW() ) "
                    +"ON DUPLICATE KEY UPDATE value="+IntToString( nValue );

    //execute query
    SQLExecDirect( sQuery );

    //store on Key for faster access
    SetLocalInt( oKey, sVariable, nValue );

    //feedback
    //SendMessageToPC( oPC, sVariable + " set to: " + IntToString( nValue ) );
}

int GetPCKEYValue( object oPC, string sVariable ){

    //dms won't work for various reasons
    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

        return GetLocalInt( oPC, sVariable );
    }

    if ( GetIsPossessedFamiliar( oPC ) ){

        oPC = GetMaster( oPC );
    }

    //I store the reference to the key in a module wide cache
    //this makes it possible to reach it from a polied character
    object oStorage = GetCache( "ds_pckey_storage" );
    string sCDKEY   = GetPCPublicCDKey( oPC );
    string sKey;
    int nValue;
    object oKey = GetPCKEY( oPC );

    //check if key item is cached
    if ( GetIsObjectValid( oKey ) == FALSE ){

        //SendMessageToPC( oPC, "[Can't find PCKEY!]" );
        return 0;
    }

    //get requested value from PC
    nValue = GetLocalInt( oKey, sVariable );

    if ( nValue == -1 ){

        //previously marked as 'unset'.
        return 0;
    }
    else if ( nValue == 0 ){

        //unset, but not checked from database
        string sQuery = "SELECT value FROM player_journal WHERE pckey = '"+GetName( oKey )+"' AND variable = '"+sVariable+"'";

        //execute query
        SQLExecDirect( sQuery );

        if ( SQLFetch() == SQL_SUCCESS ) {

            nValue = StringToInt( SQLGetData( 1 ) );
        }

        //SendMessageToPC( oPC, sVariable + " is: " + IntToString( nValue ) );

        if ( nValue == 0 ){

            //store on Key for faster access ( -1 means 'not set' )
            SetLocalInt( oKey, sVariable, -1 );

            //return 0 as if the local var wasn't set
            return 0;
        }
        else{

            //store on Key for faster access
            SetLocalInt( oKey, sVariable, nValue );

            //return value as if local int
            return nValue;
        }
    }
    else {

        //variable was already stored on item
        return nValue;
    }
}

//Same as DeleteLocalInt on key, but with database delete as well
void DeletePCKEYValue( object oPC, string sVariable ){

    //dms won't work for various reasons
    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

        DeleteLocalInt( oPC, sVariable );

        return;
    }

    if ( GetIsPossessedFamiliar( oPC ) ){

        oPC = GetMaster( oPC );
    }

    //I store the reference to the key in a module wide cache
    //this makes it possible to reach it from a polied character
    object oStorage = GetCache( "ds_pckey_storage" );
    string sCDKEY   = GetPCPublicCDKey( oPC );
    string sKey;
    int nValue;
    object oKey = GetPCKEY( oPC );

    //check if key item is cached
    if ( GetIsObjectValid( oKey ) == FALSE ){

        return;
    }

    //get requested value from PC
    DeleteLocalInt( oKey, sVariable );

    string sQuery = "DELETE FROM player_journal WHERE pckey = '"+GetName( oKey )+"' AND variable = '"+sVariable+"' LIMIT 1";

    //execute query
    SQLExecDirect( sQuery );
}

void ImportJournal( object oPC, object oKey ){

    float fDelay        = 0.0;

    if ( !GetIsObjectValid( oKey ) ){

        return;
    }

    ImportVariable( oPC, oKey, "ds_subrace_activated", 0 );
    ImportVariable( oPC, oKey, "AR_BardQuest2", 0 );
    ImportVariable( oPC, oKey, "subrace_authorized", 0 );
    ImportVariable( oPC, oKey, "HasRespawned", 0 );
    ImportVariable( oPC, oKey, "QST_ChosenOrc" );
    ImportVariable( oPC, oKey, "QST_WifeSpirit" );
    ImportVariable( oPC, oKey, "QST_BlindBeggar" );
    ImportVariable( oPC, oKey, "QST_ManorBook" );
    ImportVariable( oPC, oKey, "tha_traders" );
    ImportVariable( oPC, oKey, "tha_quest1" );
    ImportVariable( oPC, oKey, "tha_quest2" );
    ImportVariable( oPC, oKey, "tha_quest3" );
    ImportVariable( oPC, oKey, "tha_quest4" );
    ImportVariable( oPC, oKey, "tha_quest5" );
    ImportVariable( oPC, oKey, "tha_quest6" );
    ImportVariable( oPC, oKey, "tha_quest7" );
    ImportVariable( oPC, oKey, "tha_quest8" );
    ImportVariable( oPC, oKey, "ds_quest_1" );
    ImportVariable( oPC, oKey, "ds_quest_2" );
    ImportVariable( oPC, oKey, "ds_quest_3" );
    ImportVariable( oPC, oKey, "ds_quest_4" );
    ImportVariable( oPC, oKey, "ds_quest_6" );
    ImportVariable( oPC, oKey, "ds_quest_7" );
    ImportVariable( oPC, oKey, "ds_quest_9" );
    ImportVariable( oPC, oKey, "ds_quest_10" );
    ImportVariable( oPC, oKey, "ds_quest_11" );
    ImportVariable( oPC, oKey, "ds_quest_12" );
    ImportVariable( oPC, oKey, "ds_quest_13" );
    ImportVariable( oPC, oKey, "ds_quest_14" );
    ImportVariable( oPC, oKey, "ds_quest_15" );
    ImportVariable( oPC, oKey, "ds_quest_16" );
    ImportVariable( oPC, oKey, "ds_quest_17" );
    ImportVariable( oPC, oKey, "ds_quest_18" );
    ImportVariable( oPC, oKey, "ds_quest_19" );
    ImportVariable( oPC, oKey, "ds_quest_20" );
    ImportVariable( oPC, oKey, "ds_quest_21" );
    ImportVariable( oPC, oKey, "ds_quest_22" );
    ImportVariable( oPC, oKey, "ds_quest_23" );
    ImportVariable( oPC, oKey, "ds_quest_24" );
    ImportVariable( oPC, oKey, "ds_quest_25" );
    ImportVariable( oPC, oKey, "ds_quest_26" );
    ImportVariable( oPC, oKey, "ds_quest_27" );
    ImportVariable( oPC, oKey, "ds_quest_28" );
    ImportVariable( oPC, oKey, "ds_quest_29" );
    ImportVariable( oPC, oKey, "ds_quest_30" );
    ImportVariable( oPC, oKey, "ds_quest_31" );
    ImportVariable( oPC, oKey, "ds_quest_32" );
    ImportVariable( oPC, oKey, "ds_quest_33" );
    ImportVariable( oPC, oKey, "ds_quest_34" );
    ImportVariable( oPC, oKey, "ds_quest_35" );
    ImportVariable( oPC, oKey, "BlindBeggar" );
    ImportVariable( oPC, oKey, "qst_gloura" );
    ImportVariable( oPC, oKey, "qst_ankhremun" );
    ImportVariable( oPC, oKey, "cs_panthalo_done", 0 );
    ImportVariable( oPC, oKey, "drow_starter_quest" );
    ImportVariable( oPC, oKey, "bp_1", 0 );
    ImportVariable( oPC, oKey, "bp_2", 0 );
    ImportVariable( oPC, oKey, "bp_3", 0 );
    ImportVariable( oPC, oKey, "bp_4", 0 );
    ImportVariable( oPC, oKey, "bp_5", 0 );
    ImportVariable( oPC, oKey, "bp_6", 0 );
    ImportVariable( oPC, oKey, "bp_7", 0 );
    ImportVariable( oPC, oKey, "bp_8", 0 );
    ImportVariable( oPC, oKey, "bp_9", 0 );
    ImportVariable( oPC, oKey, "bp_10", 0 );
    ImportVariable( oPC, oKey, "tha_reputation", 0 );
    ImportVariable( oPC, oKey, "cs_bgd_booster", 0 );
    ImportVariable( oPC, oKey, "bc_fortune", 0 );
    ImportVariable( oPC, oKey, "bc_luis", 0 );
    ImportVariable( oPC, oKey, "AR_BardQuest1", 0 );
    //New, properly set up quests
    ImportVariable( oPC, oKey, "ds_quest_36" );
    ImportVariable( oPC, oKey, "ds_quest_37" );
    ImportVariable( oPC, oKey, "ds_quest_38" );
    ImportVariable( oPC, oKey, "ds_quest_39" );
    ImportVariable( oPC, oKey, "ds_quest_40" );
    ImportVariable( oPC, oKey, "ds_quest_41" );
    ImportVariable( oPC, oKey, "ds_quest_42" );
    ImportVariable( oPC, oKey, "ds_quest_50" );
    ImportVariable( oPC, oKey, "ds_quest_98" );
    ImportVariable( oPC, oKey, "ds_quest_99" );
    ImportVariable( oPC, oKey, "ds_quest_200" );
}

void ImportVariable( object oPC, object oKey, string sQuest, int nSetJournal=1 ){

    if ( !GetIsObjectValid( oPC ) ){

        return;
    }

    //get requested value from PC
    int nValue = GetLocalInt( oKey, sQuest );

    //mind that a locally stored value of -1 means that this is was checked before and found to be 0
    if ( nValue > 0 ){

        //SendMessageToPC( oPC, "key " + sQuest + ": " + IntToString( nValue ) );

        if ( nSetJournal == 1 ){

            //add to Journal
            AddJournalQuestEntry( sQuest, nValue, oPC, FALSE, FALSE, TRUE );
        }
    }
    else if ( nValue == 0 && ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ) ){

        //unset, but not checked from database
        string sQuery = "SELECT value FROM player_journal WHERE pckey = '"+GetName( oKey )+"' AND variable = '"+sQuest+"'";

        //execute query
        SQLExecDirect( sQuery );

        if ( SQLFetch() == SQL_SUCCESS ) {

            nValue = StringToInt( SQLGetData( 1 ) );
        }

        //SendMessageToPC( oPC, "db " + sQuest + ": " + IntToString( nValue ) );

        if ( nValue == 0 ){

            //store on Key for faster access ( -1 means 'not set' )
            SetLocalInt( oKey, sQuest, -1 );
        }
        else{

            //store on Key for faster access
            SetLocalInt( oKey, sQuest, nValue );

            if ( nSetJournal == 1 ){

                //add to Journal
                AddJournalQuestEntry( sQuest, nValue, oPC, FALSE, FALSE, FALSE );
            }
        }
    }
}

void ExportJournal( object oPC, object oKey ){

    object oJournal     = GetLocalObject( oPC, "MyJournal" );
    object oBrochure    = GetItemPossessedBy( oPC, "tha_brochure" );
    float fDelay        = 0.0;

    if ( !GetIsObjectValid( oKey ) ){

        return;
    }

    if ( GetIsObjectValid( oJournal ) ){

        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "ds_subrace_activated" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "AR_BardQuest2" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "PCPort_1" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "PCPort_2" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "PCPort_3" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "PCPort_4" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "PCPort_5" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "PCPort_6" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "subrace_authorized" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "HasRespawned" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "QST_ChosenOrc" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "QST_WifeSpirit" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "QST_MainTemple" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "QST_BlindBeggar" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "QST_ManorBook" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "ds_quest_1" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "ds_quest_2" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "ds_quest_3" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "ds_quest_4" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "BlindBeggar" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "qst_gloura" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "qst_ankhremun" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "cs_panthalo_done" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "drow_starter_quest" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "cs_bgd_booster" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "bc_fortune" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "bc_luis" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oJournal, oKey, "AR_BardQuest1" ) );
    }

    if ( GetIsObjectValid( oBrochure ) ){

        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oBrochure, oKey, "tha_traders" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oBrochure, oKey, "tha_quest1" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oBrochure, oKey, "tha_quest2" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oBrochure, oKey, "tha_quest3" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oBrochure, oKey, "tha_quest4" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oBrochure, oKey, "tha_quest5" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oBrochure, oKey, "tha_quest6" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oBrochure, oKey, "tha_quest7" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oBrochure, oKey, "tha_quest8" ) );
        DelayCommand( (fDelay+0.1), ExportVariable( oPC, oBrochure, oKey, "tha_reputation" ) );
    }

    DelayCommand( (fDelay+0.5), FinishExport( oPC, oKey ) );

    //make sure there's at least one level record
    string sAccount     = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );
    string sPC          = SQLEncodeSpecialChars( GetName( oPC ) );
    string sCDKEY       = GetPCPublicCDKey( oPC );

    string sSQL = "SELECT cdkey FROM player_levelup WHERE account = '"+sAccount+"' and pc='"+sPC+"' LIMIT 1";

    SQLExecDirect( sSQL );

    if ( SQLFetch( ) != SQL_SUCCESS ){

        RecordPC( oPC );
    }
}

void ExportVariable( object oPC, object oJournal, object oKey, string sVariable ){

    int nValue          = GetLocalInt( oJournal, sVariable );
    string sKey         = GetName( oKey );
    string sQuery;

    if ( nValue > 0 ){

       sQuery = "INSERT INTO player_journal VALUES ( '"
                +sKey+"', '"
                +sVariable+"', "+IntToString( nValue )+", NOW() ) "
                +"ON DUPLICATE KEY UPDATE value="+IntToString( nValue );

        //execute query
        SQLExecDirect( sQuery );

        //feedback
        //SendMessageToPC( oPC, "Exporting " + sVariable + " = " + IntToString( nValue ) );
    }

    //store on Key for faster access
    //SetLocalInt( oKey, sVariable, nValue );
}

void FinishExport( object oPC, object oKey ){

    object oJournal     = GetLocalObject( oPC, "MyJournal" );
    object oBrochure    = GetItemPossessedBy( oPC, "tha_brochure" );
    string sQuery;
    string sKey = GetName( oKey );

    sQuery = "INSERT INTO player_keys VALUES ( '"
            +SQLEncodeSpecialChars( GetPCPlayerName( oPC ) )+"', '"
            +SQLEncodeSpecialChars( GetName( oPC ) )+"', '"
            +sKey+"', NOW() )";

    //execute query
    SQLExecDirect( sQuery );

    //mark items as processed
    SetLocalInt( oKey, "ds_done", 5 );
    SetLocalInt( oJournal, "ds_done", 1 );
    SetLocalInt( oBrochure, "ds_done", 1 );
}

string GetStartWaypoint( object oPC, int nOverrideWithFaction=FALSE ){

    /*
    1 - 8 are old racial alternative homes
    20 Kampos
    50 Cordor
    51 Cordor, level 8+ //obsolete
    35 Underport
    53 Shrine of Elistraee
    54 Plane of Exits (server 2)

    */
    int nModule             = GetLocalInt( GetModule(), "Module" );
    int nHome               = GetPCKEYValue( oPC, "bp_1" );
    int nFaction            = GetPCKEYValue( oPC, "bp_2" );
    int nCustomSlot         = 0;
    int nAlignment          = GetAlignmentGoodEvil( oPC );
    int nRace               = GetRacialType(oPC);
    object oStorage         = GetCache( "ds_bindpoint_storage" );
    string sWP;

    if ( nModule == 1 ){

        nCustomSlot = GetPCKEYValue( oPC, "bp_home1" );
    }
    else{

        nCustomSlot = GetPCKEYValue( oPC, "bp_home2" );
    }

    //check custom home area first
    if ( nCustomSlot > 0 && nOverrideWithFaction == TRUE ){

        //testing
        //SendMessageToPC( oPC, "<c¥  >Test 1a: nCustomSlot="+IntToString(nCustomSlot)+"</c>" );

        //translate slot into bindpoint
        sWP     = "b_"+IntToString( GetPCKEYValue( oPC, "bp_"+IntToString( nCustomSlot ) ) );

        //testing
        SendMessageToPC( oPC, "<c¥  >Test 1b: sWP="+sWP+"</c>" );

        if ( GetIsObjectValid( GetLocalObject( oStorage, sWP ) ) ){

            //testing
            //SendMessageToPC( oPC, "<c¥  >Test 1c: Custom WP is valid</c>" );

            //custom home area is on this server
            return sWP;
        }
    }

    if ( nFaction > 0 && nOverrideWithFaction == TRUE ){

        //testing
        //SendMessageToPC( oPC, "<c¥  >Test 2a: nFaction="+IntToString(nFaction)+"</c>" );

        if ( GetIsObjectValid( GetLocalObject( oStorage, "b_"+IntToString( nFaction ) ) ) ){

            //testing
            //SendMessageToPC( oPC, "<c¥  >Test 2b: Faction WP is valid</c>" );

            //faction area is on this server
            return "b_"+IntToString( nFaction );
        }
    }

    //take care of old homes or new PCs
    if ( !nHome ){

        int nOldHome = GetPCKEYValue( oPC, "ds_home" );

        if ( nOldHome > 0 ){

            nHome = TranslateStartWaypoint( nOldHome );
        }
        else{

            //default to Cordor
            nHome = 50;

            // PC is a drow
            if( nRace == 33 ){

                if ( nAlignment == ALIGNMENT_EVIL || nAlignment == ALIGNMENT_NEUTRAL ){

                    nHome = 90;
                }
                else{

                    nHome = 53;
                }
            }
            // PC is a Goblin, Hobgoblin, Kobold, Orc, Orog, Ogrillon
            if( (nRace == 38) || (nRace == 42) || (nRace == 39) || (nRace == 43) || (nRace == 45) || (nRace == 44))
            {
                nHome = 9;
            }
        }

        //store for future use
        SetPCKEYValue( oPC,  "bp_1", nHome );
    }



    if ( GetIsObjectValid( GetLocalObject( oStorage, "b_"+IntToString( nHome ) ) ) ){

        //faction area is on this server
        return "b_"+IntToString( nHome );
    }

    return "";
}

int TranslateStartWaypoint( int nHome ){

    switch ( nHome ) {

        case 00:     return 50;    break;
        case 01:     return 50;    break;
        case 02:     return 50;    break;
        case 03:     return 50;    break;
        case 04:     return 50;    break;
        case 05:     return 90;    break;
        case 06:     return 09;    break;
        case 07:     return 53;    break;
        case 08:     return 50;    break;
        case 20:     return 20;    break;
        case 39:     return 26;    break;
        case 50:     return 50;    break;
        case 53:     return 53;    break;
        default:    return  0;    break;
    }

    return 0;
}

int HasBindPoint( object oPC, int nBindpoint ){

    string sSlot;
    int i;

    if ( nBindpoint ){

        for ( i=1; i<11; ++i ){

            sSlot = "bp_" + IntToString( i );

            if ( GetPCKEYValue( oPC, sSlot ) == nBindpoint ){

                return TRUE;
            }
        }
    }

    return FALSE;
}

void db_onTransition( object oPC, object oArea ){


    if ( !GetIsDM( oPC ) && !GetIsDMPossessed( oPC ) ){

        int nDone = GetLocalInt( oPC, "ds_done" );


        if ( ResolveTransport( oPC, oArea ) ){

            return;
        }

        //fallen item
        if ( GetLocalInt( oPC, "Fallen" ) == 1 ){
            SendMessageToPC( oPC, "Remember, you are Fallen and cannot cast spells from your Fallen class!" );
            //AssignCommand( oPC, ActionCastSpellAtObject( 831, oPC, 1, TRUE, 0, 1, TRUE ) );
        }

        //underwater effects, blindness
        ApplyAreaAndRaceEffects( oPC );

        string szRace       = GetStringLowerCase( GetSubRace( oPC )  );

        // Map Reveal: Unfog if the CS_MAP_REVEAL integer variable is equal to 1
        if( GetLocalInt( oArea, "CS_MAP_REVEAL" ) ){

            ExploreAreaForPlayer( oArea, oPC );
        }

        object oDM = GetLocalObject( oPC, "dm_trace" );

        if ( GetIsObjectValid( oDM ) ){

            SendMessageToPC( oDM, GetName( oPC ) + " entered " + GetName( oArea ) );
        }
    }

    if ( ResolveTransport( oPC, oArea ) ){

        return;
    }

    //used for time management
    UpdatePlayerRunTime( oPC, GetModule() );

    //seem old hunk
    SetLocalInt( oArea, "PlayerCount", ( GetLocalInt( oArea, "PlayerCount" ) + 1 ) );

    //used for keeping player counts
    SetLocalObject( oPC, "LastArea", oArea );

    //area counter with cache
    string sQuery;
    int nVisited = GetLocalInt( oArea, "v_visit" );
    int nModule  = GetLocalInt( GetModule(), "Module" );

    //no pooling with DMs
    if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ){

        if ( nModule == 2 ){

            sQuery = "INSERT INTO area_visits_2 VALUES ('" +
                        SQLEncodeSpecialChars( GetName(oArea) ) +"', '" +
                        GetResRef(oArea) + "', NOW(), 1, 0 ) ON DUPLICATE KEY UPDATE updated_at=NOW(), dm_visits = dm_visits + 1";
        }
        else{

            sQuery = "INSERT INTO area_visits VALUES ('" +
                        SQLEncodeSpecialChars( GetName(oArea) ) + "', '" +
                        GetResRef(oArea) + "', NOW(), 1, 0 ) ON DUPLICATE KEY UPDATE updated_at=NOW(), dm_visits = dm_visits + 1";
        }

        if ( nVisited != 1 ){

            sQuery = sQuery + ", name = '"+ SQLEncodeSpecialChars( GetName(oArea) )+"'";
            SetLocalInt( oArea, "v_visit", 1 );
        }

        SQLExecDirect(sQuery);

        return;
    }

    //make subcounter on area (if an area had more than 10 hits this session all other hits will be pooled in batches of 10)
    int nVisitCounter     = GetLocalInt( oArea, "v_count" );
    int nVisitCounterMode = GetLocalInt( oArea, "v_mode" );
    int nAdd;

    //update counter. NB: we count from 0-9 here!
    SetLocalInt( oArea, "VisitCounter", (nVisitCounter+1) );

    if ( nVisitCounterMode == 1 && nVisitCounter == 9 ){

        // add batches of 10 if the area has been marked as busy
        SetLocalInt( oArea, "VisitCounter", 0 );
        nAdd = 10;
    }
    else if ( nVisitCounterMode == 1 && nVisitCounter < 9 ){

        //block database access till the counter hits 10
        nAdd = 0;
    }
    else if ( nVisitCounterMode == 0 && nVisitCounter == 9 ){

        // add 1 and mark the area as busy and reset counter
        SetLocalInt( oArea, "VisitCounterMode", 1 );
        SetLocalInt( oArea, "VisitCounter", 0 );
        nAdd = 1;
    }
    else{

        // add 1 as a default
        nAdd = 1;
    }

    if ( nAdd > 0 ){

        //update area record
        if ( nModule == 2 ){

            sQuery = "INSERT INTO area_visits_2 VALUES ('" +
                    SQLEncodeSpecialChars( GetName(oArea) ) + "', '" +
                    GetResRef(oArea) + "', NOW(), 0, 1 ) "+
                    "ON DUPLICATE KEY UPDATE updated_at=NOW(), pc_visits = pc_visits + "+IntToString(nAdd);
        }
        else{

            sQuery = "INSERT INTO area_visits VALUES ('" +
                    SQLEncodeSpecialChars( GetName(oArea) ) + "', '" +
                    GetResRef(oArea) + "', NOW(), 0, 1 ) "+
                    "ON DUPLICATE KEY UPDATE updated_at=NOW(), pc_visits = pc_visits + "+IntToString(nAdd);
        }

        if ( nVisited != 1 ){

            sQuery = sQuery + ", name = '" + SQLEncodeSpecialChars( GetName(oArea) ) + "'";

            SQLExecDirect(sQuery);

            SetLocalInt( oArea, "v_visit", 1 );

            if ( GetIsObjectValid( GetFirstObjectInAreaByTag( oArea, "is_area" ) ) == FALSE ){

                //somebody forgot to add is_area
                 SQLExecDirect( "INSERT INTO area_no_isarea VALUES ( '"+
                    SQLEncodeSpecialChars( GetName(oArea) )+"','"+IntToString( nModule )+"', 1 )" );
            }
        }
        else{

            SQLExecDirect(sQuery);
        }
    }
}

void db_trace_shop( object oPC, object oShop, object oShopkeeper ){

    string sQuery;

    //make subcounter on the shopkeeper (if a shop has more than 5 hits this session all other hits will be pooled in batches of 5)
    int nVisitCounter     = GetLocalInt( oShopkeeper, "VisitCounter" );
    int nVisitCounterMode = GetLocalInt( oShopkeeper, "VisitCounterMode" );
    int nAdd;

    //update counter. NB: we count from 0-4 here!
    SetLocalInt( oShopkeeper, "VisitCounter", (nVisitCounter+1) );

    if ( nVisitCounterMode == 1 && nVisitCounter == 4 ){

        // add batches of 5 if the shop has been marked as busy
        SetLocalInt( oShopkeeper, "VisitCounter", 0 );
        nAdd = 5;
    }
    else if ( nVisitCounterMode == 1 && nVisitCounter < 4 ){

        //block database access till the counter hits 5
        nAdd = 0;
    }
    else if ( nVisitCounterMode == 0 && nVisitCounter == 4 ){

        // add 1 and mark the shop as busy and reset counter
        SetLocalInt( oShopkeeper, "VisitCounterMode", 1 );
        SetLocalInt( oShopkeeper, "VisitCounter", 0 );
        nAdd = 1;
    }
    else{

        // add 1 as a default
        nAdd = 1;
    }

    if ( nAdd > 0 ){

        //update area record
        sQuery = "INSERT INTO shop_visits VALUES ('" +
                SQLEncodeSpecialChars( GetName( oShopkeeper ) ) + "', '" +
                SQLEncodeSpecialChars( GetName( oShop ) ) + "', '" +
                GetResRef( oShop ) + "', '" +
                SQLEncodeSpecialChars( GetName( GetArea( oShop ) ) ) + "', 1, NOW() ) "+
                "ON DUPLICATE KEY UPDATE updated_at=NOW(), visits = visits + "+IntToString(nAdd);
        SQLExecDirect(sQuery);
    }
}

//gets (modifier=0) and sets (modifier!=0) reputation
int tha_reputation( object oPC, int nModifier ){

    int nReputation     = GetPCKEYValue( oPC, "tha_reputation" );

    if ( nModifier > 0 ){

        nReputation = nReputation + nModifier;

        SendMessageToPC( oPC, "Your reputation on Forrstakkr increased!" );

        SetPCKEYValue( oPC, "tha_reputation", nReputation );
    }
    else if ( nModifier < 0 ){

        nModifier = abs( nModifier );

        if ( nModifier > nReputation ){

            nReputation = 0;
        }
        else{

            nReputation = nReputation-nModifier;
        }

        SetPCKEYValue( oPC, "tha_reputation", nReputation );

        SendMessageToPC( oPC, "Your reputation on Forrstakkr decreased!");
    }

    return(nReputation);
}

//gets (nValue=0) and sets (nValue>0) quest status and sets journal
int ds_quest( object oPC, string sQuest, int nValue=0 ){

    int nQuest          = GetPCKEYValue( oPC, sQuest );

    if( nValue > 0 ){

        nQuest = nValue;

        SetPCKEYValue( oPC, sQuest, nQuest );

        AddJournalQuestEntry( sQuest, nQuest, oPC, FALSE, FALSE, FALSE );
    }

    return( nQuest );
}

//This function should only be used in the module heartbeat script!
//It runs the first available execution in the server_commands table
void RunServerCommand(){


    int nCount = GetLocalInt( OBJECT_SELF, "ds_cmnd_cnt" );

    if ( nCount < 10 ){

        ++nCount;

        SetLocalInt( OBJECT_SELF, "ds_cmnd_cnt", nCount );
        return;
    }

    //commands are imported once a minute
    SetLocalInt( OBJECT_SELF, "ds_cmnd_cnt", 0 );

    Messenger();

    AutoSave();
}

object GetPCByAccount( string sAccount ){

    object oPC = GetFirstPC();

    while ( GetIsObjectValid( oPC ) == TRUE ){

        if ( GetPCPlayerName( oPC ) == sAccount ){

            return oPC;
        }

        oPC = GetNextPC();
    }

    return OBJECT_INVALID;
}

void Messenger(){

    //clear all stale messages
    string sQuery = "UPDATE messenger SET message_read=2 WHERE message_read=0 AND TIMESTAMPDIFF( MINUTE, insert_at, NOW() ) > 60";

    //execute cleanup
    SQLExecDirect( sQuery );

    string sModule = IntToString( GetLocalInt( GetModule(), "Module" ) );

    sQuery = "SELECT message_to, count( id ) as messages FROM messenger WHERE message_read=0 GROUP BY message_to";

    //execute retrieval
    SQLExecDirect( sQuery );

    //loop through commands
    while( SQLFetch( ) == SQL_SUCCESS ){

        //decoding shouldn't be needed
        string sTo          = SQLDecodeSpecialChars( SQLGetData( 1 ) );
        string sMessages    = SQLDecodeSpecialChars( SQLGetData( 2 ) );

        if ( sTo == sModule ){

            DelayCommand( 1.0, InformDMs( sModule ) );
        }
        else{

            object oPC          = GetPCByAccount( sTo );

            if ( GetIsPC( oPC ) ){

                //set message counter for post box
                SetLocalInt( oPC, "ds_ms_cnt", StringToInt( sMessages ) );

                //warn player
                FloatingTextStringOnCreature( "<cþ þ>You got "+sMessages+" unread message(s)!</c>", oPC, FALSE );
                FloatingTextStringOnCreature( "<c þþ>Use the Rest menu to check them.</c>", oPC, FALSE );
                AssignCommand( oPC, PlaySound( "gui_dm_alert" ) );
            }
        }
    }
}

// Sets player hit points after log in/out.
void ResolveLoginStatus( object oPC, object oPCKEY, object oModule ){

    // Variables
    string sSQL;
    int nDamage;
    int nPvpMode;

    if ( GetIsDM( oPC )  || GetIsDMPossessed( oPC ) ){

        sSQL     = "SELECT * FROM player_exit where pckey='"+GetPCPublicCDKey( oPC )+"' LIMIT 1";
    }
    else if ( GetIsObjectValid( oPCKEY ) ){

        string sPCKEY   = GetName( oPCKEY );

        sSQL     = "SELECT * FROM player_exit where pckey='"+sPCKEY+"' LIMIT 1";
    }

    if ( sSQL != "" ){

        SQLExecDirect( sSQL );

        if ( SQLFetch( ) == SQL_SUCCESS ){

            SetLocalString( oPC, "p_session", SQLGetData( 3 ) );
            SetLocalString( oPC, "p_target", SQLGetData( 4 ) );
            SetLocalInt( oPC, "p_gold", StringToInt( SQLGetData( 5 ) ) );

            nDamage      = StringToInt( SQLGetData( 6 ) );
        }

        if ( nDamage > 0 ) {

            // Refresh PvP -AND- HP status
            nPvpMode = GetPCKEYValue( oPC, "pvp_dead_mode" );
            SetLocalInt( oPC, "pvp_dead_mode", nPvpMode );
            DeletePCKEYValue( oPC, "pvp_dead_mode" ); // Saves this when you log out
            ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( nDamage, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY ), oPC );

        }
    }

    return;
}

int ResolveTransport( object oPC, object oArea ){

    object oModule          = GetModule();
    object oWP;
    string sSession         = GetLocalString( oModule, "sessionid" );
    string sTarget          = GetLocalString( oPC, "p_target" );
    string sLastSession     = GetLocalString( oPC, "p_session" );
    int nGold               = GetLocalInt( oPC, "p_gold" );
    int nResult             = FALSE;
    effect eFreeze          = EffectCutsceneImmobilize();
    float fDelay            = 3.0;

    //session stuff has been wiped, exit.
    if ( sLastSession == "" ){

        return FALSE;
    }

    if ( sLastSession != sSession && sTarget == "" && GetTag( oArea ) != "amia_entry" && GetPCKEYValue( oPC, "dead_in" ) != GetLocalInt( oModule, "Module" ) ) {

        //testing
        //SendMessageToPC( oPC, "<c¥  >Test: sTarget="+sTarget+"</c>" );
        //SendMessageToPC( oPC, "<c¥  >Test: This session="+sSession+"</c>" );
        //SendMessageToPC( oPC, "<c¥  >Test: Last session="+sLastSession+"</c>" );
        //SendMessageToPC( oPC, "<c¥  >Test: Jump back to entry.</c>" );

        if ( !GetIsDM( oPC ) ){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oPC, fDelay );

            FloatingTextStringOnCreature( "<cþ þ>Wait a moment, you'll be ported back to the Entry.</c>", oPC, FALSE );

            //Logged out of other server, put back to entry

            AssignCommand( oPC, ClearAllActions( TRUE ) );

            AssignCommand( oPC, JumpToLocation( GetStartingLocation() ) );

            nResult = TRUE;
        }
    }
    else if ( sLastSession != sSession && sTarget != "" ){

        //testing
        //SendMessageToPC( oPC, "<c¥  >Test: sTarget="+sTarget+"</c>" );
        //SendMessageToPC( oPC, "<c¥  >Test: This session="+sSession+"</c>" );
        //SendMessageToPC( oPC, "<c¥  >Test: Last session="+sLastSession+"</c>" );
        //SendMessageToPC( oPC, "<c¥  >Test: Move to destination.</c>" );

        //enters from other module within 10 mins
        //to portal destination
        oWP = GetWaypointByTag( sTarget );

        if ( GetIsObjectValid( oWP ) ){

            FloatingTextStringOnCreature( "<cþ þ>Wait a moment, you'll be ported to your destination.</c>", oPC, FALSE );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oPC, fDelay );

            AssignCommand( oPC, TakeGoldFromCreature( nGold, oPC, TRUE ) );

            DelayCommand( fDelay, AssignCommand( oPC, ClearAllActions( TRUE ) ) );

            DelayCommand( fDelay+0.2, AssignCommand( oPC, JumpToObject( oWP, 0 ) ) );

            nResult = TRUE;
        }
    }

    //cleanup
    DeleteLocalString( oPC, "p_target" );
    DeleteLocalString( oPC, "p_session" );
    DeleteLocalInt( oPC, "p_gold" );

    return nResult;
}

void InformDMs( string sModule ){

    string sQuery = "SELECT * FROM messenger WHERE message_read=0 AND message_to='"+sModule+"'";
    string sID;
    string sPC;
    string sArea;
    string sAccount;
    string sMessage;
    int nMessage;

    //execute
    SQLExecDirect( sQuery );

    //loop through commands
    while ( SQLFetch( ) == SQL_SUCCESS ){

        //decoding shouldn't be needed
        sID      = SQLGetData( 1 );
        sPC      = SQLDecodeSpecialChars( SQLGetData( 2 ) );
        sArea    = SQLDecodeSpecialChars( SQLGetData( 4 ) );
        sAccount = SQLDecodeSpecialChars( SQLGetData( 6 ) );
        nMessage = StringToInt( SQLGetData( 7 ) );
        sMessage = "";

        sQuery = "UPDATE messenger SET message_read = 1 WHERE id = " + sID;
        SQLExecDirect( sQuery );

        if ( sPC == "DM Avatar" ){

            if ( nMessage == 1 ){sMessage = "Need soem help with an event."; }
            if ( nMessage == 2 ){sMessage = "Need some help with a player issue."; }
            if ( nMessage == 3 ){sMessage = "Please open MSN for discussion."; }
            if ( nMessage == 4 ){sMessage = "Take a look at the forum. Posted something important."; }
        }
        else{

            if ( nMessage == 1 ){sMessage = "Jerk alert in my area!"; }
            if ( nMessage == 2 ){sMessage = "Good roleplay in my area!"; }
            if ( nMessage == 3 ){sMessage = "We're having a fight again. Please mediate."; }
            if ( nMessage == 4 ){sMessage = "I could use some (non urgent) help."; }
        }

        if ( sMessage != "" ){

            SendMessageToAllDMs( "Message from other server!\nPC: <cþþ >"+sPC+"</c>\nAccount: <cþþ >"+sAccount+"</c>\nMessage: <cþþ >"+sMessage+"</c>\nArea: <cþþ >"+sArea+"</c>" );
        }
   }
}

int AuthorisePC( object oPC, object oPCKEY, string sCDKEY, string sAccount ){

    //check PCKEY vs CDKEY
    string sCharCDKEY = GetStringLeft( GetName( oPCKEY ), 8 );

    if ( sCharCDKEY == "" ){

        //no cdkey yet. Either a new character, or one that won't get in anyway.
        return 1;
    }
    else if ( sCharCDKEY != sCDKEY ){

        SendMessageToPC( oPC, "[Your CDKEY doesn't match your PCKEY: Authorising your PC.]" );

        //check key for authorisation
        if ( GetPCKEYValue( oPCKEY, sCDKEY ) != 1 ){

            //check database for authorisation
            SQLExecDirect( "SELECT cdkey FROM player_authentication WHERE cdkey = '"+sCDKEY+"' AND account = '"+SQLEncodeSpecialChars(sAccount)+"'" );

            if ( SQLFetch( ) == SQL_SUCCESS ){

                if ( SQLGetData( 1 ) == sCDKEY ){

                    //this account/key combination is authorised
                    SetPCKEYValue( oPCKEY, sCDKEY, 1 );

                    return 1;
                }
            }
        }
        else{

            //has been checked already
            return 1;
        }
    }
    else if ( sCharCDKEY == sCDKEY ){

        return 1;
    }

    return 0;
}

//checks if a new PC is added to the right account
//returns 1 on success
int AuthoriseNewPC( object oPC, string sCDKEY, string sAccount, string sIP ){

    sAccount        = SQLEncodeSpecialChars( sAccount );
    string sPC      = SQLEncodeSpecialChars( GetName( oPC ) );
    string sKnownCDKEY;

    string sSQL = "SELECT cdkey FROM player_identity WHERE account='" + sAccount + "'";

    SQLExecDirect( sSQL );

    //loop through known account/cdkey combinations
    while ( SQLFetch( ) == SQL_SUCCESS ){

        sKnownCDKEY = SQLGetData( 1 );

        //if you played in this vault before, there you go
        if ( sKnownCDKEY == sCDKEY ){

            sSQL = "INSERT INTO new_pcs VALUES ( NULL,'"+sPC+"', '"+sAccount+"', '"+sCDKEY+"', '"+sIP+"', 1, NOW() )";
            SQLExecDirect( sSQL );

            return 1;
        }
    }

    //if no combination is known you are also free to go and make a new pc
    if ( sKnownCDKEY == "" ){

        sSQL = "INSERT INTO new_pcs VALUES ( NULL,'"+sPC+"', '"+sAccount+"', '"+sCDKEY+"', '"+sIP+"', 2, NOW() )";
        SQLExecDirect( sSQL );

        return 1;
    }


    sSQL = "INSERT INTO new_pcs VALUES ( NULL,'"+sPC+"', '"+sAccount+"', '"+sCDKEY+"', '"+sIP+"', 3, NOW() )";
    SQLExecDirect( sSQL );

    return 0;
}


object GetInsigniaB( object oPC ){

    object oInsignia = GetLocalObject( oPC, "Insignia" );

    if ( GetIsObjectValid( oInsignia ) && GetTag( oInsignia ) == "HouseInsignia" ){

        //SendMessageToPC( oPC, "<c¥  >Test: Detected cached "+GetName( oInsignia )+"</c>" );

        return oInsignia;
    }

    if ( GetLocalInt( oPC, "NoInsignia" ) == 1 ){

        return OBJECT_INVALID;
    }

    oInsignia = GetItemPossessedBy( oPC, "HouseInsignia" );

    if ( !GetIsObjectValid( oInsignia ) ){

        SetLocalInt( oPC, "NoInsignia", 1 );
    }

    //SendMessageToPC( oPC, "<c¥  >Test: Cached "+GetName( oInsignia )+"</c>" );

    return oInsignia;
}

object GetInsigniaWaypointB( object oPC ){

    object oInsignia    = GetInsigniaB( oPC );
    string szHouseName  = GetLocalString( oInsignia, "HouseName" );
    object oHome        = GetWaypointByTag( "wp_" + szHouseName );

    return oHome;
}

void StoreRing( object oRing ){

    SetIdentified( oRing, TRUE );

    string sRing    = SQLEncodeSpecialChars( GetName( oRing ) );

    string sQuery = "INSERT INTO rings VALUES ( NULL, '"+
                    sRing+"', '"+
                    GetResRef( oRing )+"', "+ IntToString( GetGoldPieceValue( oRing ) )+", "+
                    "%s, NOW() )";

    //execute
    SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

    //sql hooks into BioWare campaign DB stuff
    StoreCampaignObject ( "NWNX", "-", oRing );
}


void CreateRing( object oContainer, string sSearch="" ){

    string sQuery;

    if ( sSearch == "" ){

        sQuery = "SELECT item_data FROM rings ORDER BY RAND() LIMIT 1";
    }
    else{

        sQuery = "SELECT item_data FROM rings WHERE item_name LIKE '%" + sSearch + "%' LIMIT 1";
    }

    //execute
    SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

    //sql hooks into BioWare campaign DB stuff
    RetrieveCampaignObject ("NWNX", "-", GetLocation( oContainer ), oContainer );
}

void ImportRules( ){

    object oRules = GetObjectByTag( "ds_rules_plc" );
    SetDescription( oRules, "\n" );

    DelayCommand(  1.0, ImportRule( 1100 ) );
    DelayCommand(  2.0, ImportRule( 1105 ) );
    DelayCommand(  3.0, ImportRule( 1110 ) );
    DelayCommand(  4.0, ImportRule( 1115 ) );
    DelayCommand(  5.0, ImportRule( 1120 ) );
    DelayCommand(  6.0, ImportRule( 1125 ) );
    DelayCommand(  7.0, ImportRule( 1130 ) );
    DelayCommand(  8.0, ImportRule( 1135 ) );
    DelayCommand(  9.0, ImportRule( 1140 ) );
    DelayCommand( 10.0, ImportRule( 1145 ) );
    DelayCommand( 11.0, ImportRule( 1150, oRules ) );
    DelayCommand( 12.0, ImportRule( 1155 ) );
}

void ImportRule( int nCategory, object oRules=OBJECT_INVALID ){

    string sQuery = "SELECT heading, content FROM rules WHERE category = "+IntToString( nCategory )+" ORDER BY position";
    string sHeading;
    string sContent;
    string sRules;

    SQLExecDirect( sQuery );

    while( SQLFetch( ) == SQL_SUCCESS ){

        sHeading = DecodeSpecialChars( SQLGetData( 1 ) );
        sContent = DecodeSpecialChars( SQLGetData( 2 ) );

        sRules += "<cþþ >"+sHeading+"</c>\n"+sContent+"\n\n";
    }

    if ( sRules == "" ){

        SetLocalInt( GetModule(), "ds_rule_"+IntToString( nCategory ), -1 );
    }
    else if ( GetIsObjectValid( oRules ) ){

        SetDescription( oRules, GetDescription( oRules )+sRules );
    }

    SetCustomToken( nCategory, sRules );
}

void AddRulesToJournal( object oPC ){

    object oModule = GetModule();

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1100 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1100 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1105 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1105 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1110 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1110 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1115 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1115 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1120 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1120 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1125 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1125 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1130 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1130 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1135 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1135 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1140 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1140 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1145 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1145 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1150 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1150 ), 1, oPC, FALSE );
    }

    if ( GetLocalInt( oModule, "ds_rule_"+IntToString( 1155 ) ) != -1 ){

        AddJournalQuestEntry( "rule_"+IntToString( 1155 ), 1, oPC, FALSE );
    }
}

string DecodeSpecialChars( string sString ){

    if ( FindSubString( sString, "~" ) == -1 && FindSubString( sString, "^" ) == -1 ) // not found
        return sString;

    int i;
    string sReturn = "";
    string sChar;

    // Loop over every character and replace special characters
    for (i = 0; i < GetStringLength(sString); i++)  {

        sChar = GetSubString(sString, i, 1);

        if ( sChar == "~" ){

            sReturn += "'";
        }
        else if ( sChar == "^" ){

            sReturn += "\n";
        }
        else {

            sReturn += sChar;
        }
    }
    return sReturn;
}


object GetAreaByResRef( string sResRef, object oAreaList=OBJECT_INVALID ){

    if ( oAreaList == OBJECT_INVALID ){

        oAreaList = GetCache( "ds_area_storage" );
    }

    return GetLocalObject( oAreaList, sResRef );
}

object GetNthArea( int n, object oAreaList=OBJECT_INVALID ){

    if ( oAreaList == OBJECT_INVALID ){

        oAreaList = GetCache( "ds_area_storage" );
    }

    string sResRef = GetLocalString( oAreaList, "a_"+IntToString( n ) );

    return GetLocalObject( oAreaList, sResRef );
}


