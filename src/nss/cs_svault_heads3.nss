/*  Automatic Character Maintenance [ACM] :: ChangeHead :: Abort, Cancel Head Modification

    --------
    Verbatim
    --------
    This script will restore the player's character's old head appearance.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    060806  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "cs_inc_leto"

void main( ){

    // Variables.
    object oVault           = OBJECT_SELF;
    object oPC              = GetPCSpeaker( );
    int nAborted            = GetLocalInt( oVault, STORAGE_VARIABLE_2 );
    int nOldHeadAppearance  = GetLocalInt( oVault, STORAGE_VARIABLE_3 );

    // Last used the ACM:: Heads.
    if( nAborted == 999 ){

        // Restore the player's character's old head appearance.
        SetCreatureBodyPart( CREATURE_PART_HEAD, nOldHeadAppearance, oPC );

        // Save the character file.
        ExportSingleCharacter( oPC );

        // Reset ACM option variable.
        SetLocalInt( oVault, STORAGE_VARIABLE_2, 0 );

    }

    return;

}
