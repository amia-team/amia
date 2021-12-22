//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  oc_ds_quest
//group:   quests
//used as: generic quest setter for ds_checks
//date:    nov 09 2007
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

    object oPC      = GetLastSpeaker();
    object oNPC     = OBJECT_SELF;
    int i;
    string sQuest   = GetLocalString( oNPC, "ds_quest" );
    int nQuest      = GetPCKEYValue( oPC, sQuest );
    //string sAction  = GetLocalString( oNPC, "ds_script" );

    SetLocalString( oPC, "ds_action", "ca_ds_quest" );
    SetLocalObject( oPC, "ds_target", oNPC );

    //cleanup
    clean_vars( oPC );

    //check 1-10 are used to show the status of the quest
    for ( i=1; i<11; ++i ){

        if ( i == nQuest  ){

            SetLocalInt( oPC, "ds_check_" + IntToString( i ), 1 );
            //SendMessageToPC( oPC, sQuest + " = " + IntToString( i ) );
        }
        else{

            SetLocalInt( oPC, "ds_check_" + IntToString( i ), 0 );
        }
    }

    //check 11-20 are used to report failure of a status swap in the action script
    for ( i=11; i<21; ++i ){

        SetLocalInt( oPC, "ds_check_" + IntToString( i ), 0 );
    }

    //21-27 checks can be used for different things
    if ( nQuest == 1 && sQuest == "ds_quest_7" ){

        if ( GetPCKEYValue( oPC, "ac_ds_inter_e" ) != 1 ){

            SetLocalInt( oPC, "ds_check_21", 1 );
            //SendMessageToPC( oPC, "ds_check_21 = 1" );
        }
    }

    if ( nQuest == 1 && sQuest == "ds_quest_8" ){

        if ( GetPCKEYValue( oPC, "ac_ds_tarcova_g" ) != 1 ){

            SetLocalInt( oPC, "ds_check_22", 1 );
        }
    }

    //start convo
    ActionStartConversation( oPC, "", TRUE, TRUE );

}
//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------



