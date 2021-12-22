//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:
//group:
//used as:
//date: yyyy-mm-dd
//author:

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "amia_include"




//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void FlushPCs( object oArea ){

    effect eBubbles  = EffectVisualEffect( VFX_DUR_BUBBLES );
    effect eHarm     = EffectAbilityDecrease( ABILITY_CONSTITUTION, d4() );
    object oObject   = GetFirstObjectInArea( oArea );
    object oWaypoint = GetWaypointByTag( "rua_flood_wp" );

    while ( GetIsObjectValid( oObject ) ) {

        if ( GetIsPC( oObject ) || GetIsPossessedFamiliar( oObject ) ){

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBubbles, oObject, 6.0 );
            DelayCommand( 4.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHarm, oObject, RoundsToSeconds( d20() ) ) );

            DelayCommand( 4.0, AssignCommand( oObject, JumpToObject( oWaypoint ) ) );

            SendMessageToPC( oObject, "A massive floodwave drops your battered body at the exit of the cave." );
        }

        oObject = GetNextObjectInArea( oArea );
    }
}


void SetFlood( object oArea, object oPLC ){

    SetFogAmount( FOG_TYPE_ALL, 77, oArea );
    SetFogColor( FOG_TYPE_ALL, FOG_COLOR_GREEN_DARK, oArea );

    RecomputeStaticLighting( oArea );
}


void SetDry( object oArea, object oPLC ){

    int nFogAmount = GetLocalInt( oPLC, "fog_amount_org" );
    int nFogColour = GetLocalInt( oPLC, "fog_colour_org" );

    SetFogAmount( FOG_TYPE_ALL, nFogAmount, oArea );
    SetFogColor( FOG_TYPE_ALL, nFogColour, oArea );

    RecomputeStaticLighting( oArea );
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC = GetLastUsedBy();
    object oPLC = OBJECT_SELF;

    string sTag = GetTag( oPLC );

    int nValue;


    if ( sTag == "rua_wheel_1" ){

        nValue = GetLocalInt( oPLC, "wheel" );

        if ( !nValue ){

            nValue = 3;
        }

        if ( nValue == 6 ){

            nValue = 1;
        }
        else{

            nValue += 1;
        }

        SetLocalInt( oPLC, "wheel", nValue );

        SetName( oPLC, "First Wheel: "+IntToString( nValue ) );

        SendMessageToPC( oPC, "You move the first wheel to "+IntToString( nValue )+"." );
    }
    else if ( sTag == "rua_wheel_2" ){

        nValue = GetLocalInt( oPLC, "wheel" );

        if ( !nValue ){

            nValue = 1;
        }

        if ( nValue == 6 ){

            nValue = 1;
        }
        else{

            nValue += 1;
        }

        SetLocalInt( oPLC, "wheel", nValue );

        SetName( oPLC, "Second Wheel: "+IntToString( nValue ) );

        SendMessageToPC( oPC, "You move the second wheel to "+IntToString( nValue )+"." );
    }
    else if ( sTag == "rua_wheel_3" ){

        nValue = GetLocalInt( oPLC, "wheel" );

        if ( !nValue ){

            nValue = 3;
        }

        if ( nValue == 6 ){

            nValue = 1;
        }
        else{

            nValue += 1;
        }

        SetLocalInt( oPLC, "wheel", nValue );

        SetName( oPLC, "Third Wheel: "+IntToString( nValue ) );

        SendMessageToPC( oPC, "You move the third wheel to "+IntToString( nValue )+"." );
    }
    else if (  sTag == "rua_lever" ){


        // * Play Appropriate Animation
        ActionPlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );

        DelayCommand( 2.0, ActionPlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );

        //PlaySound( "as_sw_lever1" );

        object oWheel_1;
        object oWheel_2;
        object oWheel_3;
        object oArea = GetArea( oPC );

        //check init
        if ( !GetLocalInt( oPLC, "init" ) ){

            oWheel_1 = GetNearestObjectByTag( "rua_wheel_1" );
            oWheel_2 = GetNearestObjectByTag( "rua_wheel_2" );
            oWheel_3 = GetNearestObjectByTag( "rua_wheel_3" );

            SetLocalObject( oPLC, "wheel_1", oWheel_1 );
            SetLocalObject( oPLC, "wheel_2", oWheel_2 );
            SetLocalObject( oPLC, "wheel_3", oWheel_3 );

            SetLocalInt( oPLC, "fog_amount_org", GetFogAmount( FOG_TYPE_MOON, oArea ) );
            SetLocalInt( oPLC, "fog_colour_org", GetFogColor( FOG_TYPE_MOON, oArea ) );
        }
        else{

            oWheel_1 = GetLocalObject( oPLC, "wheel_1");
            oWheel_2 = GetLocalObject( oPLC, "wheel_2" );
            oWheel_3 = GetLocalObject( oPLC, "wheel_3" );
        }

        int nValue_1 = GetLocalInt( oWheel_1, "wheel" );
        int nValue_2 = GetLocalInt( oWheel_2, "wheel" );
        int nValue_3 = GetLocalInt( oWheel_3, "wheel" );

        if ( nValue_1 == 3 && nValue_2 == 2 && nValue_3 == 6 ){

            SpeakString( "*Something heavy seems to move nearby*" );

            //success!
            DelayCommand( 1.0, PlaySound("as_dr_x2tib1cl" ) );

            location lSpawn = GetLocation( GetWaypointByTag( "rua_td_corridor" ) );

            object oDoor = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_secr_corridor", lSpawn, 0, "rua_tc_1b" );

            effect eVis = EffectVisualEffect( VFX_DUR_PROTECTION_GOOD_MINOR );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis, oDoor );

            DestroyObject( oDoor, 30.0 );
        }
        else{

            //failure
            DelayCommand( 1.0, PlaySound("as_na_surf2" ) );
            DelayCommand( 2.0, SetFlood( oArea, oPLC ) );
            DelayCommand( 4.0, FlushPCs( oArea ) );
            DelayCommand( 10.0, SetDry( oArea, oPLC ) );
        }

        //randomise
        nValue = d6();
        SetLocalInt( oWheel_1, "wheel", nValue );
        SetName( oWheel_1, "First Wheel: "+IntToString( nValue ) );

        nValue = d6();
        SetLocalInt( oWheel_2, "wheel", nValue );
        SetName( oWheel_2, "Second Wheel: "+IntToString( nValue ) );

        nValue = d6();
        SetLocalInt( oWheel_3, "wheel", nValue );
        SetName( oWheel_3, "Third Wheel: "+IntToString( nValue ) );
    }

}
