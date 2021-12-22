/*
ds_quests_res

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This is a generic quest solver

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
06-25-2006      disco      Start of header
10-20-2006      disco      Fixes
10-31-2006      disco      Tracer
11-10-2006      disco      Moved tracer
20071103        Disco      Now uses databased PCKEY functions
------------------------------------------------
*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------

//crafts armour for fisherman quest
void ds_craft_anchor( object oPC );

//crafts pitch for fisherman quest
void ds_craft_pitch( object oPC );


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    //variables
    object oPC          = GetPCSpeaker();
    string sConvoNPCTag = GetTag( OBJECT_SELF );

    //sometimes an NPC reacts to SpeakString from another NPC
    if( GetIsPC( oPC ) == FALSE ){

        return;
    }

    if ( sConvoNPCTag == "ds_fisherman" ){

        if ( GetPCKEYValue( oPC, "ds_quest_1" ) == 1 ){

            //take all items
            ds_take_item( oPC, "ds_anchor" );
            ds_take_item( oPC, "ds_pitch" );
            ds_take_item( oPC, "x2_it_amt_spikes" );
            ds_take_item( oPC, "x2_it_cmat_cloth" );
            ds_take_item( oPC, "NW_WBLHL001" );
            ds_take_item( oPC, "x2_it_cmat_elmw" );
            ds_take_item( oPC, "rope" );

            //update quest
            ds_quest( oPC, "ds_quest_1", 2 );

            GiveCorrectedXP( oPC, 1000, "Quest", 0 );
        }
        else {

            //get the ship ready and transport the players
            DelayCommand( 1.0, ds_transport_party( oPC, "coast7_to_pirates" ) );

            //update quest
            if ( GetPCKEYValue( oPC, "ds_quest_1" ) == 2 ){

                ds_quest( oPC, "ds_quest_1", 3 );
            }
        }
    }
    else if( sConvoNPCTag == "Zeek" ){

        // Remove items from the player's inventory
        ds_take_item( oPC, "ds_golempart" );

        DelayCommand( 10.0, ds_craft_anchor( oPC ) );

    }
    else if(sConvoNPCTag=="ds_pitcher"){

        ds_take_item(oPC,"chinchonabark");

        DelayCommand(10.0, ds_craft_pitch(oPC) );

    }
    else if(sConvoNPCTag=="ds_from_pirates"){

        if ( GetPCKEYValue( oPC, "ds_quest_1" ) == 3 ){

            ds_quest( oPC, "ds_quest_1", 4 );
            GiveCorrectedXP( oPC, 1000, "Quest", 0 );
        }

        AssignCommand( oPC, ClearAllActions() );
        AssignCommand( oPC, ActionJumpToObject( GetWaypointByTag("ds_ulair"), FALSE ) );

    }
    else if(sConvoNPCTag=="ds_uhm_mayor"){

        if ( GetPCKEYValue( oPC, "ds_quest_4" ) == 3 ){

            ds_quest( oPC, "ds_quest_4", 4 );

            ds_take_item(oPC,"ds_pirate_head");

            GiveCorrectedXP( oPC, 2000, "Quest", 0 );
            GiveGoldToCreature( oPC, 1000 );
        }

    }
    else if ( sConvoNPCTag == "ds_test_jumper" ){

        //transport the players
        DelayCommand( 1.0, ds_transport_party( oPC, "ds_test_jump" ) );
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


void ds_craft_anchor( object oPC ){

    //close quest
    if ( GetPCKEYValue( oPC, "ds_quest_2" ) == 1 ){

        ds_quest( oPC, "ds_quest_2", 2 );

        GiveCorrectedXP( oPC, 500, "Quest", 0 );
    }

    //create a bucket of pitch on the PC
    ds_create_item( "ds_anchor", oPC, 1 );

    //message them
    SpeakString( "There ye are!" );
}

void ds_craft_pitch( object oPC ){

    //close quest
    if ( GetPCKEYValue( oPC, "ds_quest_3" ) == 1 ){

        ds_quest( oPC, "ds_quest_3", 2 );

        GiveCorrectedXP( oPC, 500, "Quest", 0 );
    }

    //create a bucket of pitch on the PC
    ds_create_item( "ds_pitch", oPC, 1 );

    //message them
    SpeakString( "A bucket of Pitch!" );
}

