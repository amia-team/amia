//::///////////////////////////////////////////////
//:: FileName: onuse_dirtyoneye
//:://////////////////////////////////////////////
/*

    Used for a dirty one eye game.
    Things needed:

    NPC with the tag: "DIRTY_ONE_EYE_DEALER"

    6 plates with the tags: "DICE_PLATE_" + numbers 1-6
    (example DICE_PLATE_1, DICE_PLATE_2, DICE_PLATE_3, etc.)

    This script in the OnUsedEvent

    When first used, the script Dealer will call out to all local players
    that a game will start in 30 seconds.

    After the first shout, players have 30 seconds to use a plate to
    initialize it so that the script knows which plate is valid.

    The dealer will tell each player what to do at that point.

    If a player rolls a 1 or goes over 16, they lose.  The player can choose
    to hold after round 1.  There is a 6 second window to do this.

    The script will check for the highest score under 16 after round 3.  If there
    is a tie, all players who are still in will start from the beginning

*/
//:://////////////////////////////////////////////
//:: Created By: Dagesh
//:: Created On: 8/2009
//:: Slight Edits By: Hexx
//:: Edited On 12/2009
//:: Fixed minor timing issues. tweaked speak strings
//:://////////////////////////////////////////////


#include "x3_inc_string"

//True if over 16 or rolls a 1
int DirtyOneEye( int nD8, int nCurrentPlate, int nOldRoll, object oUser, object oDealer );
//The major function of this script
//It will find the next valid player and will
//continue the game for each following round
//after round 2, it will find a winner.
//If there is a tie, each valid player will have their
//score start over
void PlateNextUser( object oDealer );
//Set all plates to certain values
void SetPlates( string sVariableName, int nVariableNumber );
//Change those plates that meet nCheckState to nSetToState
void CheckPlateState( int nCheckState, int nSetToState );

void CleanVariables( object oDealer, int bTieBreaker = FALSE );

