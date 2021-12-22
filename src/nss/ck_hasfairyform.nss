/*  ck_hasfairyform

--------
Verbatim
--------


---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
11-10-06  Disco       Rewrote original script bacause it was bogus
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "nw_i0_tool"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

int StartingConditional()
{

    // Make sure the PC speaker has these items in their inventory
    if( HasItem(GetPCSpeaker(), "fairyform") ){

        return TRUE;
    }

    return FALSE;
}
