/*  Conversation :: 1-legged Pirate: Check : Player Has 5000 GP

    --------
    Verbatim
    --------
    This script will check if the player has enough gold (5000), to pay the 1-legged pirate.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    100506  kfw         Initial release.
    ----------------------------------------------------------------------------

*/


int StartingConditional( ){

    // Variables.
    object oPC          = GetPCSpeaker( );
    int nGold           = GetGold( );


    // Gold status.
    return( nGold >= 5000 ? TRUE : FALSE );

}
