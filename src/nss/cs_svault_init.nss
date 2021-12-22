/*  Automatic Character Maintenance [ACM] :: Initiatlization :: Player Data and Purge Buffers

    --------
    Verbatim
    --------
    This script retrieves and stores player's Dream and Platinum Coin count.

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

void main( ){

    // Variables.
    object oPC              = GetPCSpeaker( );
    string szCharacterName  = GetName( oPC );

    // Gets the latest Dream and Platinum Coin counts.
    GetDreamCoinAmount( oPC );

    // Reset Listen pattern buffer on the Vault.
    AssignCommand( GetNearestObjectByTag( "Menri" ), ActionSpeakString(" ") );

    // Sets Conversation dialog to display player's character's name.
    SetCustomToken( ACM_TOKEN_DIALOG, szCharacterName );

    return;

}
