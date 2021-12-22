/*  ds_shops

--------
Verbatim
--------
Generic shop opener with greeting

---------
Changelog
---------

Date       Name        Reason
------------------------------------------------------------------
08-29-06   Disco       Start of header
05/01/2007 disco       Shop Injection
2007/07/30 disco       Now works for PLCs too, use in OnUsed. Removed GetNearestObhect calls.
20071118   Disco       Now using inc_ds_records
2008-01-30 Disco       Rewritten and libbed.
------------------------------------------------------------------

*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_shops"


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------

void main(){

    //check if there's a valid PC

    object oPC = GetPCSpeaker();

    if ( oPC == OBJECT_INVALID ){

        oPC = GetLastUsedBy();
    }

    if ( oPC == OBJECT_INVALID ){

        return;
    }

    else OpenRacialStore( oPC, OBJECT_SELF, GetTag( OBJECT_SELF ) );


    //AssignCommand(OBJECT_SELF, SpeakString("Have a look!"));

}



