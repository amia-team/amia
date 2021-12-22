/*  Henchy Stealth Mode On

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032506  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Toggle henchy's Stealth skill on.

*/

/* Includes */
#include "NW_I0_GENERIC"

void main( ){

    // Variables
    object oHenchy      = OBJECT_SELF;

    DelayCommand( 1.0, SetActionMode( oHenchy, ACTION_MODE_STEALTH, TRUE ) );

    return;

}
