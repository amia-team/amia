/*  Oracle :: ChangeFirstName :: Modify Character First Name

    --------
    Verbatim
    --------
    This script will get the player's new name from the Vault's variable storage, modify the
    character's first name.

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

    string szNewFirstName   = GetLocalString( oVault, STORAGE_VARIABLE_1 );

    // Update character file with the modification.
    NWNX_Creature_SetOriginalName( oPC, szNewFirstName, FALSE );

    return;

}
