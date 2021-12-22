/*  NPC :: Harold Twirly : Conversation : Check 1

    --------
    Verbatim
    --------
    This will roll a perform skill check.

    ---------
    Changelog
    ---------
    Date        Name        Reason
    ----------------------------------------------------------------------------
    012607      kfw         Initial.
    ----------------------------------------------------------------------------
*/

// Constants.
const string ROLLED     = "TwirlyRolled";

int StartingConditional( ){

    // Variables.
    object oPC          = GetPCSpeaker( );
    int nRolled         = GetLocalInt( oPC, ROLLED );
    int nSkill          = GetSkillRank( SKILL_PERFORM, oPC, TRUE );
    int nLevel          = GetHitDice( oPC );

    int nDC             = ( ( nSkill/nLevel ) * 20 );


    // Make a perform check.
    if( d20() < nDC ){
        //Success.
        return( FALSE );
    }
    else{

        // Failed, don't allow another check.
        SetLocalInt( oPC, ROLLED, TRUE );

        // Refresh it in 5 minutes time.
        DelayCommand( 300.0, SetLocalInt( oPC, ROLLED, FALSE ) );

        return( TRUE );
    }

}
