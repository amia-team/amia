//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_actions
//group:   transmutation
//used as: action script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_car"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void DelayedCure( object oPC, int nTry=1 );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC  = GetPCSpeaker();
    string sTag = GetTag( OBJECT_SELF );


    if ( sTag == "winyatemple" ){

        AssignCommand( oPC, PlayAnimation( ANIMATION_FIREFORGET_DRINK ) );

        DeductInsanity( oPC );
    }
    else if ( sTag == "car_chair" ){

        DelayCommand( 10.0, DelayedCure( oPC ) );
    }
}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void DelayedCure( object oPC, int nTry=1 ){

    object oChair = GetLocalObject( OBJECT_SELF, "chair" );

    if ( !GetIsObjectValid( oChair ) ){

        oChair = GetNearestObjectByTag( "car_chair" );

        SetLocalObject( OBJECT_SELF, "chair", oChair );
    }

    if ( GetSittingCreature( oChair ) == oPC ){

        DeductInsanity( oPC );

        effect eVis = EffectVisualEffect( 73 + d3() );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
    }
    else{

        SpeakString( "ON THE CHAIR! By the gods, are you INSANE or DEAF?!" );

        return;
    }

    ++nTry;

    if ( nTry == 5 ){

        SpeakString( "I really have to stop now... this is becoming highly irresponsible. Well... one more try, hihi!" );
    }
    else if ( nTry == 4 ){

        SpeakString( "Burn! Burn, baby, burn! Did I tell you to stay on the chair?" );
    }
    else if ( nTry == 3 ){

        SpeakString( "Isn't science a hoot? Whoohoo... and stay in that chair!" );
    }
    else if ( nTry == 2 ){

        SpeakString( "Stay seated! I will have another try! Haha!" );
    }
    else if ( nTry == 1 ){

        SpeakString( "There we go! Please remain seated for the next application" );
    }
    else{

        SpeakString( "Arghh... I hear Father Darien coming! I must stop the chair!" );
        return;
    }


    DelayCommand( 10.0, DelayedCure( oPC, nTry ) );
}
