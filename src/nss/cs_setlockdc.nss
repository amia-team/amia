// Sets up the action subject for dynamic DC Locks on Treasure chests.

void main( ){

    // Variables
    object oChest       = OBJECT_SELF;
    int nLockDC         = GetLocalInt( oChest, "CS_TREASURE_DC" );

    // Set the lock DC dynamically.
    SetLockUnlockDC( oChest, nLockDC );

    return;

}
