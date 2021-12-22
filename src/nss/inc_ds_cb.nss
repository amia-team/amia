//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:   CB_
//group:    chickenball
//used as:  OnConversation
//date:     2009-07-10
//author:   Disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_spawns"
#include "inc_ds_actions"
#include "inc_ds_records"



//-------------------------------------------------------------------------------
// constants
//-------------------------------------------------------------------------------

const int CB_TEAM_NONE = 0;
const int CB_TEAM_REFEREE = 3;
const int CB_TEAM_RED = 1;
const int CB_TEAM_YELLOW = 2;
const int CB_SIDE_NONE = 0;
const int CB_SIDE_MINE = 1;
const int CB_SIDE_OTHER = 2;

const float CB_DISTANCE_BLOCK = 3.5;
const float CB_DISTANCE_THROW = 25.0;

const string CB_HASTHEBALL       = "CB_HASTHEBALL";
const string CB_TEAM             = "ds_cb_team";
const string CB_REFEREE          = "ds_cb_referee";
const string CB_CHICKEN          = "ds_cb_chicken";
const string CB_PLAYER           = "ds_cb_player";
const string CB_REFSUIT          = "ds_cb_refsuit";
const string CB_REDSUIT          = "ds_cb_redsuit";
const string CB_YELLOWSUIT       = "ds_cb_yellowsuit";
const string CB_FIELD            = "ds_cb_field";
const string CB_SHOP             = "ds_cb_shop";




//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//returns whether oPlayer belongs to either
// CB_TEAM_NONE
// CB_TEAM_RED
// CB_TEAM_YELLOW
// CB_TEAM_REFEREE
int cb_GetTeam( object oPlayer );

//returns whether oTarget is on oPlayer's side or not
// CB_SIDE_NONE
// CB_SIDE_MINE
// CB_SIDE_OTHER
int cb_GetSide( object oPlayer, object oTarget );

int cb_HasTheBall( object oPlayer );

//creates a new chicken ball
void cb_CreateBall( location lSpawn );

//this changes the local vars and effects on when gaining or losing the ball
//set Nstatus on TRUE when gaining ball and FALSE on losing it
//mind that this doesn't create a new ball!
void cb_SetBallPossession( object oPlayer, int nStatus=TRUE );

//makes oPlayer try to pick up oChicken
void cb_PickUpBall( object oPlayer, object oChicken );

void cb_Block( object oPlayer, object oTarget, int nFoulPlay=FALSE );

void cb_CatchBall( object oPlayer, object oTarget, float fDelay=0.0 );

//check for ball interception
//return values:
// 0 = not intercepted
// 1 = intercepted
int cb_HasBeenIntercepted( object oPlayer, object oInterceptor );

//This
void cb_ThrowBall( object oPlayer, object oTarget, location lTarget, float fWidth=3.0 );

void cb_ReportRoll( object oPlayer, int nRoll, string sResult );

int cb_IsParalysedOrDead( object oPlayer );

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int cb_GetTeam( object oPlayer ){

    return GetLocalInt( oPlayer, CB_TEAM );
}

//returns whether oTarget is on oPlayer's side or not
// CB_SIDE_NONE
// CB_SIDE_MINE
// CB_SIDE_OTHER
int cb_GetSide( object oPlayer, object oTarget ){

    int nPlayerTeam   = cb_GetTeam( oPlayer );
    int nTargetTeam   = cb_GetTeam( oTarget );

    if ( nPlayerTeam > 0 && nPlayerTeam == nTargetTeam ){

        return CB_SIDE_MINE;
    }
    else if ( nPlayerTeam == CB_TEAM_RED && nTargetTeam == CB_TEAM_YELLOW ){

        return CB_SIDE_OTHER;
    }
    else if ( nPlayerTeam == CB_TEAM_YELLOW && nTargetTeam == CB_TEAM_RED ){

        return CB_SIDE_OTHER;
    }

    return CB_SIDE_NONE;
}

int cb_HasTheBall( object oPlayer ){

    if ( GetLocalInt( oPlayer, CB_HASTHEBALL ) ){

        return TRUE;
    }

    return FALSE;
}

