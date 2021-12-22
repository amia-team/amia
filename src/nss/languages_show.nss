/*
languages_show

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This script shows the languages a character has

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
06-29-2006      disco      Start of header
    20071118  Disco       Using inc_ds_records now
    ------------------------------------------------------------------
*/

//includes
#include "inc_ds_records"


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){


    // Variables
    object oPC              = GetLocalObject( OBJECT_SELF, "lan_target");
    int i;

    for ( i=1; i<24; ++i ){

        if ( GetPCKEYValue( oPC, "lan_"+IntToString(i) ) ) {

            SetLocalInt( oPC, "ds_check_"+IntToString(i), 1 );

        }
        else {

            SetLocalInt( oPC, "ds_check_"+IntToString(i), 0 );

        }
    }


}
