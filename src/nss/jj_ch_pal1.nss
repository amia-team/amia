/*  Verify Henchy Paladin Status

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    04142010  jj         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Verifies the henchy's Paladin status.

*/

/* Includes */
#include "NW_I0_GENERIC"

int StartingConditional( ){

    // Variables
    object oHenchy      = OBJECT_SELF;
    int nStatus         = GetLevelByClass( CLASS_TYPE_PALADIN, oHenchy );

    return( nStatus );

}
