/*  Amia :: Treasure Chest :: OnClose :: Purge [Self]

    --------
    Verbatim
    --------
    This scriptfile purges itself, treasure chest.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080906  kfw         Initial Release.
    ----------------------------------------------------------------------------

*/


void main( ){

    // Variables.
    object oTreasureChest       = OBJECT_SELF;

    // Not item(s) left in the treasure chest, purge it.
    if( !GetIsObjectValid( GetFirstItemInInventory( oTreasureChest ) ) )
        DestroyObject( oTreasureChest );

    return;

}
