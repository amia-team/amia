/*  ck_isshifter4

--------
Verbatim
--------


---------
Changelog
---------

Date      Name        Reason
------------------------------------------------------------------
11-10-06  Disco       Rewrote original script because it was bogus
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "nw_i0_tool"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

int StartingConditional(){

    // Exit if the PC speaker has these items in their inventory
    if( HasItem( GetPCSpeaker(), "fairyform" ) ){
        return FALSE;
    }

    //show if player has 4 shifter levels
    if(GetLevelByClass(CLASS_TYPE_SHIFTER, GetPCSpeaker()) >= 4){

        return TRUE;
    }

    //or 12 druid levels
    if(GetLevelByClass(CLASS_TYPE_DRUID, GetPCSpeaker()) >= 12){

        return TRUE;
    }

    return FALSE;
}
