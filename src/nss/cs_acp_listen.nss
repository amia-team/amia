/*  Amia Control Panel [ACP] :: Panel :: Setup Listener

    --------
    Verbatim
    --------
    This script makes the Panel listen for player text inputted via the Talk Channel.

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

void main( ){

    // Variables.
    object oPanel       = OBJECT_SELF;
    object oPC          = GetPCSpeaker( );

    // Make the Vault listen on the Talk Channel.
    SetListening( oPanel, TRUE );
    SetListenPattern( oPanel, "**", ACP_LISTEN_NO );

    return;

}
