/*  Verify Henchy Open Lock Status

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032506  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Verifies the henchy can open locks and what it's status is on lock opening.

*/

/* Includes */
#include "NW_I0_GENERIC"

int StartingConditional( ){

    if( GetAssociateState( NW_ASC_RETRY_OPEN_LOCKS ) && GetLevelByClass( CLASS_TYPE_ROGUE ) )
        return( TRUE );
    else
        return( FALSE );

}
