// Electric Castle :: Only allow 1 of each spark within player's inventory.

int StartingConditional( ){

    // Variables
    object oBeam            = OBJECT_SELF;
    string szSparkTag       = GetLocalString( oBeam, "cs_tag" );
    object oPC              = GetPCSpeaker( );

    if( GetIsObjectValid( GetItemPossessedBy( oPC, szSparkTag ) ) )
        return( FALSE );
    else
        return( TRUE );

}
