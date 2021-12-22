/*  Automatic Character Maintenance [ACM] :: ChangeHead :: Save Old Head Appearance

    --------
    Verbatim
    --------
    This script will save the player's character's old head appearance on the Vault.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    042905  kfw         Initial release.
    060806  kfw         Optimization, syntax.
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "cs_inc_leto"

void main( ){

    // Variables.
    object oVault           = OBJECT_SELF;
    object oPC              = GetPCSpeaker( );
    int nHeadAppearance     = GetCreatureBodyPart( CREATURE_PART_HEAD, oPC );

    // Set ACM option variable: Used to restore an old head appearance if the player doesn't pay up!
    SetLocalInt( oVault, STORAGE_VARIABLE_2, 999 );

    // Save character's old head appearance.
    SetLocalInt( oVault, STORAGE_VARIABLE_3, nHeadAppearance );

    return;

}
