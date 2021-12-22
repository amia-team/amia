// Checks the player has 10000 GP.
int StartingConditional( ){

    if( GetGold( GetPCSpeaker( ) ) > 9999 )
        return( TRUE );
    else
        return( FALSE );

}
