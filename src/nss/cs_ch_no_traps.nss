/*  Verify Henchy Disable Traps Status

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032506  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Verifies the henchy can disable traps and what it's status is on disarming them.

*/

/* Includes */
#include "NW_I0_GENERIC"

int StartingConditional( ){

    if( !GetAssociateState( NW_ASC_DISARM_TRAPS ) && GetLevelByClass( CLASS_TYPE_ROGUE ) )
        return( TRUE );
    else
        return( FALSE );

}