void main()
{


    //ugly hack, but it keeps everything in one script
    if ( GetTag( OBJECT_SELF ) == "DIRTY_ONE_EYE_DEALER" ){

        CleanVariables( OBJECT_SELF );

        return;
    }

    object oPC = GetLastUsedBy();

    object oUser = GetLocalObject( OBJECT_SELF, "PLATE_USER" );

    object oDealer = GetNearestObjectByTag( "DIRTY_ONE_EYE_DEALER" );

    if( GetIsObjectValid( oUser ) && oPC != oUser )
    {// Wrong user

        FloatingTextStringOnCreature( "Please do not foul with another player's dice plate!", oPC );

        return;

    }// Wrong user

    if( GetLocalInt( OBJECT_SELF, "STAY_CHECK" ) == 1 &&
        oPC == oUser )
    {// if oUser wants to stay

        string sPlate = GetStringRight( GetTag( OBJECT_SELF ), 1 );

        int nDiceTotal = GetLocalInt( oDealer, "PLATE_SCORE_" + sPlate );

        SetLocalInt( OBJECT_SELF, "PLATE_STATE", 5 );

        string sSpeak = StringToRGBString( IntToString( nDiceTotal ), "070" );

        AssignCommand( OBJECT_SELF, SpeakString( "Staying at " + sSpeak ) );

        DeleteLocalInt( OBJECT_SELF, "STAY_CHECK" );

        return;

    }// if oUser wants to stay

    int nPlateState = GetLocalInt( OBJECT_SELF, "PLATE_STATE" );

    switch( nPlateState ){

        case 1:
        {// Ready for players

            SetLocalInt( OBJECT_SELF, "PLATE_STATE", 3 );

            SetLocalObject( OBJECT_SELF, "PLATE_USER", oPC );

            FloatingTextStringOnCreature( "This dice plate is ready to play!\nWait for dealer's instructions.", oPC, FALSE );

            break;

        }// Ready for players
        case 2:
        {// Bets off on this plate

            FloatingTextStringOnCreature( "This plate will be ready next game.", oPC, FALSE );

            break;

        }// Bets off on this plate
        case 3:
        {// Round one

            int nRound = GetLocalInt( oDealer, "DIRTY_ONE_EYE_ROUND" );

            if( nRound <= 0 ){

                FloatingTextStringOnCreature( "Wait for instructions from the dealer.", oPC, FALSE );

            }
            else{

                int nCurrentPlate = GetLocalInt( oDealer, "CURRENT_PLATE" );

                if( StringToInt( GetStringRight( GetTag( OBJECT_SELF ), 1 ) ) == nCurrentPlate )
                {// Matching current plate

                    int nD8 = d8();

                    string sSpeak = StringToRGBString( "D8: " + IntToString( nD8 ), "070" );

                    AssignCommand( oUser, ClearAllActions() );

                    AssignCommand( oUser, PlayAnimation( ANIMATION_LOOPING_GET_MID, 1.0, 1.0 ) );

                    DelayCommand( 1.0, AssignCommand( OBJECT_SELF, SpeakString( sSpeak ) ) );

                    if( DirtyOneEye( nD8, nCurrentPlate, 0, oUser, oDealer ) ){

                        DeleteLocalObject( OBJECT_SELF, "PLATE_USER" );

                        SetLocalInt( OBJECT_SELF, "PLATE_STATE", 2 );

                    }

                    //SetLocalInt( oDealer, ObjectToString( oUser ), nD8 );

                    SetLocalInt( oDealer, "PLATE_SCORE_" + IntToString( nCurrentPlate ), nD8 );

                    DelayCommand( 5.0, PlateNextUser( oDealer ) );

                }// Matching current plate
                else
                {// Using too early

                    FloatingTextStringOnCreature( "Wait for instructions from the dealer.", oPC, FALSE );

                }// Using too early

            }

            break;

        }// Round one
        case 4:
        {// All other rounds

            int nCurrentPlate = GetLocalInt( oDealer, "CURRENT_PLATE" );

            if( StringToInt( GetStringRight( GetTag( OBJECT_SELF ), 1 ) ) == nCurrentPlate )
            {// Matching current plate

                string sPlate = GetStringRight( GetTag( OBJECT_SELF ), 1 );

                int nOldRoll = GetLocalInt( oDealer, "PLATE_SCORE_" + sPlate );

                int nD8 = d8();

                int nTotalRoll = nOldRoll + nD8;

                string sSpeak = StringToRGBString( "D8: " + IntToString( nD8 ), "070" );

                AssignCommand( oUser, ClearAllActions() );

                AssignCommand( oUser, PlayAnimation( ANIMATION_LOOPING_GET_MID, 1.0, 1.0 ) );

                DelayCommand( 1.0, AssignCommand( OBJECT_SELF, SpeakString( sSpeak ) ) );

                if( DirtyOneEye( nD8, nCurrentPlate, nOldRoll, oUser, oDealer ) ){

                    DeleteLocalObject( OBJECT_SELF, "PLATE_USER" );

                    SetLocalInt( OBJECT_SELF, "PLATE_STATE", 2 );

                }
                else{

                    string sSpeakB = StringToRGBString( IntToString( nTotalRoll ), "070" );

                    DelayCommand( 1.8, AssignCommand( oDealer, SpeakString( "Total dice roll is " + sSpeakB ) ) );

                    DelayCommand( 5.0, AssignCommand( oDealer, SpeakString( "If you want to stay, use your plate within the next 15 seconds." ) ) );

                    SetLocalInt( OBJECT_SELF, "STAY_CHECK", 1 );

                    DelayCommand( 15.0, DeleteLocalInt( OBJECT_SELF, "STAY_CHECK" ) );

                }

                SetLocalInt( oDealer, "PLATE_SCORE_" + IntToString( nCurrentPlate ), nTotalRoll );

                DelayCommand( 8.0, PlateNextUser( oDealer ) );

            }// Matching current plate
            else
            {// Using too early

                FloatingTextStringOnCreature( "Wait for instructions from the dealer.", oPC, FALSE );

            }// Using too early

            break;

        }// All other rounds
        case 5:
        {// Holding

            string sPlate = GetStringRight( GetTag( OBJECT_SELF ), 1 );

            int nDiceTotal = GetLocalInt( oDealer, "PLATE_SCORE_" + sPlate );

            FloatingTextStringOnCreature( "You are currently holding at " + IntToString( nDiceTotal ) + ".", oPC, FALSE );

            break;

        }// Holding

        default:
        {// When player first uses

            //Have the dealer call out for players
            AssignCommand( oDealer, SpeakString( "Next game starting in 30 seconds!\nAll player's grab a dice plate\nMake sure to agree on the bet!" ) );

            SetPlates( "PLATE_STATE", 1 );

            DelayCommand( 29.9, CheckPlateState( 1, 2 ) );

            DelayCommand( 30.0, AssignCommand( oDealer, SpeakString( "All empty dice plates are closed! We are ready to play!" ) ) );

            DelayCommand( 30.0, SetLocalInt( oDealer, "DIRTY_ONE_EYE_ROUND", 1 ) );

            DelayCommand( 30.1, PlateNextUser( oDealer ) );

        }// When player first uses

        break;

    }

}

