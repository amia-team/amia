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

void main(){

    object oPC       = OBJECT_SELF;
    object oTarget   = GetLocalObject( oPC, "ds_target" );
    object oArea     = GetArea( oPC );
    object oBall     = GetLocalObject( oArea, CB_HASTHEBALL );
    int nNode        = GetLocalInt( oPC, "ds_node" );

    if ( nNode == 1 ){

        if ( GetIsPC( oBall ) ){

            cb_SetBallPossession( oBall, FALSE );
        }
        else if ( GetTag( oBall ) == CB_CHICKEN ){

            DestroyObject( oBall );
        }

        DelayCommand( 0.5, cb_SetBallPossession( oPC, TRUE ) );
    }
    else if ( nNode == 2 ){

        string sScore = "Red Team: " + IntToString( 0 ) +"\nYellow Team: " + IntToString( 0 );
        SetDescription( GetNearestObjectByTag( "ds_cb_sign", oPC, 1 ), sScore );
        SetDescription( GetNearestObjectByTag( "ds_cb_sign", oPC, 2 ), sScore );
    }
    else if ( nNode == 3 ){

        string sScore = "Red Team: " + IntToString( 0 ) +"\nYellow Team: " + IntToString( 0 );
        SetDescription( GetNearestObjectByTag( "ds_cb_sign", oPC, 1 ), sScore );
        SetDescription( GetNearestObjectByTag( "ds_cb_sign", oPC, 2 ), sScore );
    }
    else if ( nNode == 11 ){

        if ( GetIsPC( oBall ) ){

            cb_SetBallPossession( oBall, FALSE );
        }
        else if ( GetTag( oBall ) == CB_CHICKEN ){

            DestroyObject( oBall );
        }

        cb_SetBallPossession( oTarget, TRUE );
    }
    else if ( nNode == 12 ){

        cb_SetBallPossession( oTarget, FALSE );
        cb_SetBallPossession( oPC, TRUE );
    }
    else if ( nNode == 13 ){

        FloatingTextStringOnCreature( "*You have received a warning from the referee!*", oTarget, TRUE );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DOOM ), oTarget, 120.0 );
    }
    else if ( nNode == 14 ){

        FloatingTextStringOnCreature( "*You have received a 2 minute penalty from the referee!*", oTarget, TRUE );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_PARALYZE_HOLD ), oTarget, 120.0 );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectCutsceneParalyze(), oTarget, 120.0 );
    }
    else if ( nNode == 15 ){

        FloatingTextStringOnCreature( "*The referee has decided that you are to horrible to live...*", oTarget, TRUE );

        KillPC( oTarget );
    }
    else if ( nNode == 15 ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectResurrection(), oTarget );

        object oWP = GetWaypointByTag( "cb_ehbo_"+IntToString( cb_GetTeam( oTarget ) ) );

        DelayCommand( 1.0, AssignCommand( oTarget, JumpToObject( oWP ) ) );
    }

}
