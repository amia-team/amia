// Permit only the Master to speak to her summon.
int StartingConditional( ){

    // Variables
    object oMaster      = GetMaster( );
    object oPC          = GetPCSpeaker( );

    // Verify master status
    if( oMaster == oPC )
        return( TRUE );
    else
        return( FALSE );

}
