/*  Merchant :: Panthalo :: Requirements :: 300K GP.

    --------
    Verbatim
    --------
    Panthalo requires the speaker to have 300K GP.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    070606  kfw         Initial release.
  20080118  disco       Simplified
    ----------------------------------------------------------------------------

*/

int StartingConditional( ){

    if  ( GetGold( GetPCSpeaker( ) ) >= 300000 ){

        return TRUE;
    }
    else{

        return FALSE;
    }
}
