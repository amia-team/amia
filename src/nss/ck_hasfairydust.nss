/*  ck_hasfairydust

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

    object oPC = GetPCSpeaker();

    // Make sure the PC speaker has these items in their inventory
    if( !HasItem( oPC, "fairydust") )
        return FALSE;

    if( HasItem( oPC, "fairyform") )
        return FALSE;

    if( GetLevelByClass(CLASS_TYPE_SHIFTER, oPC ) >= 4 ){

        return TRUE;
    }

    if( GetLevelByClass(CLASS_TYPE_DRUID, oPC ) >= 12 ){

        return TRUE;
    }

    return FALSE;
}
