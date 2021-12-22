/*  Verify Henchy Search Status

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032506  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Verifies the henchy's Search status

*/

/* Includes */
#include "NW_I0_GENERIC"

int StartingConditional( ){

    // Variables
    object oHenchy      = OBJECT_SELF;
    int nStatus         = !GetActionMode( oHenchy, ACTION_MODE_DETECT );

    return( nStatus );

}
