//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_qst"
#include "inc_ds_actions"


void main(){

    object oPC      = GetLastSpeaker();
    int nNextState  = qst_check( oPC );

    if ( nNextState > 0 ){

        qst_update( oPC );
    }

}

