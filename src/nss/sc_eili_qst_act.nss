//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  sc_eili_qst_act
//group:   eili quest
//used as: action script
//date:    nov 03 2007
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
    else if  ( nNode == 1 ){

        //start quest
        ds_quest( oPC, "ds_quest_6", 1 );
    }
    else if  ( nNode == 2 ){

        //create order note
        ds_create_item( "bh_ds_order", oPC );
        GiveGoldToCreature( oPC, 200 );
        UpdateModuleVariable( "QuestGold", 200 );
        ds_quest( oPC, "ds_quest_6", 3 );
    }
    else if  ( nNode == 3 ){

        //take note, give hilt
        if ( ds_take_item( oPC, "bh_ds_order" ) ){

            ds_create_item( "bh_ds_hilt", oPC );
            ds_quest( oPC, "ds_quest_6", 4 );
        }
    }
    else if  ( nNode == 4 ){

        //take hilt
        if ( ds_take_item( oPC, "bh_ds_hilt" ) ){

            GiveGoldToCreature( oPC, 500 );
            GiveCorrectedXP( oPC, 250, "Quest", 0 );
            UpdateModuleVariable( "QuestGold", 500 );
            ds_quest( oPC, "ds_quest_6", 5 );
        }
    }
    else if  ( nNode == 5 ){

        //create packages
        ds_create_item( "bh_ds_herbs", oPC );
        ds_create_item( "bh_ds_eggs", oPC );
        GiveGoldToCreature( oPC, 200 );
        UpdateModuleVariable( "QuestGold", 200 );
        ds_quest( oPC, "ds_quest_6", 6 );
    }
    else if  ( nNode == 6 ){

        //take herbs
        if ( ds_take_item( oPC, "bh_ds_herbs" ) ){

            GiveGoldToCreature( oPC, 500 );
            GiveCorrectedXP( oPC, 250, "Quest", 0 );
            UpdateModuleVariable( "QuestGold", 500 );
            ds_quest( oPC, "ds_quest_6", 7 );
        }
    }
    else if  ( nNode == 7 ){

        //take eggs
        if ( ds_take_item( oPC, "bh_ds_eggs" ) ){

            GiveGoldToCreature( oPC, 500 );
            GiveCorrectedXP( oPC, 250, "Quest", 0 );
            UpdateModuleVariable( "QuestGold", 500 );
            ds_quest( oPC, "ds_quest_6", 8 );
        }
    }
    else if  ( nNode == 8 ){

        //finish
        ds_create_item( "nw_it_mpotion002", oPC, 5 );
        GiveCorrectedXP( oPC, 250, "Quest", 0 );
        ds_quest( oPC, "ds_quest_6", 9 );
    }
}



//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


