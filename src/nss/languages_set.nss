/*
languages_set

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This script sets automatic languages

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
06-29-2006      disco      Start of header
------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "languages_lib"


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    // Variables
    object oPC              = GetLocalObject( OBJECT_SELF, "lan_target");

    SetAutoLanguages( oPC, GetRaceIndex( oPC ));

}