void cb_CreateBall( location lSpawn ){

    object oArea = GetAreaFromLocation( lSpawn );
    object oBall = GetLocalObject( oArea, CB_HASTHEBALL );

    if ( !GetIsObjectValid( oBall ) ){

        oBall = CreateObject( OBJECT_TYPE_CREATURE, CB_CHICKEN, lSpawn );

        SetLocalObject( oArea, CB_HASTHEBALL, oBall );
    }
    else{

        SpeakString( "Debug: Tried to create a second ball?" );
    }
}

//this changes the local vars and effects on when gaining or losing the ball
//set Nstatus on TRUE when gaining ball and FALSE on losing it
//mind that this doesn't create a new ball!
void cb_SetBallPossession( object oPlayer, int nStatus=TRUE ){

    object oArea = GetArea( oPlayer );

    SetLocalInt( oPlayer, CB_HASTHEBALL, nStatus );
    SetLocalInt( oArea, CB_HASTHEBALL, nStatus );

    if ( nStatus == TRUE ){

        SetLocalObject( oArea, CB_HASTHEBALL, oPlayer );

        effect eFlag;
        int nTeam = cb_GetTeam( oPlayer );

        if ( nTeam == CB_TEAM_YELLOW ){

            eFlag = EffectLinkEffects( EffectMovementSpeedDecrease( 20 ), EffectVisualEffect( VFX_DUR_FLAG_GOLD_FIXED ) );
        }
        else if ( nTeam == CB_TEAM_RED ){

            eFlag = EffectLinkEffects( EffectMovementSpeedDecrease( 20 ), EffectVisualEffect( VFX_DUR_FLAG_RED ) );
        }
        else if ( nTeam == CB_TEAM_REFEREE ){

            eFlag = EffectVisualEffect( VFX_DUR_FLAG_BLUE );
        }

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eFlag, oPlayer );
    }
    else{

        SetLocalObject( oArea, CB_HASTHEBALL, OBJECT_INVALID );

        effect eCheck = GetFirstEffect( oPlayer );

        while ( GetIsEffectValid( eCheck ) ){

            // remove flag effect
            if ( GetEffectDurationType( eCheck ) == DURATION_TYPE_PERMANENT &&
                 GetEffectType( eCheck ) == EFFECT_TYPE_VISUALEFFECT ) {

                RemoveEffect( oPlayer, eCheck );
            }

            eCheck = GetNextEffect( oPlayer );
        }
    }
}

void cb_PickUpBall( object oPlayer, object oChicken ){

    int nRoll = d10();
    nRoll    += GetAbilityModifier( ABILITY_WISDOM, oPlayer );
    string sResult;

    PlayAnimation( ANIMATION_LOOPING_GET_LOW, 2.0, 0.5 );

    if ( nRoll >= 3 || cb_GetTeam( oPlayer ) == CB_TEAM_REFEREE ){

        DestroyObject( oChicken, 0.5 );

        cb_SetBallPossession( oPlayer );

        sResult = "You pick up the ball.";
    }
    else{

        AssignCommand( oChicken, ActionMoveAwayFromObject( oPlayer, FALSE, 10.0 ) );

        sResult = "You fail to pick up the ball.";
    }

    cb_ReportRoll( oPlayer, nRoll, sResult );
}


