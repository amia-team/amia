/*  Conversation Action :: Renameable Sign :: Get Player-Provided Name from Sign and Rename Sign

    --------
    Verbatim
    --------
    This script actually renames the sign with the player-provided name from the Talk channel.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    060306  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

/* Constants */
const string PLC_REF            = "rm_plc_sign";
const int PLC_LISTEN_NO         = 45624;

void main( ){

    // Variables.
    object oPC          = GetPCSpeaker( );
    object oSign        = GetNearestObjectByTag( PLC_REF, oPC );
    string szName       = "";

    // Retrieve player-provided new sign name.
    if( GetListenPatternNumber( ) == PLC_LISTEN_NO )
        szName = GetMatchedSubstring( 0 );

    // Rename the sign.
    SetName( oSign, szName );

    return;

}
