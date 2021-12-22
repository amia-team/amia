//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_enter
//group: rentable housing
//used as:area enter script
//date: 2009-09-04
//author: disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_rental"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC    = GetEnteringObject();
    object oHouse = OBJECT_SELF;

    if ( !GetIsPC( oPC ) ){

        return;
    }

    DelayCommand( 2.0, ExploreAreaForPlayer( oHouse, oPC, TRUE ) );

    //store area visits
    db_onTransition( oPC, oHouse );

    //remove timestamp
    DeleteLocalInt( oHouse, RNT_TIMESTAMP );
}




