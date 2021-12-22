//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_destory_loot
//group:   dm stuff
//used as: on PLC close script
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
    object oItem = GetFirstItemInInventory( oChest );

    while ( GetIsObjectValid( oItem ) == TRUE ){

        DestroyObject( oItem );

        oItem = GetNextItemInInventory( oChest );
    }
}

