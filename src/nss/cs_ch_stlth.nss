/*  Verify Henchy Stealth Status

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032506  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Verifies the henchy's Stealth status

*/

/* Includes */
#include "NW_I0_GENERIC"

int StartingConditional( ){

    // Variables
    object oHenchy      = OBJECT_SELF;
    int nStatus         = !GetActionMode( oHenchy, ACTION_MODE_STEALTH );

    return( nStatus );

}