void cb_Block( object oPlayer, object oTarget, int nFoulPlay=FALSE ){

    if ( cb_GetTeam( oTarget ) == CB_TEAM_REFEREE ){

        //Wrong move!
        return;
    }

    int nPlayerHasBall   = cb_HasTheBall( oPlayer );
    int nTargetHasBall   = cb_HasTheBall( oTarget );

    int nRoll = d10();
    nRoll    -= GetAbilityModifier( ABILITY_STRENGTH, oTarget );
    nRoll    += GetAbilityModifier( ABILITY_STRENGTH, oPlayer );
    string sResult;

    int nWounds;
    int nRounds;

    if ( nRoll <= 2 ){

        nWounds = 2 - nRoll - GetAbilityModifier( ABILITY_CONSTITUTION, oPlayer );

        if ( nWounds < 0 ){

            nWounds = 0;
        }

        nRounds = 1 + nWounds;

        if ( nPlayerHasBall ){

            //player drops ball
            cb_SetBallPossession( oPlayer, FALSE );
            cb_CreateBall( GetLocation( oTarget ) );
        }

        oTarget = oPlayer;

        sResult = "Your opponent blocks you!";
    }
    else if ( nRoll >= 6 ){

        if ( nTargetHasBall ){

            //target drops ball
            cb_SetBallPossession( oTarget, FALSE );
            cb_CreateBall( GetLocation( oTarget ) );
        }

        nWounds =  nRoll - 6 - GetAbilityModifier( ABILITY_CONSTITUTION, oTarget );

        if ( nWounds < 0 ){

            nWounds = 0;
        }

        nRounds = 1 + nWounds;

        sResult = "You block your opponent";

        if ( nFoulPlay ){

            int nRoll2   = d10() + GetAbilityModifier( ABILITY_CHARISMA, oPlayer );

            if ( nRoll2 >= 8 ){

                cb_ReportRoll( oPlayer, nRoll2, "You manage to disguise your foul play as clumsiness!" );
            }
            else{

                object oRef = GetLocalObject( GetArea( oPlayer ), CB_REFEREE );

                if ( d100() > FloatToInt( 1.5 * GetDistanceBetween( oRef, oTarget ) ) ){

                    SendMessageToPC( oRef, GetName( oPlayer )+" pulled a foul on "+GetName( oTarget ) );
                }
            }
        }
    }
    else{

        sResult = "You fail to block your opponent.";
    }

    if ( nRounds > 0 ){

        effect eKD = EffectLinkEffects( EffectCutsceneParalyze(), EffectKnockdown() );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eKD, oTarget, RoundsToSeconds( nRounds ) );

        effect eVis = EffectVisualEffect( 468 );     //silent bard song
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oTarget, RoundsToSeconds( nRounds ) );

        PlaySound( "cb_ht_shklet1" );
    }

    if ( nWounds > 0 ){

        effect eDam = EffectDamage( nWounds );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget );

        object oStain = CreateObject( OBJECT_TYPE_PLACEABLE, "plc_bloodstain", GetLocation( oTarget ), TRUE, "cb_stain" );

        effect eVis2 = EffectVisualEffect( VFX_COM_CHUNK_RED_MEDIUM );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oTarget );

        DestroyObject( oStain, 300.0 );
    }

    cb_ReportRoll( oPlayer, nRoll, sResult );
}

void cb_CatchBall( object oPlayer, object oTarget, float fDelay=0.0 ){

    int nRoll = d10();
    nRoll    += GetAbilityModifier( ABILITY_DEXTERITY, oTarget );
    nRoll    += GetAbilityModifier( ABILITY_INTELLIGENCE, oPlayer );
    string sResult;

    if ( nRoll > 8 || cb_GetTeam( oTarget ) == CB_TEAM_REFEREE ){

        DelayCommand( fDelay, AssignCommand( oTarget, SpeakString( "*catches the chicken*" ) ) );
        DelayCommand( fDelay, AssignCommand( oTarget, PlayAnimation( ANIMATION_LOOPING_GET_LOW, 2.0, 1.0 ) ) );
        DelayCommand( fDelay, cb_SetBallPossession( oTarget ) );
        sResult = "You catch the ball.";
    }
    else{

        location lTarget = GetLocation( oTarget );

        DelayCommand( fDelay, AssignCommand( oTarget, PlayAnimation( ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 2.0 ) ) );
        DelayCommand( fDelay, AssignCommand( oTarget, SpeakString( "*drops the chicken*" ) ) );
        DelayCommand( fDelay, cb_CreateBall( GetLocation( oTarget ) ) );
        sResult = "You fail to catch the ball.";
    }

    cb_ReportRoll( oTarget, nRoll, sResult );
}



//check for ball interception
//return values:
// 0 = not intercepted
// 1 = intercepted
int cb_HasBeenIntercepted( object oPlayer, object oInterceptor ){

    int nRoll = d10();
    nRoll    += GetAbilityModifier( ABILITY_DEXTERITY, oInterceptor );
    nRoll    -= GetAbilityModifier( ABILITY_INTELLIGENCE, oPlayer );

    if ( nRoll > 6 ){

        cb_ReportRoll( oPlayer, nRoll, "Your ball is intercepted "+GetName( oInterceptor )+"." );
        cb_ReportRoll( oInterceptor, nRoll, "You intercept "+GetName( oPlayer )+"'s ball." );
        return TRUE;
    }

    cb_ReportRoll( oPlayer, nRoll, "Your ball is not intercepted by "+GetName( oInterceptor )+"." );
    cb_ReportRoll( oInterceptor, nRoll, "You fail to intercept "+GetName( oPlayer )+"'s ball." );
    return FALSE;
}


