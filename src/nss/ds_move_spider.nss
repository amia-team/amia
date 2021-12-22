/*  ds_move_spider

--------
Verbatim
--------
Moves spider to a nearby waypoint and blocks script for 5 mins.

---------
Changelog
---------

Date        Name        Reason
------------------------------------------------------------------
2007-02-01  Disco       Start of header
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    if ( GetIsBlocked( OBJECT_SELF ) < 1 ){

        SetBlockTime( OBJECT_SELF, 5, 0 );

        ActionMoveToObject( GetNearestObjectByTag( "ds_ud_spider_wp", OBJECT_SELF, ( 1 + d2() ) ), FALSE, 0.0 );

    }

}
