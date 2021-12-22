//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC = OBJECT_SELF;

    int nInsanityPoints = GetPCKEYValue( oPC, "insanity" );

    if ( !nInsanityPoints ){

        return;
    }


    nInsanityPoints += d6();

    string sEmote;
    int nAnimation;


    switch ( nInsanityPoints ) {

        case  1:    sEmote = "";    break;
        case  2:    sEmote = "";    break;
        case  3:    sEmote = "";    break;
        case  4:    sEmote = "*rolls eyes*";    break;
        case  5:    sEmote = "*mutters something*";    break;
        case  6:    sEmote = "Huh?";  nAnimation = ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD;  break;
        case  7:    sEmote = "Why are you looking at me that way.. huh?!"; nAnimation = ANIMATION_LOOPING_TALK_FORCEFUL;  break;
        case  8:    sEmote = "I know... things about you, yes. You father, he had blue eyes, yes? As blue as drowned babies, yes yes!";    break;
        case  9:    sEmote = "Hzzzgrhihihi!"; ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectConfused(), oPC, 120.0 );  break;
        case 10:    sEmote = RandomName()+", my best friend! O, I remember him well!";    break;
        case 11:    sEmote = "I hear... voices... they speak to me, yes. Hihi.";  nAnimation = ANIMATION_LOOPING_LISTEN;  break;
        case 12:    sEmote = "They are EVERYWHERE! Away! Away!"; ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectFrightened(), oPC, 120.0 );  break;
        case 13:    sEmote = "*sits down and starts to cry*"; nAnimation = ANIMATION_LOOPING_MEDITATE; break;
        case 14:    sEmote = "Who are you? Where am I? I want to go home!";    break;
        case 15:    sEmote = "*drops*"; nAnimation = ANIMATION_LOOPING_DEAD_FRONT; break;
        case 16:    sEmote = "*drops*"; nAnimation = ANIMATION_LOOPING_DEAD_BACK; break;
    }

    if ( sEmote != "" ){

        SpeakString( sEmote );
    }

    if ( nAnimation ){

        ClearAllActions( TRUE );

        DelayCommand( 0.2, PlayAnimation( nAnimation, 1.0, 30.0 ) );

        DelayCommand( 0.4, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 15.0 ) );
    }

    DelayCommand( IntToFloat( 120 + d100( 8 ) ), ExecuteScript( "rua_insanity", oPC ) );
}
