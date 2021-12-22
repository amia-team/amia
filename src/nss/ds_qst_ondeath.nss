//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_qst"
#include "inc_ds_actions"


void main(){

    object oPC      = GetLastKiller();
    string sCorpse  =  GetLocalString( OBJECT_SELF, "q_corpse" );

    if ( sCorpse != "" ){

        CreateObject( OBJECT_TYPE_PLACEABLE, sCorpse, GetLocation( OBJECT_SELF ) );
    }
    else{

        int nNextState = qst_check( oPC );
        qst_resolve_party( oPC, nNextState );
    }
}

