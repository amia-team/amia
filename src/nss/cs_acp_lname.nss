/*  Amia Control Panel [ACP] :: ChangeFirstName :: Modify Character Last Name

    --------
    Verbatim
    --------
    This script will modify the character's last name.

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
#include "nwnx_creature"

void main( ){

    // Variables.
    object oVault           = OBJECT_SELF;
    object oPC              = GetPCSpeaker( );

    string szNewLastName   = GetLocalString( oVault, STORAGE_VARIABLE_1 );

    // Update character file with the modification.
    NWNX_Creature_SetOriginalName( oPC, szNewLastName, TRUE );

    return;

}