//This
void cb_ThrowBall( object oPlayer, object oTarget, location lTarget, float fWidth=3.0 ){

    //variables for shape filter
    float fDistance     = GetDistanceBetween( oPlayer, oTarget );
    float fDelay        = fDistance / 12.0;
    vector vOrigin      = GetPosition( oPlayer );
    vector vTarget      = GetPosition( oTarget );
    int nInterception;

    if ( !GetIsObjectValid( oTarget ) ){

        //you can throw balls somewhere on the field. These balls can be intercepted.
        fDistance     = GetDistanceBetweenLocations( GetLocation( oPlayer ), lTarget );
        fDelay        = fDistance / 12.0;
        vTarget      = GetPositionFromLocation( lTarget );
    }
    else if ( cb_GetTeam( oPlayer ) == CB_TEAM_REFEREE || cb_GetTeam( oTarget ) == CB_TEAM_REFEREE ){

        //balls to and from referee are not intercepted
        cb_SetBallPossession( oPlayer, FALSE );

        ActionCastSpellAtLocation( SPELL_GRENADE_CHICKEN, lTarget, 0, TRUE, 0, TRUE );

        cb_CatchBall( oPlayer, oTarget, fDelay );

        return;
    }

    //variables for point to line calculation
    float a             = ( vTarget.y - vOrigin.y ) / ( vTarget.x - vOrigin.x );
    float b             = vOrigin.y - ( a * vOrigin.x );
    float fDelta        = 0.0;
    vector vPoint;
    vector vLine;
    float fPart1;
    float fPart2;
    float fDenominator  = 0.0;
    float fDivider      = 0.0;
    object oPoint       = GetFirstObjectInShape( SHAPE_SPELLCONE, fDistance, lTarget, TRUE, OBJECT_TYPE_CREATURE );

    //the actual distance between point and line can be up to half the width
    fWidth = fWidth / 2.0;

    //I use a cone shape first to make a quick selection of creatures to check
    while ( GetIsObjectValid( oPoint ) ){

        //only members of the other team intercept, and target never intercepts
        if ( oPoint != oTarget && cb_GetSide( oPlayer, oPoint ) == CB_SIDE_OTHER ){

            vPoint       = GetPosition( oPoint );
            fPart1       = ( a * vPoint.x ) + b;
            fPart2       = pow( vPoint.x - ( ( vPoint.y - b ) / a ), 2.0 );
            fDenominator = sqrt( pow( vPoint.y - fPart1, 2.0  ) ) * sqrt( fPart2 );
            fDivider     = sqrt( fPart2 + pow( fPart1 - vPoint.y, 2.0 ) );
            fDelta       = fDenominator / fDivider;

            if ( fDelta <= fWidth ){

                nInterception = cb_HasBeenIntercepted( oPlayer, oPoint );

                if ( nInterception ){

                    break;
                }
            }
        }

        oPoint = GetNextObjectInShape( SHAPE_SPELLCONE, fDistance, lTarget, TRUE, OBJECT_TYPE_CREATURE );
    }

    if ( nInterception ){

        fDelay  = GetDistanceBetween( oPlayer, oPoint ) / 12.0;
        lTarget = GetLocation( oPoint );

        cb_CatchBall( oPlayer, oPoint, fDelay );
    }
    else if ( !GetIsObjectValid( oTarget ) ){

        DelayCommand( fDelay, cb_CreateBall( lTarget ) );
    }
    else{

        cb_CatchBall( oPlayer, oTarget, fDelay );
    }

    cb_SetBallPossession( oPlayer, FALSE );

    ActionCastSpellAtLocation( SPELL_GRENADE_CHICKEN, lTarget, 0, TRUE, 0, TRUE );
}


void cb_ReportRoll( object oPlayer, int nRoll, string sResult ){

    SendMessageToPC( oPlayer, "The result of the roll is a "+IntToString( nRoll )+". "+sResult );

}

int cb_IsParalysedOrDead( object oPlayer ){

    if ( GetIsDead( oPlayer ) ){

        return TRUE;
    }

    effect eCheck = GetFirstEffect( oPlayer );

    while ( GetIsEffectValid( eCheck ) ){

        // remove flag effect
        if ( GetEffectType( eCheck ) == EFFECT_TYPE_CUTSCENE_PARALYZE ) {

            return TRUE;
        }

        eCheck = GetNextEffect( oPlayer );
    }

    return FALSE;
}
