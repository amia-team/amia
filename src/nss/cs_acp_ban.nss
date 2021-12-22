/*  Amia Control Panel [ACP] :: Ban :: Ban Player w/ Reason

    --------
    Verbatim
    --------
    This script will ban a player by her designated character name (enforced by CD-key) and with a reason.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    070106  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "cs_inc_leto"
#include "logger"
#include "aps_include"

void main( ){

    // Variables.
    object oPanel           = OBJECT_SELF;
    object oDM              = GetPCSpeaker( );
    string szCharacterName  = GetLocalString( oPanel, STORAGE_VARIABLE_1 );
    string szReason         = "";

    // Retrieve the reason.
    szReason = GetStringLeft( GetMatchedSubstring( 0 ), 30 );

    // Cycle the player list.
    object oPC_list         = GetFirstPC( );
    string szPC_list_name   = GetName( oPC_list );

    while( GetIsObjectValid( oPC_list ) ){

        if( TestStringAgainstPattern( "****" + szCharacterName + "****", szPC_list_name ) )
            break;

        oPC_list            = GetNextPC( );
        szPC_list_name      = GetName( oPC_list );

    }


    // Player acquired, Enforce Ban.
    if( GetIsObjectValid( oPC_list ) ){

        // Variables.
        string szCDKey      = GetPCPublicCDKey( oPC_list );
        string szGameSpy    = SQLEncodeSpecialChars( GetPCPlayerName( oPC_list ) );
        string szTag        = SQLEncodeSpecialChars( GetTag( oPC_list ) );
        string szDM         = SQLEncodeSpecialChars( GetPCPlayerName( oDM ) );

        // Ban.
        SQLExecDirect(  "INSERT INTO banned (cdkey, login, tag, banned_by, reason) "    +
                        "VALUES ('" + szCDKey + "', '" + szGameSpy + "', '"             +
                        szTag + "', '" + szDM + "', '" + szReason + "')" );

        // Notify the DMs.
        string szMsg = GetName( oPC_list ) + " (" + szGameSpy + "), CD Key '" + szCDKey + "' has been banned by " + szDM;
        LogWarn( "cs_acp_ban", szMsg );

        // Boot!
        DelayCommand( 1.0, BootPC( oPC_list ) );

    }

    return;

}

