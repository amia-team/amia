/*  The Oracle :: Panel :: Initialization

    --------
    Verbatim
    --------
    This script sets up the Oracle's variables and conversation tokens.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    061506  kfw         Initial release.
    080510  Terra       Soften it up, action scripted and on_chat listener fixage
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "inc_ds_actions"

void main( ){

    // Variables.
    object oPanel       = OBJECT_SELF;
    object oPC          = GetLastUsedBy( );

    clean_vars( oPC, 4, "td_pc_namechange" );

    ActionStartConversation( oPC, "c_oracle", TRUE, FALSE );

    return;

}
