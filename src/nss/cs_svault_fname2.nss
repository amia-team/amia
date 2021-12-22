/*  Automatic Character Maintenance [ACM] :: ChangeFirstName :: Modify Character First Name

    --------
    Verbatim
    --------
    This script will get the player's new name from the Vault's variable storage, modify the
    character's first name and subtract 3 DCs as well.

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
    int nDC_requirement     = 3;
    int nDCs_taken          = 0;

    string szNewFirstName   = "";

    // Store character's new first name in the Vault. Max 30 characters.
    if( GetListenPatternNumber( ) == ACM_LISTEN_NO )
        szNewFirstName = GetStringLeft( GetMatchedSubstring( 0 ), 30 );

    /* Verify player has sufficient dream coins to perform this operation. */

    // Insufficient, abort.
    if( GetDreamCoinAmount( oPC ) < nDC_requirement ){

        FloatingTextStringOnCreature(
            "<cþ  >- Insufficient Dream Coins to perform this First Name change. -</c>",
            oPC,
            FALSE);

        return;

    }

    // Sufficient, proceed with modification.

    // Remove required Dream Coins.
    nDCs_taken = TakeDreamCoins( oPC, nDC_requirement, "First Name Change" );

    // Logfile record.
    string szMessage=
        "|-Automated Character Maintenance-|Name="      +
        GetPCPlayerName( oPC )                          +
        "|Character's Name="                            +
        GetName( oPC )                                  +
        "|Reason= ";

    // Error: Too few DCs taken, Abort, Warn DMs, and Log.
    if( nDCs_taken < nDC_requirement ){

        // Setup error message.
        szMessage+="Too few Dream Coins subtracted for their First Name Change and it has been aborted.|";

        // Report to DMs, and Log.
        LogInfoDM( "cs_svault_fname2::ChangeFirstName", szMessage);

    }

    // Success.
    else{

        // Setup notification message.
        szMessage+="Correct amount of Dream Coins subtracted for their First Name Change.|";

        // Log the modification and notify the DMs.
        LogInfoDM( "cs_svault_fname2::ChangeFirstName", szMessage );

        // Update character file with the modification.
        NWNX_Creature_SetOriginalName( oPC, szNewFirstName, FALSE );

    }

    return;

}
