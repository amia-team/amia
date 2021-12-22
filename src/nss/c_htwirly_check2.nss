/*  NPC :: Harold Twirly : Conversation : Check 1

    --------
    Verbatim
    --------
    This will convo option won't run if the player has rolled already.

    ---------
    Changelog
    ---------
    Date        Name        Reason
    ----------------------------------------------------------------------------
    020307      kfw         Initial.
    ----------------------------------------------------------------------------
*/

// Constants.
const string ROLLED     = "TwirlyRolled";

int StartingConditional( ){

    // Variables.
    object oPC          = GetPCSpeaker( );
    int nRolled         = GetLocalInt( oPC, ROLLED );


    // Return the opposite of the rolling status.
    return( !nRolled );

}
