/*
tha_quests_set

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This is a universal quest assigner

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
06-21-2006      disco      Check if the Priest is still in convo with a PC
20071103        Disco      Now uses databased PCKEY functions
------------------------------------------------
*/
#include "inc_ds_records"



//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //variables
    object oPC          = GetPCSpeaker();
    string sConvoNPCTag = GetTag(OBJECT_SELF);

    //sometimes an NPC reacts to SpeakString from another NPC
    if(GetIsPC(oPC) == FALSE){

        return;
    }

    if ( sConvoNPCTag == "tha_highpriest"){

        if ( GetPCKEYValue( oPC, "tha_quest1" ) == 2 ){

            //enables bread quest
            ds_quest( oPC, "tha_quest2", 1 );
            ds_create_item( "tha_bread", oPC );
        }
        else{

            //enables nuts, ice, flour quest
            ds_quest( oPC, "tha_quest1", 1 );
        }
    }
     //Thordstein Buildings
     else if ( sConvoNPCTag == "tha_gudmund"){

        ds_quest( oPC, "tha_quest3", 1 );
        ds_create_item( "tha_book", oPC );
    }
    //Dragon Lair
    else if ( sConvoNPCTag == "tha_dragon"){

        ds_quest( oPC, "tha_quest4", 1 );
    }
    //Howness Gate Street
    else if ( sConvoNPCTag == "tha_hrolf"){

        ds_quest( oPC, "tha_quest5", 1 );
    }
    //Ostman in the Thirsty Marauder
    else if ( sConvoNPCTag == "tha_ostman"){

        ds_create_item( "tha_notebook", oPC );
        ds_quest( oPC, "tha_quest6", 1 );
    }
    //Thirmir in the Thordstein Buildings
    else if ( sConvoNPCTag == "tha_thirmir"){

        ds_quest( oPC, "tha_quest7", 1 );
    }
}
