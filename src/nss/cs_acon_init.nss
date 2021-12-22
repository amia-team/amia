/*  Amia Control Panel [ACP] :: Initiatlization :: Check NWNX2 Operational and Begin Conversation

    --------
    Verbatim
    --------
    This script verifies that NWNX2 is operational and makes the DM begin a conversation
    with her Vault.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    061506  kfw         Initial release.
    082206  kfw         Updated Leto function.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "nwnx_creature"

void main( ){

    // Variables.
    object oVault                   = OBJECT_SELF;
    object oPC                      = GetLastUsedBy( );
    string szConvoRef               = "c_acp";


    // Begin the conversation for character modification for player characters only.
    if( GetIsDM( oPC ) )
        ActionStartConversation( oPC, szConvoRef, TRUE, FALSE);
        // Error: NPCs and DMs not permissible.
    else
        FloatingTextStringOnCreature(
            "<cþ  >- Only DMs may use the ACP. -</c>",
             oPC,
             FALSE);

    return;

}
