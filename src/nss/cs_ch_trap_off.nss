/*  Toggle Henchy Disable Trap Off

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032506  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Toggles the henchy Disable Trap skill off.

*/

/* Includes */
#include "NW_I0_GENERIC"

void main( ){

    SetAssociateState( NW_ASC_DISARM_TRAPS, FALSE );

}
