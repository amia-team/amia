//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  sc_glinns_halfer
//group:   glinn's hold quest
//used as: action script
//date:    oct 27 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = OBJECT_SELF;
    int nNode       = GetLocalInt( oPC, "ds_node" );

    //SendMessageToPC( oPC, "nNode = " + IntToString( nNode ) );

    if ( nNode == 0 ){

        return;
    }
    else if  ( nNode == 20 ){

        //start quest
        ds_quest( oPC, "ds_quest_5", 1 );
    }
    else if  ( nNode == 21 ){

        //end quest
        ds_quest( oPC, "ds_quest_5", 9 );
    }
    else if  ( nNode == 23 ){

        //create soup
        CreateItemOnObject( "sc_ds_soup", oPC );

    }
    else if ( nNode > 10 && nNode < 16 ){

        //NPCs
        SetLocalInt( oPC, "ds_npc", ( nNode - 10 ) );
    }
    else if ( nNode > 0 &&  nNode < 8 ){

        //deaths
        int nNPC = GetLocalInt( oPC, "ds_npc" );

        if ( ( nNPC == 1 && nNode == 5 ) ||
             ( nNPC == 2 && nNode == 2 ) ||
             ( nNPC == 3 && nNode == 7 ) ||
             ( nNPC == 4 && nNode == 6 ) ||
             ( nNPC == 5 && nNode == 4 ) ){

            PlaySound( "gui_journaladd" );

            GiveCorrectedXP( oPC, 250, "Quest", 0 );
        }
        else{

            PlaySound( "gui_error" );
        }

        SetPCKEYValue( oPC, "ds_quest_5", ( nNPC + 1 ) );
    }
}



//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


