//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_qst_act
//group:   quest
//used as: action script
//date:    aug 02 2008
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_qst"
#include "inc_ds_actions"
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

     object oPC = GetEnteringObject();

    if ( GetIsPC( oPC ) || GetIsDM( oPC ) ){

//block
    if ( GetIsBlocked( OBJECT_SELF ) > 0 ){

        SendMessageToPC( oPC, "*There are signs of recent fighting here...*" );

        return;
    }

    int nMin = GetLocalInt( OBJECT_SELF, "block_min" );
    int nSec = GetLocalInt( OBJECT_SELF, "block_sec" );
    SetBlockTime( OBJECT_SELF, nMin, nSec );

    //set the triggering PC as local object on trigger to avoid duplicate qst_check
    //if we use qst_resolve_party instead of qst_update
    SetLocalObject( OBJECT_SELF, "Triggerer", oPC );

        int nNextState = qst_check( oPC );

        if ( nNextState > 0 ){

            if( GetLocalInt( OBJECT_SELF, "WholeParty" ) != 0 )
            {
                qst_resolve_party( oPC, nNextState );
            }
            else
            {
                qst_update( oPC );
            }
        }
    }
}
