//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ms_check
//group:   messenger
//used as: checks for messages
//date:    feb 27 2008
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//Gets a message. Returns TRUE on success.
int GetMessage( object oPC );


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
int StartingConditional(){

    return GetMessage( GetPCSpeaker() );
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int GetMessage( object oPC ){

    string sQuery = "SELECT id, message_from, message_to, message_text, TIMESTAMPDIFF( MINUTE, insert_at, NOW() ) FROM messenger WHERE message_read=0 AND message_to='"+GetPCPlayerName( oPC )+"' LIMIT 1";

    //execute
    SQLExecDirect( sQuery );

    //loop through commands
    if ( SQLFetch( ) == SQL_SUCCESS ){

        //decoding shouldn't be needed
        string sID      = SQLGetData( 1 );
        string sFrom    = SQLDecodeSpecialChars( SQLGetData( 2 ) );
        string sTo      = SQLDecodeSpecialChars( SQLGetData( 3 ) );
        string sMessage = SQLDecodeSpecialChars( SQLGetData( 4 ) );
        string sMinutes = SQLGetData( 5 );

        sQuery = "UPDATE messenger SET message_read = 1 WHERE id = " + sID;
        SQLExecDirect( sQuery );

        SetCustomToken( 4300, sFrom );
        SetCustomToken( 4301, sTo );
        SetCustomToken( 4302, sMinutes );
        SetCustomToken( 4303, sMessage );

        SetLocalInt( oPC, "ds_ms_cnt", ( GetLocalInt( oPC, "ds_ms_cnt" ) - 1 ) );

        return TRUE;
    }

    return FALSE;
}

