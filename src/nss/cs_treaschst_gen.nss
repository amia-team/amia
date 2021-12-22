// New Amia Spawn System: Treasure Chest: Generate Vault Loot based on average party CR

// includes
#include "inc_ds_ondeath"

void main(){

    // vars
    object oChest=OBJECT_SELF;

    // unspawned ?
    if ( GetLocalInt( oChest, "spawned")==0 ){

        // generate random treasure
        //CD_GenerateTreasure(oChest);
        GenerateLoot( oChest, 1, 1 );


        // set treasure chest's status to spawned
        SetLocalInt( oChest, "spawned", 1 );
    }

    return;
}
