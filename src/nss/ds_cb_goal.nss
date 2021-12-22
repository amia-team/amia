//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:   ds_cb_
//group:    chickenball
//used as:  OnEnter
//date:     2009-07-10
//author:   Disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_cb"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------



void main(){

    object oGoal       = OBJECT_SELF;
    object oPC         = GetEnteringObject();
    object oTarget     = GetWaypointByTag( GetLocalString( oGoal, "cb_goal" ) );
    object oArea       = GetArea( oPC );
    int nPlayerTeam    = cb_GetTeam( oPC );
    int nGoalTeam      = cb_GetTeam( oGoal );
    effect eGoal;
    int nScoreRed      = GetLocalInt( oArea, "score_1" );
    int nScoreYellow   = GetLocalInt( oArea, "score_2" );

    if ( GetLocalInt( oPC, CB_HASTHEBALL ) ){

        cb_SetBallPossession( oPC, FALSE );

        DelayCommand( 1.0, cb_SetBallPossession( GetLocalObject( oArea, CB_REFEREE ), TRUE ) );

        if ( nPlayerTeam != nGoalTeam ){

            SpeakString( "GOAL!" );

            if ( nPlayerTeam == CB_TEAM_YELLOW ){

                eGoal = EffectVisualEffect( VFX_FNF_LOS_EVIL_30 );
                nScoreYellow += 1;
            }
            else{

                eGoal = EffectVisualEffect( VFX_FNF_LOS_HOLY_30 );
                nScoreRed += 1;
            }
        }
        else{

            SpeakString( "SUCKER! WRONG GOAL!" );

            if ( nPlayerTeam == CB_TEAM_RED ){

                eGoal = EffectVisualEffect( VFX_FNF_LOS_EVIL_30 );
                nScoreYellow += 1;
            }
            else{

                eGoal = EffectVisualEffect( VFX_FNF_LOS_HOLY_30 );
                nScoreRed += 1;
            }
        }

        SetLocalInt( oArea, "score_1", nScoreRed );

        SetLocalInt( oArea, "score_2", nScoreYellow );

        string sScore = "Red Team: " + IntToString( nScoreRed ) +"\nYellow Team: " + IntToString( nScoreYellow );

        SetDescription( GetNearestObjectByTag( "ds_cb_sign", oPC, 1 ), sScore );
        SetDescription( GetNearestObjectByTag( "ds_cb_sign", oPC, 2 ), sScore );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eGoal, oGoal );
    }
    else{

        SendMessageToPC( oPC, "You don't have the ball." );
    }

    AssignCommand( oPC, JumpToObject( oTarget ) );


}


