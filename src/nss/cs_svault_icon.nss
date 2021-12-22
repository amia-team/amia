/*  Automatic Character Maintenance [ACM] :: Initiatlization :: Check NWNX2 Operational and Begin Character Modification Conversation

    --------
    Verbatim
    --------
    This script verifies that NWNX2 is operational and makes the player begin a conversation
    with her Vault.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    122005  kfw         Initial release.
    060606  kfw         Optimization, syntax.
  20070515  disco       Added link to Area51 ACM dialog
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "cs_inc_leto"

void main( ){

    // Variables.
    object oVault                   = OBJECT_SELF;
    object oPC                      = GetLastUsedBy( );
    string szConvoRef               = "c_acm";



        // Begin the conversation for character modification for player characters only.
        if( !GetIsDM( oPC ) )
            ActionStartConversation( oPC, szConvoRef, TRUE, FALSE);
        // Error: NPCs and DMs not permissible.
        else
            FloatingTextStringOnCreature(
                "<cþ  >- Only PCs may use the servervault. -</c>",
                oPC,
                FALSE);


    return;

}
