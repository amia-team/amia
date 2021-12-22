void main(){

    SpeakString( "Leggit!" );

    object oItem;
    int i;

    for ( i=0; i<NUM_INVENTORY_SLOTS; i++ ){

        oItem = GetItemInSlot( i, OBJECT_SELF );

        //unequip if valid
        if ( GetIsObjectValid( oItem ) ){

            DestroyObject( oItem, 0.0 );
        }
    }

    oItem = GetFirstItemInInventory( OBJECT_SELF );
    while ( GetIsObjectValid( oItem ) == TRUE ){

        DestroyObject( oItem, 0.0 );
        oItem = GetNextItemInInventory( OBJECT_SELF );
    }

    DestroyObject( OBJECT_SELF, 2.0 );
}
