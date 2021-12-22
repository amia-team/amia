/*  Henchy Search Mode On

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032506  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Toggle henchy's Search skill on.

*/

/* Includes */
#include "NW_I0_GENERIC"

void main( ){

    // Variables
    object oHenchy      = OBJECT_SELF;

    SetActionMode( oHenchy, ACTION_MODE_DETECT, TRUE );

    return;

}
