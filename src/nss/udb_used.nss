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

#include "inc_ds_records"

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------




void JumpAround( object oPC, object oPLC ){

    int nStep       = GetLocalInt( oPC, "udb_maze_step" );
    int nValue      = GetLocalInt( oPC, "udb_maze_value" );
    string sSound   = "";

    if ( GetTag( oPLC ) == "udb_red_string" ){

        sSound   = "as_cv_lute1b";

        nStep -= 1;

        if ( nStep < -3 ){

            nStep = -4;
        }

        nValue += nStep;
    }

    if ( GetTag( oPLC ) == "udb_green_string" ){

        sSound   = "as_cv_lute1";

        nStep += 1;

        if ( nStep > 3 ){

            nStep = 4;
        }

        nValue += nStep;
    }

    if ( nValue < 0 ){

        nValue = 8 + nValue;
    }

    if ( nValue > 8 ){

        nValue = nValue - 8;
    }


    switch ( nStep+5 ) {

        case 1:     SpeakString( "Minus four: No further, no more." );    break;
        case 2:     SpeakString( "I will take you back three steps, no less." );    break;
        case 3:     SpeakString( "To the left, and once again." );    break;
        case 4:     SpeakString( "One step forward, two steps back." );    break;
        case  5:     SpeakString( "Minus and Plus are Cancelled thus. " );     break;
        case  6:     SpeakString( "One step forward, no steps back." );    break;
        case  7:     SpeakString( "Two of a kind, we'll go there blind." );    break;
        case  8:     SpeakString( "Three in a row, go go go." );    break;
        case  9:     SpeakString( "Plus four: This is your limit, stay on this floor." );    break;
    }

    if ( nStep == 0 || abs( nStep ) == 4 ){

        sSound   = "as_cv_gutterspl1";
    }
    else{

        SetLocalInt( oPC, "udb_maze_value", nValue );

        string sWaypoint = "usb_maze_"+IntToString( nValue );

        DelayCommand( 2.0, AssignCommand( oPC, JumpToObject( GetWaypointByTag( sWaypoint ) ) ) );
    }

    SetLocalInt( oPC, "udb_maze_step", nStep );

    PlaySound( sSound );
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){


    object oPC      = GetLastUsedBy();
    object oPLC     = OBJECT_SELF;
    string sTag     = GetTag( oPLC );
    string sName    = GetName( oPLC );
    int nNumber     = GetLocalInt( oPLC, "number" );
    effect eLight;

    if ( sTag == "udb_red_string" || sTag == "udb_green_string" ){

        JumpAround( oPC, oPLC );
    }
    else if ( sName == "Pedestal" ){

        object oItem = GetItemPossessedBy( oPC, "udb_maze_it_"+IntToString( nNumber ) );
        object oArea = GetArea( oPLC );
        int i;
        int nResult  = TRUE;

        if ( GetIsObjectValid( oItem ) ){

            DestroyObject( oItem );

            if ( nNumber == 1 ){

                eLight = EffectVisualEffect( VFX_DUR_GLOW_RED );
            }
            else if ( nNumber == 2 ){

                eLight = EffectVisualEffect( VFX_DUR_GLOW_BLUE );
            }
            else if ( nNumber == 3 ){

                eLight = EffectVisualEffect( VFX_DUR_GLOW_GREEN );
            }
            else if ( nNumber == 4 ){

                eLight = EffectVisualEffect( VFX_DUR_GLOW_WHITE );
            }

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLight, oPLC );
        }

        SetLocalInt( oArea, "udb_maze_"+IntToString( nNumber ), 1 );


        for ( i=1; i<=4; ++i ){

            if ( !GetLocalInt( oArea, "udb_maze_"+IntToString( i ) ) ){

                nResult = FALSE;
            }
        }

        if ( nResult == TRUE ){

            location lPortal = GetLocation( GetNearestObjectByTag( "usb_maze_0" ) );

            CreateObject( OBJECT_TYPE_PLACEABLE, "udb_maze_portal", lPortal, TRUE );
        }
    }
    else if ( sTag == "udb_lichcom" ){

        SetLocalString( oPC, "ds_action", "udb_convo_act" );
        SetLocalObject( oPC, "ds_target", oPLC );

        object oBook = GetItemPossessedBy( oPC, "udb_lich_book" );

        if ( GetIsObjectValid( oBook ) ){

            SetLocalObject( oPC, "udb_book", oBook );

            SetLocalInt( oPC, "ds_check_1", 1 );
        }
        else{

            SetLocalInt( oPC, "ds_check_1", 0 );
        }

        ActionStartConversation( oPC, "", TRUE, FALSE );
    }
    else if ( sTag == "udb_lich_ball_1" ){

        SafeRemoveAllEffects( oPLC );

        SpeakString( "*you flick a switch on the mechanism, which changes its glow*" );

        if ( nNumber == 0 ){

            eLight = EffectVisualEffect( VFX_DUR_GLOW_LIGHT_RED );
            ++nNumber;
        }
        else if ( nNumber == 1 ){

            eLight = EffectVisualEffect( VFX_DUR_GLOW_LIGHT_PURPLE );
            ++nNumber;
        }
        else if ( nNumber == 2 ){

            eLight = EffectVisualEffect( VFX_DUR_GLOW_LIGHT_BLUE );
            ++nNumber;
        }
        else{

            nNumber = 0;
        }

        if ( nNumber != 0 ){

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLight, oPLC );
        }

        SetLocalInt( oPLC, "number", nNumber );
    }
    else if ( sTag == "udb_lich_ball_2" ){

        SafeRemoveAllEffects( oPLC );

        SpeakString( "*you flick a switch on the mechanism, which changes its glow*" );

        if ( nNumber == 0 ){

            eLight = EffectVisualEffect( VFX_DUR_GLOW_LIGHT_YELLOW );
            ++nNumber;
        }
        else if ( nNumber == 1 ){

            eLight = EffectVisualEffect( VFX_DUR_GLOW_LIGHT_ORANGE );
            ++nNumber;
        }
        else if ( nNumber == 2 ){

            eLight = EffectVisualEffect( VFX_DUR_GLOW_LIGHT_RED );
            ++nNumber;
        }
        else{

            nNumber = 0;
        }

        if ( nNumber != 0 ){

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLight, oPLC );
        }

        SetLocalInt( oPLC, "number", nNumber );
    }
    else if ( sTag == "udb_lich_ball_3" ){

        if ( GetLocalInt( oPLC, "activated" ) ){

            SpeakString( "*you can't move any of the switches*" );
            return;
        }

        SafeRemoveAllEffects( oPLC );

        object oBall1 = GetLocalObject( oPLC, "ball1" );
        object oBall2 = GetLocalObject( oPLC, "ball2" );

        if ( !GetIsObjectValid( oBall1 ) ){

            oBall1 = GetNearestObjectByTag( "udb_lich_ball_1" );
            oBall2 = GetNearestObjectByTag( "udb_lich_ball_2" );

            SetLocalObject( oPLC, "ball1", oBall1 );
            SetLocalObject( oPLC, "ball2", oBall2 );
        }

        if ( GetLocalInt( oBall1, "number" ) == 3 && GetLocalInt( oBall2, "number" ) == 1 ){

            SpeakString( "*you hear some clicking noise coming from the door while the mechanism rises*" );

            SetLocalInt( oPLC, "activated", 1 );

            eLight = EffectVisualEffect( VFX_DUR_GLOW_LIGHT_GREEN );

            ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLight, oPLC );

            PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );

            object oDoor1 = GetLocalObject( oPLC, "door1" );
            object oDoor2 = GetLocalObject( oPLC, "door2" );

            if ( !GetIsObjectValid( oDoor1 ) ){

                oDoor1 = GetNearestObjectByTag( "udb_lich_lock1" );
                oDoor2 = GetNearestObjectByTag( "udb_lich_lock2" );

                SetLocalObject( oPLC, "door1", oDoor1 );
                SetLocalObject( oPLC, "door2", oDoor2 );
            }

            AssignCommand( oDoor1, PlayAnimation( ANIMATION_DOOR_OPEN1 ) );
            AssignCommand( oDoor2, PlayAnimation( ANIMATION_DOOR_OPEN2 ) );

            DelayCommand( 30.0, AssignCommand( oDoor1, PlayAnimation( ANIMATION_DOOR_CLOSE ) ) );
            DelayCommand( 30.0, AssignCommand( oDoor2, PlayAnimation( ANIMATION_DOOR_CLOSE ) ) );

            DelayCommand( 30.0, SafeRemoveAllEffects( oPLC ) );
            DelayCommand( 30.0, SafeRemoveAllEffects( oBall1 ) );
            DelayCommand( 30.0, SafeRemoveAllEffects( oBall2 ) );

            DelayCommand( 30.0, SetLocalInt( oPLC, "activated", 0 ) );
            DelayCommand( 30.0, SetLocalInt( oBall1, "number", 0 ) );
            DelayCommand( 30.0, SetLocalInt( oBall2, "number", 0 ) );

            DelayCommand( 30.0, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );
        }
        else{

            SpeakString( "*you flick a few switches, but nothing happens*" );

            PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );
        }
    }
}
