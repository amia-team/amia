/*
languages_dm

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This script shows bonus languages

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
    object oPC      = GetLocalObject( OBJECT_SELF, "lan_target");
    int nTaken      = 0;
    int i           = 0;

    for ( i=1; i<24; ++i ){

        nTaken   = GetPCKEYValue( oPC, "lan_"+IntToString(i) );

        if ( nTaken==0) {

            SetLocalInt(oPC, "ds_check_"+IntToString(i), 1 );

        }
        else {

            SetLocalInt(oPC, "ds_check_"+IntToString(i), 0 );

        }

    }

    SetLocalString( oPC, "ds_action", "a_c_languages" );
}
