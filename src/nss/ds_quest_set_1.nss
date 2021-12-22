/*
ds_quests_set

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This is a generic quest assigner

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
06-25-2006      disco      Start of header
12-13-2006      disco      Fixed dead fisherman
20071103        Disco      Now uses databased PCKEY functions
------------------------------------------------
*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //variables
    object oPC          = GetPCSpeaker();
    string sConvoNPCTag = GetTag(OBJECT_SELF);

    //sometimes an NPC reacts to SpeakString from another NPC
    if( GetIsPC( oPC ) == FALSE && sConvoNPCTag != "ds_deadfisher" ){

        return;
    }

    if( sConvoNPCTag == "ds_fisherman" ){

        ds_quest( oPC, "ds_quest_1", 1 );
    }
    else if(sConvoNPCTag == "Zeek"){

        ds_quest( oPC, "ds_quest_2", 1 );
    }
    else if(sConvoNPCTag == "ds_pitcher"){

        ds_quest( oPC, "ds_quest_3", 1 );
    }
    else if( sConvoNPCTag == "ds_deadfisher" ){

        oPC = GetLastOpenedBy();

        if ( GetPCKEYValue( oPC, "ds_quest_4" ) == 0 ){

            ds_quest( oPC, "ds_quest_4", 1 );
        }
    }
    else if( sConvoNPCTag == "ds_uhm_mayor" ){

        ds_quest( oPC, "ds_quest_4", 2 );
    }
}


