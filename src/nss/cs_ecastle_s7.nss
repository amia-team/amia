// Electric Castle :: Respawnable Alignment Keys

/* Prototypes */

// Spawns a key with the parameter blueprint, at the designated origin.
void SpawnKeyAndClearOriginsInventory( object oOrigin, string szKeyResRef );

void main( ){

    // Variables
    object oChest           = OBJECT_SELF;
    string szKeyResRef      = GetLocalString( oChest, "cs_tag" );

    // Refresh spawn status [ 5 minutes ]
    if( GetLocalInt( oChest, "spawned" ) )
        return;

    SetLocalInt( oChest, "spawned", TRUE );
    DelayCommand( 300.0, SetLocalInt( oChest, "spawned", FALSE ) );

    DelayCommand( 300.0, SpawnKeyAndClearOriginsInventory( oChest, szKeyResRef ) );

    return;

}

// Spawns a key with the parameter blueprint, at the designated origin.
void SpawnKeyAndClearOriginsInventory( object oOrigin, string szKeyResRef ){

    // Clear origin's inventory
    object oItems = GetFirstItemInInventory( oOrigin );

    while( GetIsObjectValid( oItems ) ){

        // Dix
        DestroyObject( oItems );

        oItems = GetNextItemInInventory( oOrigin );

    }

    // Spawn key
    CreateItemOnObject( szKeyResRef, oOrigin );

    return;

}
