/*  The Amia Control Panel [ACP] :: Panel :: Initialization

    --------
    Verbatim
    --------
    This script sets up the ACP's variables and conversation tokens.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    070206  kfw         Initial release.
//2007-12-02    disco   Using inc_ds_records now
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "amia_include"
#include "cs_inc_leto"

void main( ){

    // Variables.
    object oPanel       = OBJECT_SELF;
    object oPC          = GetLastUsedBy( );
    int nDMstatus       = GetDMStatus( GetPCPlayerName( oPC ), GetPCPublicCDKey( oPC ) );


    // Only initialize ACP convo for Amia DMs.
    if( nDMstatus > 0 ){

        ExportSingleCharacter( oPC );

        ActionStartConversation( oPC, "c_acp", TRUE, FALSE);

    }
    else{

        SendMessageToPC( oPC, "- Access Denied! -" );
    }

    return;

}