void SetPlates( string sVariableName, int nVariableNumber )
{

    object oPlate = OBJECT_SELF;

    SetLocalInt( oPlate, sVariableName, nVariableNumber );

    int nCheck;

    int nLoop;
    //Set the plate's to ready mode
    for( nLoop = 1; nLoop <= 6; nLoop++ ){

        oPlate = GetNearestObjectByTag( "DICE_PLATE_" + IntToString( nLoop ) );

        SetLocalInt( oPlate, sVariableName, nVariableNumber );

    }

}

void CheckPlateState( int nCheckState, int nSetToState )
{

    object oPlate;

    int nLoop, nPlateState;

    string sTag;

    for( nLoop = 1; nLoop <= 6; nLoop++ ){

        sTag = "DICE_PLATE_" + IntToString( nLoop );

        if( GetTag( OBJECT_SELF ) == sTag ){

            oPlate = OBJECT_SELF;

        }
        else{

            oPlate = GetNearestObjectByTag( sTag );

        }

        nPlateState = GetLocalInt( oPlate, "PLATE_STATE" );

        if( nPlateState == nCheckState ){

            SetLocalInt( oPlate, "PLATE_STATE", nSetToState );

        }

    }

}

void ResetAllScores( object oDealer )
{

    int nLoop = 1;

    for( nLoop; nLoop <= 7; nLoop++ ){

        DeleteLocalInt( oDealer, "PLATE_SCORE_" + IntToString( nLoop ) );

    }

}

void CleanVariables( object oDealer, int bTieBreaker = FALSE )
{

    object oPlate;

    int nCheck;

    string sTag;

    int nLoop = 1;
    //Set the plate's to ready mode
    for( nLoop; nLoop <= 6; nLoop++ ){

        sTag = "DICE_PLATE_" + IntToString( nLoop );

        if( GetTag( OBJECT_SELF ) == sTag ){

            oPlate = OBJECT_SELF;

        }
        else{

            oPlate = GetNearestObjectByTag( sTag );

        }

        if( bTieBreaker == FALSE ){

            DeleteLocalInt( oPlate, "PLATE_STATE" );

            DeleteLocalObject( oPlate, "PLATE_USER" );

            DeleteLocalInt( oDealer, "DIRTY_ONE_EYE_ROUND" );

        }
        else{

            CheckPlateState( 4, 3 );

            CheckPlateState( 5, 3 );

            SetLocalInt( oDealer, "DIRTY_ONE_EYE_ROUND", 1 );

        }

    }

    DeleteLocalInt( oDealer, "CURRENT_PLATE" );

    ResetAllScores( oDealer );

}

