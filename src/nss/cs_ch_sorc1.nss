/*  Verify Henchy Sorcerer Status

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032706  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Verifies the henchy's Sorcerer status.

*/

/* Includes */
#include "NW_I0_GENERIC"

int StartingConditional( ){

    // Variables
    object oHenchy      = OBJECT_SELF;
    int nStatus         = GetLevelByClass( CLASS_TYPE_SORCERER, oHenchy );

    return( nStatus );

}
