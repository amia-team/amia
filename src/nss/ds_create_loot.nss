//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_create_loot
//group:   dm stuff
//used as: on PLC open script
//date:    aug 06 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "ds_inc_randstore"




//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oChest = OBJECT_SELF;
    int nLevel    = GetLocalInt( oChest, "level" );
    int nItems    = GetLocalInt( oChest, "items" );
    int i;

    for ( i=0; i<nItems; ++i ){

        InjectIntoChest( oChest, nLevel , nLevel, 50 );
    }
}


