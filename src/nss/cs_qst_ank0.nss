//-------------------------------------------------------------------------------
// updates
//-------------------------------------------------------------------------------
//20071103        Disco      Now uses databased PCKEY functions
//20080919        Disco      This is a trigger now that fixes mismatches between the old and the new quest

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"


// Ankhremun's Quest, untaken
void main(){

    // vars
    object oPC          = GetEnteringObject();

    // resolve taken status
    int nStatus1 = GetPCKEYValue( oPC, "qst_ankhremun" );
    int nStatus2 = GetPCKEYValue( oPC, "ds_quest_19" );

    if ( nStatus1 == 2 && nStatus2 == 0 ){

        ds_quest( oPC, "ds_quest_19", 4 );
    }
    else if ( nStatus1 == 1 ){

        ds_quest( oPC, "qst_ankhremun", 3 );
    }
}
