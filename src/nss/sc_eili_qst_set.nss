//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  sc_eili_qst_set
//group:   eili quest
//used as: check script
//date:    nov 03 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"
#include "inc_ds_actions"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = GetPCSpeaker();
    string sNPC     = GetTag( OBJECT_SELF );
    int i;
    int nQuest      = GetPCKEYValue( oPC, "ds_quest_6" );

    if ( nQuest == 0 && GetHitDice( oPC ) > 3  ){

        SpeakString( "I only have tasks for freshly arrived people." );
        return;
    }

    clean_vars( oPC, 4 );

    SetLocalString( oPC, "ds_action", "sc_eili_qst_act" );

    if ( nQuest == 0 &&  sNPC == "bh_ds_elrienia" ){

        //quest not set
        SetLocalInt( oPC, "ds_check_1", 1 );
    }
    else if ( nQuest == 1 &&  sNPC == "bh_ds_elrienia" ){

        //quest not set
        SetLocalInt( oPC, "ds_check_1", 1 );
    }
    else if ( nQuest == 2 &&  sNPC == "bh_ds_elrienia" ){

        //start of sword part
        SetLocalInt( oPC, "ds_check_2", 1 );
    }
    else if (  nQuest == 3 &&  sNPC == "nx_ds_semlion" ) {

        //middle bit of sword part
        SetLocalInt( oPC, "ds_check_3", 1 );
    }
    else if (  nQuest == 4 &&  sNPC == "bh_ds_elrienia" ) {

        //end of sword part
        SetLocalInt( oPC, "ds_check_4", 1 );
    }
    else if (  nQuest == 5 &&  sNPC == "bh_ds_elrienia" ) {

        //start of deliveries
        SetLocalInt( oPC, "ds_check_5", 1 );
    }
    else if (  nQuest == 6 && sNPC == "bh_ds_hannah" ) {

        //delivering herbs
        SetLocalInt( oPC, "ds_check_6", 1 );
    }
    else if (  nQuest == 7 && sNPC == "bd_ds_bemmi" ) {

        //delivering eggs
        SetLocalInt( oPC, "ds_check_7", 1 );
    }
    else if (  nQuest == 8 ) {

        //generic 'hello'
        SetLocalInt( oPC, "ds_check_8", 1 );
    }
    else if (  nQuest == 9 ) {

        //generic 'hello'
        SetLocalInt( oPC, "ds_check_9", 1 );
    }
}



//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


