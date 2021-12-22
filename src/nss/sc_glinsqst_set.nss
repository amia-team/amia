//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  sc_glinsqst_set
//group:   glinn's hold quest
//used as: action script
//date:    oct 27 2007
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
    int i;
    int nQuest      = GetPCKEYValue( oPC, "ds_quest_5" );

    clean_vars( oPC, 4 );

    SetLocalString( oPC, "ds_action", "sc_glinsqst_act" );

    if ( nQuest == 0 ){

        //quest not set
        SetLocalInt( oPC, "ds_check_10", 1 );
        SetLocalInt( oPC, "ds_check_11", 0 );
        SetLocalInt( oPC, "ds_check_12", 0 );

    }
    else if ( nQuest > 6 ){

        //quest set and completed
        SetLocalInt( oPC, "ds_check_10", 0 );
        SetLocalInt( oPC, "ds_check_11", 0 );
        SetLocalInt( oPC, "ds_check_12", 1 );

    }
    else {

        //quest set and not completed
        SetLocalInt( oPC, "ds_check_10", 0 );
        SetLocalInt( oPC, "ds_check_11", 1 );
        SetLocalInt( oPC, "ds_check_12", 0 );

        for ( i=1; i<6; ++i ){

            if ( i == nQuest  ){

                SetLocalInt( oPC, "ds_check_" + IntToString( i ), 1 );
            }
            else{

                SetLocalInt( oPC, "ds_check_" + IntToString( i ), 0 );
            }
        }
    }
}



//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