int GetMaxValidPlayers()
{

    object oUser, oPlate;

    string sTag;

    int nMaxPlayers = 0;

    int nLoop = 1;

    for( nLoop; nLoop <= 7; nLoop++ ){

        sTag = "DICE_PLATE_" + IntToString( nLoop );

        if( GetTag( OBJECT_SELF ) == sTag ){

            oPlate = OBJECT_SELF;

        }
        else{

            oPlate = GetNearestObjectByTag( sTag );

        }

        oUser = GetLocalObject( oPlate, "PLATE_USER" );

        if( GetIsObjectValid( oUser ) )
        {// Valid User

            nMaxPlayers = nMaxPlayers + 1;

        }// Valid User

    }

    return nMaxPlayers;

}

int GetHighestScorer( object oDealer )
{

    object oUser, oPlate;

    string sTag;

    int nDiceTotal, nCurrentHigh, nTopPlate;

    int nLoop = 1;

    for( nLoop; nLoop <= 7; nLoop++ ){

        sTag = "DICE_PLATE_" + IntToString( nLoop );

        if( GetTag( OBJECT_SELF ) == sTag ){

            oPlate = OBJECT_SELF;

        }
        else{

            oPlate = GetNearestObjectByTag( sTag );

        }

        oUser = GetLocalObject( oPlate, "PLATE_USER" );

        if( GetIsObjectValid( oUser ) )
        {// Valid User

            nDiceTotal = GetLocalInt( oDealer, "PLATE_SCORE_" + IntToString( nLoop ) );

            if( nDiceTotal > nCurrentHigh ){

                nCurrentHigh = nDiceTotal;

                nTopPlate = nLoop;

            }
            else if( nDiceTotal == nCurrentHigh ){// tie

                nTopPlate = -1;

            }// tie

        }// Valid User

    }

    return nTopPlate;

}

