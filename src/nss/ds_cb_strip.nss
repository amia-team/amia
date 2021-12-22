//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:   ds_cb_
//group:    player tools
//used as:  player tools
//date:     2009-07-10
//author:   Disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_cb"

void main(){

    object oPC   = GetExitingObject();
    object oArea = GetArea( oPC );

    if ( cb_HasTheBall( oPC ) ){

        //strip ball
        cb_SetBallPossession( oPC, FALSE );
    }

    if ( GetLocalInt( oPC, CB_REFEREE ) == 1 ){

        DeleteLocalInt( oPC, CB_REFEREE );
        DeleteLocalObject( oArea, CB_REFEREE );
        SendMessageToPC( oPC, "You are no longer tagged as a referee." );
    }
}
