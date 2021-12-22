// Electric Castle :: Check 7 colors again.

int StartingConditional( ){

    // Variables
    object oPC              = GetPCSpeaker( );

    // Zip through each color
    if( GetLocalInt( oPC, "cor_bluespark" ) )
        if( GetLocalInt( oPC, "cor_cyanspark" ) )
            if( GetLocalInt( oPC, "cor_greenspark" ) )
                if( GetLocalInt( oPC, "cor_orangespark" ) )
                    if( GetLocalInt( oPC, "cor_redspark" ) )
                        if( GetLocalInt( oPC, "cor_whitespark" ) )
                            if( GetLocalInt( oPC, "cor_yellowspark" ) )
                                return( TRUE );

    return( FALSE );

}
