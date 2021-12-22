/*  Automatic Character Maintenance [ACM] :: Vault :: Setup Listener

    --------
    Verbatim
    --------
    This script makes the Vault listen for player text inputted via the Talk Channel.

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
    object oVault       = OBJECT_SELF;
    object oPC          = GetPCSpeaker( );

    // Make the Vault listen on the Talk Channel.
    SetListening( oVault, TRUE );
    SetListenPattern( oVault, "**", ACM_LISTEN_NO );

    return;

}
