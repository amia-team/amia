// Checks the player has 1000 GP.
int StartingConditional( ){

    if( GetGold( GetPCSpeaker( ) ) > 999 )
        return( TRUE );
    else
        return( FALSE );

}
