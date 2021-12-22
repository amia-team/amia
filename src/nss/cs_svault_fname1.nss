/*  Automatic Character Maintenance [ACM] :: ChangeFirstName :: Store New Name in Vault from Listener

    --------
    Verbatim
    --------
    This script will store player's new name as text from the Talk channel in the Vault's listener.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    122005  kfw         Initial release.
    060606  kfw         Optimization, syntax.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "cs_inc_leto"
#include "logger"

void main( ){

    // Variables.
    object oVault           = OBJECT_SELF;
    object oPC              = GetPCSpeaker( );
    string szNewFirstName   = "";

    // Retrieve character's new first name from the Vault listener (Max 30 characters).
    if( GetListenPatternNumber( ) == ACM_LISTEN_NO )
        szNewFirstName = GetStringLeft( GetMatchedSubstring( 0 ), 30 );

    // Store on the Vault.
    SetLocalString( oVault, STORAGE_VARIABLE_1, szNewFirstName );
    // Set conversation dialog to display the new name so the player can confirm it.
    SetCustomToken( ACM_TOKEN_DIALOG, szNewFirstName );

    return;

}
