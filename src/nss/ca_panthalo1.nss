/*  Merchant :: Panthalo :: Requirements

    --------
    Verbatim
    --------
    Panthalo requires the speaker to be of at least 15 monk levels to view his shop.
    Also, haven't previously bought a kit from him.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    070406  kfw         Initial release.
    070806  kfw         Updated the requirements slightly.
  20071112  disco       Rewrite.
    ----------------------------------------------------------------------------

*/

#include "inc_ds_records"

int StartingConditional( ){

    // Variables.
    object oPC          = GetPCSpeaker( );
    int nLevel          = GetHitDice( oPC );
    int nMonkLevel      = GetLevelByClass( CLASS_TYPE_MONK, oPC );

    // Not bought a kit before.
    int nDone           = GetPCKEYValue( oPC, "cs_panthalo_done" );

    // Meets levels and haven't bought any kits requirement.
    if( nLevel > 14 && nMonkLevel > 9 && !nDone ){

        return( TRUE );
    }
    else{

        return( FALSE );
    }
}
