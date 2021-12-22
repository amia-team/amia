/*  Conversation Action :: Renameable Sign :: Setup Listener to Get Sign New Name

    --------
    Verbatim
    --------
    This script spawns a listener on the renameable sign itself to rename with
    the player-provided new name.

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

    // Setup listener on the renameable sign.
    SetListening( oSign, TRUE );
    SetListenPattern( oSign, "**", PLC_LISTEN_NO );

    return;

}
