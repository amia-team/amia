/*  Amia Control Panel [ACP] :: Store :: Text

    --------
    Verbatim
    --------
    This script will store text from the Talk channel in the Panel's listener.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    061506  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "cs_inc_leto"
#include "logger"

void main( ){

    // Variables.
    object oPanel           = OBJECT_SELF;
    string szText           = "";

    // Retrieve character's new first name from the Vault listener (Max 30 characters).
    szText = GetStringLeft( GetMatchedSubstring( 0 ), 30 );

    // Store on the Vault.
    SetLocalString( oPanel, STORAGE_VARIABLE_1, szText );
    // Set conversation dialog display token.
    SetCustomToken( ACP_TOKEN_DIALOG, szText );

    return;

}

