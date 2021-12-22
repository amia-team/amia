/*  Automatic Character Maintenance [ACM] :: ChangeLastName :: Modify Character Last Name

    --------
    Verbatim
    --------
    This script will get the player's new name from the Vault's variable storage, modify the
    character's last name and subtract 3 DCs as well.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    122005  kfw         Initial release.
    060806  kfw         Optimization, syntax.
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

    string szNewLastName   = "";

    // Store character's new last name in the Vault. Max 30 characters.
    if( GetListenPatternNumber( ) == ACM_LISTEN_NO )
        szNewLastName = GetStringLeft( GetMatchedSubstring( 0 ), 30 );

    /* Verify player has sufficient dream coins to perform this operation. */

    // Insufficient, abort.
    if( GetDreamCoinAmount( oPC ) < nDC_requirement ){

        FloatingTextStringOnCreature(
            "<cþ  >- Insufficient Dream Coins to perform this Last Name change. -</c>",
            oPC,
            FALSE);

        return;

    }

    // Sufficient, proceed with modification.

    // Remove required Dream Coins.
    nDCs_taken = TakeDreamCoins( oPC, nDC_requirement, "Last Name Change" );

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
        szMessage+="Too few Dream Coins subtracted for their Last Name Change and it has been aborted.|";

        // Report to DMs, and Log.
        LogInfoDM( "cs_svault_lname2::ChangeLastName", szMessage);

    }

    // Success.
    else{

        // Setup notification message.
        szMessage+="Correct amount of Dream Coins subtracted for their Last Name Change.|";

        // Log the modification and notify the DMs.
        LogInfoDM( "cs_svault_lname2::ChangeLastName", szMessage );

        // Update character file with the modification.
       NWNX_Creature_SetOriginalName( oPC, szNewLastName, TRUE );

    }

    return;

}
