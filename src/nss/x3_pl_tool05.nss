//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:   ds_cb_
//group:    player tools
//used as:  player tools
//date:     2009-07-10
//author:   Disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_cb"


void cb_DoSomething( object oTarget, location lTarget );


void cb_DoSomething( object oTarget, location lTarget ){

    object oPlayer       = OBJECT_SELF;
    int nPlayerHasBall   = cb_HasTheBall( oPlayer );
    int nTargetHasBall   = cb_HasTheBall( oTarget );
    int nTargetSide      = cb_GetSide( oPlayer, oTarget );
    int nTargetTeam      = cb_GetTeam( oTarget );
    float fDistance      = GetDistanceBetween( oPlayer, oTarget );

    ClearAllActions( TRUE );

    if ( !GetIsObjectValid( oTarget ) ){

        //throw the ball
        if ( nPlayerHasBall ){

            if ( fDistance <= CB_DISTANCE_THROW ){

                //throw the ball
                cb_ThrowBall( oPlayer, oTarget, lTarget );
            }
            else{

                SendMessageToPC( oPlayer, "You are to far away from your target." );
            }
        }
        else if ( cb_GetTeam( oPlayer ) == CB_TEAM_REFEREE ){

            object oArea   = GetArea( oPlayer );
            object oBall   = GetLocalObject( oArea, CB_HASTHEBALL );

            if ( GetIsPC( oBall ) ){

                cb_SetBallPossession( oBall, FALSE );
            }
            else if ( GetTag( oBall ) == CB_CHICKEN ){

                DestroyObject( oBall );
            }

            //new game, restart
            cb_ThrowBall( oPlayer, oTarget, lTarget );
        }
    }
    else if ( cb_GetTeam( oPlayer ) == CB_TEAM_REFEREE ) {

        if ( GetTag( oTarget ) == CB_CHICKEN ){

            cb_PickUpBall( oPlayer, oTarget );
        }
        else {

            if ( oTarget == oPlayer && GetIsDead( oPlayer ) ){

                SetLocalInt( oPlayer, "ds_check_1", 0 );
                SetLocalInt( oPlayer, "ds_check_2", 0 );
                SetLocalInt( oPlayer, "ds_check_3", 1 );
            }
            else if ( oTarget == oPlayer ){

                SetLocalInt( oPlayer, "ds_check_1", 1 );
                SetLocalInt( oPlayer, "ds_check_2", 0 );
                SetLocalInt( oPlayer, "ds_check_3", 0 );
            }
            else {

                SetLocalInt( oPlayer, "ds_check_1", 0 );
                SetLocalInt( oPlayer, "ds_check_2", 1 );
                SetLocalInt( oPlayer, "ds_check_3", 0 );
            }

            //whistle
            SpeakString( "*whistles*" );

            //pause
            object oTrigger = GetNearestObjectByTag( CB_FIELD );
            object oFreeze  = GetFirstInPersistentObject( oTrigger );
            effect eFreeze  = EffectCutsceneImmobilize();
            effect eVis     = EffectVisualEffect( VFX_IMP_SLOW );

            while ( GetIsObjectValid( oFreeze ) && GetLocalInt( oFreeze, CB_PLAYER ) == 1 ){

                ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oFreeze );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oFreeze, 10.0 );
                oFreeze  = GetNextInPersistentObject( oTrigger );
            }

            SetLocalString( oPlayer, "ds_action", "ds_cb_act" );
            SetLocalObject( oPlayer, "ds_target", oTarget );

            //convo
            ActionStartConversation( oPlayer, "ds_cb_ref", TRUE, FALSE );
        }
    }
    else if ( GetTag( oTarget ) == CB_CHICKEN ){

        //pickup chicken
        if ( fDistance <= CB_DISTANCE_BLOCK ){

            cb_PickUpBall( oPlayer, oTarget );
        }
        else{

            //walk towards referee
            ActionMoveToObject( oTarget );
        }
    }
    else if ( nPlayerHasBall ){

        if ( nTargetSide == CB_SIDE_MINE ){

            if ( fDistance <= CB_DISTANCE_BLOCK ){

                //pass the ball
                cb_CatchBall( oPlayer, oTarget );
            }
            else if ( fDistance <= CB_DISTANCE_THROW ){

                //throw the ball
                cb_ThrowBall( oPlayer, oTarget, lTarget );
            }
            else{

                SendMessageToPC( oPlayer, "You are to far away from your target." );
            }
        }
        else if ( nTargetSide == CB_SIDE_OTHER ){

            if ( fDistance <= CB_DISTANCE_BLOCK ){

                //run down
                cb_Block( oPlayer, oTarget );
            }
            else if ( fDistance <= CB_DISTANCE_THROW ){

                //throw the ball
                cb_ThrowBall( oPlayer, oTarget, lTarget );
            }
            else{

                SendMessageToPC( oPlayer, "You are to far away from your target." );
            }
        }
        else if ( nTargetTeam == CB_TEAM_REFEREE ){

            if ( fDistance <= CB_DISTANCE_BLOCK ){

                //pass the ball
                cb_CatchBall( oPlayer, oTarget );
            }
            else if ( fDistance <= CB_DISTANCE_THROW ){

                //throw the ball
                cb_ThrowBall( oPlayer, oTarget, lTarget );
            }
            else{

                SendMessageToPC( oPlayer, "You are to far away from your target." );
            }
        }
    }
    else if ( nTargetHasBall ){

        if ( nTargetSide == CB_SIDE_MINE ){

            if ( fDistance <= CB_DISTANCE_BLOCK ){

                //what to do?
                SendMessageToPC( oPlayer, "This option hasn't been implemented yet" );
            }
            else{

                //run to player
                ActionMoveToObject( oTarget, TRUE );
            }
        }
        else if ( nTargetSide == CB_SIDE_OTHER ){

            if ( fDistance <= CB_DISTANCE_BLOCK ){

                //block and try to take ball
                cb_Block( oPlayer, oTarget, nPlayerHasBall );
            }
            else{

                //run towards player
                ActionMoveToObject( oTarget, TRUE );
            }
        }
        else if ( nTargetTeam == CB_TEAM_REFEREE ){

            if ( fDistance <= CB_DISTANCE_BLOCK ){

                //ouch, trying to take the ball from the referee
                //cb_Block( oPlayer, oTarget );
                SendMessageToPC( oPlayer, "This option hasn't been implemented yet" );
            }
            else{

                //walk towards referee
                ActionMoveToObject( oTarget );
            }
        }
    }
    else{

        if ( nTargetSide == CB_SIDE_MINE ){

            if ( fDistance <= CB_DISTANCE_BLOCK ){

                //heal?
                SendMessageToPC( oPlayer, "This option hasn't been implemented yet" );
            }
            else{

                //run to player
                ActionMoveToObject( oTarget, TRUE );
            }
        }
        else if ( nTargetSide == CB_SIDE_OTHER ){

            if ( fDistance <= CB_DISTANCE_BLOCK ){

                //foul play!
                cb_Block( oPlayer, oTarget, TRUE );
            }
            else{

                //run towards player
                ActionMoveToObject( oTarget, TRUE );
            }
        }
        else if ( nTargetTeam == CB_TEAM_REFEREE ){

            if ( fDistance <= CB_DISTANCE_BLOCK ){

                //ouch, trying to foul the referee
                //cb_Block( oPlayer, oTarget, TRUE );
                SendMessageToPC( oPlayer, "This option hasn't been implemented yet" );
            }
            else{

                //walk towards referee
                ActionMoveToObject( oTarget );
            }
        }
    }
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC = OBJECT_SELF;


    //------------------------------------
    // start chickenball
    //------------------------------------
    if ( GetLocalInt( oPC, CB_PLAYER ) && GetTag( GetArea( oPC ) ) == "ds_cb" ){

        object oTarget = GetSpellTargetObject();
        location lTarget = GetSpellTargetLocation();

        //Intercept( oPC, oTarget );
        cb_DoSomething( oTarget, lTarget );


        return;
    }
    //------------------------------------
    // end chickenball
    //------------------------------------
}