void PlateNextUser( object oDealer )
{

    int nCurrentPlate = GetLocalInt( oDealer, "CURRENT_PLATE" );

    int nRound = GetLocalInt( oDealer, "DIRTY_ONE_EYE_ROUND" );

    object oPlate, oUser;

    string sTag;

    int nLoop = 1;

    int nCurrentPlateA;

    for( nLoop; nLoop <= 7; nLoop++ ){

        if( !GetIsObjectValid( oUser ) )
        {// No Valid User

            nCurrentPlateA = nCurrentPlate + nLoop;

            sTag = "DICE_PLATE_" + IntToString( nCurrentPlateA );

            if( GetTag( OBJECT_SELF ) == sTag ){

                oPlate = OBJECT_SELF;

            }
            else{

                oPlate = GetNearestObjectByTag( sTag );

            }

            oUser = GetLocalObject( oPlate, "PLATE_USER" );

        }// No Valid User
        else
        {// Valid User

            break;

        }// Valid User

    }

    if( nLoop > 7 )
    {// Finished round, start next one

        int nValidPlayersLeft = GetMaxValidPlayers();

        if( nValidPlayersLeft > 1 )
        {// More than one player left playing

            if( nRound > 2 )
            {// Past Round 2

                //Find the highest scorer below 16
                int nWinner = GetHighestScorer( oDealer );

                if( nWinner == -1 )
                {// Tie

                    DelayCommand( 2.0, AssignCommand( oDealer, SpeakString( "Tie breaker!" ) ) );

                    DelayCommand( 2.1, CleanVariables( oDealer, TRUE ) );

                    DelayCommand( 2.3, PlateNextUser( oDealer ) );

                    return;

                }// Tie

                else
                {// Winner

                    DelayCommand( 1.9, CleanVariables( oDealer ) );

                    DelayCommand( 2.0, ResetAllScores( oDealer ) );

                    DelayCommand( 2.1, AssignCommand( oDealer, SpeakString( "Plate " + IntToString( nWinner ) +" is our winner!\nHand that gold over!" ) ) );

                    return;

                }// Winner

            }// Past Round 2

            else
            {// Round 1 or 2

                DelayCommand( 2.0, AssignCommand( oDealer, SpeakString( "Next Round!" ) ) );

                DelayCommand( 2.1, CheckPlateState( 3, 4 ) );

                DelayCommand( 2.0, SetLocalInt( oDealer, "CURRENT_PLATE", 0 ) );

                DelayCommand( 2.3, PlateNextUser( oDealer ) );

                SetLocalInt( oDealer, "DIRTY_ONE_EYE_ROUND", nRound + 1 );

            }// Round 1 or 2

        }// More than one player left playing

        else if( nValidPlayersLeft == 1 )
        {// Only one player left.  All others dropped out

            int nWinner = GetHighestScorer( oDealer );

            DelayCommand( 1.9, CleanVariables( oDealer ) );

            DelayCommand( 2.0, AssignCommand( oDealer, SpeakString( "Plate " + IntToString( nWinner ) +" is our winner!\nHand that gold over!" ) ) );

        }// Only one player left.  All others dropped out

        else
        {// No players left, everyone dropped out

            DelayCommand( 1.9, CleanVariables( oDealer ) );

            DelayCommand( 2.0, AssignCommand( oDealer, SpeakString( "Game over!\nNo gold changes hands!" ) ) );

        }// No players left, everyone dropped out

    }// Finished round, start next one

    else
    {// Continuing Round

        int nState = GetLocalInt( oPlate, "PLATE_STATE" );

        if( nState == 5 )
        {// If holding

            int nDiceTotal = GetLocalInt( oDealer, "PLATE_SCORE_" + IntToString( nCurrentPlateA ) );

            string sSpeak = StringToRGBString( IntToString( nDiceTotal ), "070" );

            DelayCommand( 1.0, AssignCommand( oPlate, SpeakString( "Staying at " + sSpeak ) ) );

            SetLocalInt( oDealer, "CURRENT_PLATE", nCurrentPlateA + 1 );

            DelayCommand( 2.0, PlateNextUser( oDealer ) );

        }// If holding

        else
        {// Not holding

            DelayCommand( 2.0, AssignCommand( oDealer, SpeakString( "Plate " + IntToString( nCurrentPlateA ) + " roll your dice!" ) ) );

            DelayCommand( 2.0, FloatingTextStringOnCreature( "((Use your dice plate))", oUser, FALSE ) );

            SetLocalInt( oDealer, "CURRENT_PLATE", nCurrentPlateA );

        }// Not holding

    }// Continuing Round

}

int DirtyOneEye( int nD8, int nCurrentPlate, int nOldRoll, object oUser, object oDealer )
{

    int nReturn = FALSE;

    if( nD8 == 1 )
    {// Rolled a dirty one eye

        int nGender = GetGender( oUser );

        string sGender;

        if( nGender == 1 ){ sGender = "She"; }
        else{ sGender = "He"; }

        DelayCommand( 2.0, AssignCommand( oDealer, SpeakString( "Dice plate " +
            IntToString( nCurrentPlate ) + " has rolled a DIRTY ONE EYE!!\n" + sGender + " is out!" ) ) );

        nReturn = TRUE;

    }// Rolled a dirty one eye
    else if( nD8 + nOldRoll > 16 )
    {// Rolled over 16

        int nGender = GetGender( oUser );

        string sGender;

        if( nGender == 1 ){ sGender = "She"; }
        else{ sGender = "He"; }

        DelayCommand( 2.0, AssignCommand( oDealer, SpeakString( "Dice plate " +
            IntToString( nCurrentPlate ) + " has rolled over 16!!\n" + sGender + " is out! Tough luck!" ) ) );

        nReturn = TRUE;

    }// Rolled over 16

    return nReturn;

}
