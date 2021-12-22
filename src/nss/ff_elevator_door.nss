//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ff_elevator_door
//group:   Frozenfar
//used as: OnFailToOpen and OnClick
//date:    november 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x0_i0_petrify"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void SetLevel( object oArea, object oLights, int nLightColor, int nEyes );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oDoor    = OBJECT_SELF;

    if ( GetLocked( oDoor ) ){

        SpeakString( "This door is tightly locked..." );
        return;
    }

    //this is for the transition
    object oArea    = GetArea( oDoor );
    object oPC      = GetClickingObject();
    int nPosition   = GetLocalInt( oArea, "position" );

    if ( nPosition == 0 ){

        //we're on top
        AssignCommand( oPC, ClearAllActions() );
        AssignCommand( oPC, ActionJumpToObject( GetWaypointByTag( "ff_elevator_top" ) ) );

    }
    else if ( nPosition == 1 ){

        if ( !GetIsObjectValid( GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC ) ) ){

            //last player getting out, move elevator to top
            object oDoor1       = GetObjectByTag( "ff_elevator_top_door" );
            object oDoor2       = GetObjectByTag( "ff_elevator_down_door" );

            SetLocked( oDoor1, FALSE );
            SetLocked( oDoor2, TRUE );

            AssignCommand( oDoor1, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
            AssignCommand( oDoor2, PlayAnimation( ANIMATION_DOOR_CLOSE ) );

            object oLights      = GetObjectByTag( "ff_elevator_top_lights" );
            SetLevel( GetArea( oLights ), oLights, TILE_MAIN_LIGHT_COLOR_DIM_WHITE, VFX_EYES_GREEN_TROGLODYTE );
            SetLocalInt( oArea, "position", 0 );
        }

        //we're on bottom
        AssignCommand( oPC, ClearAllActions() );
        AssignCommand( oPC, ActionJumpToObject( GetWaypointByTag( "ff_elevator_down" ) ) );
    }
}

void SetLevel( object oArea, object oLights, int nLightColor, int nEyes ){

    RemoveEffectOfType( oLights, EFFECT_TYPE_VISUALEFFECT );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( nEyes ), oLights );

    vector vLocation = Vector( 0.0, 1.0, 0.0);
    location lTile   = Location( oArea, vLocation, 0.0 );

    SetTileMainLightColor( lTile, nLightColor, nLightColor );

    RecomputeStaticLighting( oArea );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_FNF_SCREEN_SHAKE ), oLights );

    AssignCommand( oLights, PlaySound( "as_cv_smithmet1" ) );
}

