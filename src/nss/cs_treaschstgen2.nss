// New Amia Spawn System: Treasure Chest : Generate Vault Loot based on average party CR onto basher

// includes
#include "inc_ds_ondeath"
#include "amia_include"

void main(){

    // Variables.
    object oChest               = OBJECT_SELF;
    object oPC                  = GetLastKiller( );

    if ( d3() == 1 ){

        SafeDestroyObject( OBJECT_SELF );

        AssignCommand( oPC, SpeakString( "*Smashes the chest and its contents to bits!*" ) );
        return;

    }

    // Filter: Ungenerated loot.
    if( GetLocalInt( oChest, "spawned" ) == 0 ){

        // generate random treasure.
        GenerateLoot( oChest, 1, 1 );

        // set treasure chest's status to spawned.
        SetLocalInt( oChest, "spawned", 1 );
    }

    return;

}
