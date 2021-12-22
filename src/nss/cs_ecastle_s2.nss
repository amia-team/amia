// Electric Castle :: Spawns a unique color spark in the player's inventory

void main( ){

    // Variables
    object oBeam            = OBJECT_SELF;
    string szSparkTag       = GetLocalString( oBeam, "cs_tag" );
    object oPC              = GetPCSpeaker( );

    // Spawn a spark in the player's inventory.
    CreateItemOnObject( szSparkTag, oPC );

    return;

}
