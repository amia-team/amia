/*  ds_check_quest_3

--------
Verbatim
--------
Generic quest tester.
Selects on NPC tag.
Returns TRUE if condition is met.

---------
Changelog
---------

    Date    Name        Reason
    ------------------------------------------------------------------
    062406  Disco       Script header started
  20071103  Disco       Now uses databased PCKEY functions
    ------------------------------------------------------------------


*/
//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"


//-------------------------------------------------------------------------------
//starting conditional
//-------------------------------------------------------------------------------

int StartingConditional(){

    //variables
    object oPC           = GetPCSpeaker();
    string sConvoNPCTag  = GetTag( OBJECT_SELF );

    //sometimes an NPC reacts to SpeakString from another NPC
    if( !GetIsPC( oPC ) ){

        return FALSE;
    }

    if( sConvoNPCTag == "ds_fisherman" ){

        // show option if quest is not set or items aren't collected

        if ( GetPCKEYValue( oPC, "ds_quest_1" ) < 2 ){

            return FALSE;
        }
    }

    return TRUE;
}

