//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ff_trigger
//group:   Frozenfar
//used as: OnTrigger
//date:    november 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x0_i0_petrify"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//does nDamage to the nearest two bystanders
void DamageBystanders( location lWP, int nDamage, int nDamageType );

void SetLevel( object oArea, object oLights, int nLightColor, int nEyes );
void CloseDoors();
void OpenDoors( int nPosition );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC      = GetEnteringObject();
    object oTrigger = OBJECT_SELF;
    string sTag     = GetTag( oTrigger );
    object oArea    = GetArea( oTrigger );

    if ( !GetIsPC( oPC ) ){

        return;
    }

    if ( sTag == "ff_seamonster" ){

        if ( d6() > 4 ){

            object oWP      = GetNearestObjectByTag( "ff_seamonster" );
            location lWP    = GetLocation( oWP );
            effect eMonster = EffectVisualEffect( 40 );

            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eMonster, lWP );

            DelayCommand( 2.0, DamageBystanders( lWP, d10( 3 ), DAMAGE_TYPE_PIERCING ) );
            DelayCommand( 5.0, DamageBystanders( lWP, d10( 3 ), DAMAGE_TYPE_PIERCING ) );
        }
    }
    else if ( sTag == "ff_elevator_top" ){

        int nPosition       = GetLocalInt( oArea, "position" );
        object oLights      = GetObjectByTag( "ff_elevator_top_lights" );

        if ( nPosition == 0 ){

            SetLocalInt( oArea, "position", 2 );

            CloseDoors();

            SetLevel( oArea, oLights, TILE_MAIN_LIGHT_COLOR_DIM_WHITE, VFX_EYES_GREEN_TROGLODYTE );
            DelayCommand( 3.0, SetLevel( oArea, oLights, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW, VFX_EYES_WHT_TROGLODYTE ) );
            DelayCommand( 6.0, SetLevel( oArea, oLights, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE, VFX_EYES_YEL_TROGLODYTE ) );
            DelayCommand( 9.0, SetLevel( oArea, oLights, TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED, VFX_EYES_PUR_TROGLODYTE ) );
            DelayCommand( 12.0, SetLevel( oArea, oLights, TILE_MAIN_LIGHT_COLOR_RED, VFX_EYES_RED_FLAME_TROGLODYTE ) );
            DelayCommand( 15.0, SetLocalInt( oArea, "position", 1 ) );
            DelayCommand( 15.0, OpenDoors( nPosition ) );
        }
        else if ( nPosition == 1 ){

            SetLocalInt( oArea, "position", 2 );

            CloseDoors();

            SetLevel( oArea, oLights, TILE_MAIN_LIGHT_COLOR_RED, VFX_EYES_RED_FLAME_TROGLODYTE );
            DelayCommand( 3.0, SetLevel( oArea, oLights, TILE_MAIN_LIGHT_COLOR_PALE_DARK_RED, VFX_EYES_PUR_TROGLODYTE ) );
            DelayCommand( 6.0, SetLevel( oArea, oLights, TILE_MAIN_LIGHT_COLOR_PALE_DARK_ORANGE, VFX_EYES_YEL_TROGLODYTE ) );
            DelayCommand( 9.0, SetLevel( oArea, oLights, TILE_MAIN_LIGHT_COLOR_PALE_DARK_YELLOW, VFX_EYES_WHT_TROGLODYTE ) );
            DelayCommand( 12.0, SetLevel( oArea, oLights, TILE_MAIN_LIGHT_COLOR_DIM_WHITE, VFX_EYES_GREEN_TROGLODYTE ) );
            DelayCommand( 15.0, SetLocalInt( oArea, "position", 0 ) );
            DelayCommand( 15.0, OpenDoors( nPosition ) );
        }
    }
    else if ( sTag == "ff_flames" ){

        if ( d6() == 4 ){

            effect eFlame = EffectVisualEffect( VFX_DUR_INFERNO_CHEST );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFlame, oPC, 6.0 );

            effect eDamage = EffectDamage( d10(4), DAMAGE_TYPE_FIRE );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC );

                int nDie = d3();

                if ( nDie == 1 ){

                    SendMessageToPC( oPC, "You're on fire!!!" );
                }
                else if ( nDie == 2 ){

                    SendMessageToPC( oPC, "Ouch! This is too hot to handle!" );
                }
                else {

                    SendMessageToPC( oPC, "This stuff is twenty times as hot as the hottest stuff in hell!!!" );
                }
        }
    }
    else if ( sTag == "ff_heatstroke" ){

        if ( d6() == 2 ){

            if ( GetWeight( GetItemInSlot( INVENTORY_SLOT_CHEST, oPC ) ) > 100 ){

                effect eFlame = EffectVisualEffect( VFX_IMP_HEAD_FIRE );

                ApplyEffectToObject( DURATION_TYPE_INSTANT, eFlame, oPC );

                effect eDamage = EffectDamage( d10(2), DAMAGE_TYPE_FIRE );

                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC );

                int nDie = d3();

                if ( nDie == 1 ){

                    SendMessageToPC( oPC, "It's getting hot in here..." );
                }
                else if ( nDie == 2 ){

                    SendMessageToPC( oPC, "You're being boiled alive for some god's stocking..." );
                }
                else {

                    SendMessageToPC( oPC, "How can you think when your head is burning?!" );
                }
            }
        }
    }
    else if ( sTag == "ff_frostburn" ){

        if ( d6() == 2 ){

            location lWP = GetLocation( oPC );

            effect eIce = EffectVisualEffect( VFX_FNF_ICESTORM );

            ApplyEffectAtLocation( DURATION_TYPE_INSTANT, eIce, lWP );

            DamageBystanders( lWP, d10(3), DAMAGE_TYPE_COLD );
        }
    }
    else if ( sTag == "" ){


    }
    else if ( sTag == "" ){


    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void DamageBystanders( location lWP, int nDamage, int nDamageType ){

    effect eDamage = EffectDamage( nDamage, nDamageType );
    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, 15.0, lWP );

    if ( GetIsObjectValid( oTarget ) ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );

        oTarget = GetNextObjectInShape( SHAPE_SPHERE, 15.0, lWP );

        if ( GetIsObjectValid( oTarget ) ){

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        }
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

void CloseDoors(){


    object oDoor1       = GetObjectByTag( "ff_elevator_top_door" );
    object oDoor2       = GetObjectByTag( "ff_elevator_down_door" );
    object oDoor3       = GetObjectByTag( "ff_elevator_in_door" );

    SetLocked( oDoor1, TRUE );
    SetLocked( oDoor2, TRUE );
    SetLocked( oDoor3, TRUE );

    AssignCommand( oDoor1, PlayAnimation( ANIMATION_DOOR_CLOSE ) );
    AssignCommand( oDoor2, PlayAnimation( ANIMATION_DOOR_CLOSE ) );
    AssignCommand( oDoor3, PlayAnimation( ANIMATION_DOOR_CLOSE ) );
}

void OpenDoors( int nPosition ){

    object oDoor1       = GetObjectByTag( "ff_elevator_top_door" );
    object oDoor2       = GetObjectByTag( "ff_elevator_down_door" );
    object oDoor3       = GetObjectByTag( "ff_elevator_in_door" );

    if ( nPosition == 0 ){

        SetLocked( oDoor2, FALSE );
        SetLocked( oDoor3, FALSE );

        AssignCommand( oDoor2, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
        AssignCommand( oDoor3, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
    }
    else{

        SetLocked( oDoor1, FALSE );
        SetLocked( oDoor3, FALSE );

        AssignCommand( oDoor1, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
        AssignCommand( oDoor3, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
    }
}
