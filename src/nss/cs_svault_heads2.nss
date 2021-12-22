/*  Automatic Character Maintenance [ACM] :: ChangeHead :: Save Character and Remove Dream Coins

    --------
    Verbatim
    --------
    This script will save the player's character's new head appearance and substract DCs.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    042905  kfw         Initial release.
    060806  kfw         Optimization, syntax.
    ----------------------------------------------------------------------------

*/

/* Includes */
#include "cs_inc_leto"

void main( ){

    // Variables
    object oVault       = OBJECT_SELF;
    object oPC          = GetPCSpeaker( );
    int nDC_requirement = 5;

    // Reset ACM option variable.
    SetLocalInt( oVault, STORAGE_VARIABLE_2, 0 );

    // Remove DCs.
    TakeDreamCoins( oPC, nDC_requirement, "Head Modification" );

    // Save the character file.
    ExportSingleCharacter( oPC );

    return;

}
