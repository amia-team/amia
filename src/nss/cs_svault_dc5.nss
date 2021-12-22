/*  Automatic Character Maintenance [ACM] :: Check :: Dream Coin Requirement :: Five

    --------
    Verbatim
    --------
    This script checks whether the player has 5 or more DCs.

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

int StartingConditional( ){

    // Variables.
    object oPC      = GetPCSpeaker( );
    int nDC_Count   = GetLocalInt( oPC, STORAGE_DC_COUNT );
    int nDC_Req     = 5;

    // Player has five or more DCs.
    if( nDC_Count >= nDC_Req )
        return( TRUE );
    // Insufficient DCs.
    else
        return( FALSE );

}
