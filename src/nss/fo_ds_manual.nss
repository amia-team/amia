//used as: OnUnlock
//date:    oct 23 2007
//author:  disco
//notes:  make sure you test this on Hardcore rules difficulty!


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC = GetClickingObject();

    if ( GetLocalInt( OBJECT_SELF, GetPCPublicCDKey( oPC, TRUE ) ) != 1 ){

        SendMessageToPC( oPC, "[You can either pick the lock of this door for XP, or bash the door in. Once you opened the door simply using it again will allow access.]" );
    }
    else{

        SetLocked( OBJECT_SELF, FALSE );

        SendMessageToPC( oPC, "[You have cracked this door during this session. Opening it for you.]" );

        PlayAnimation(  ANIMATION_DOOR_OPEN1 );

        DelayCommand( 12.0, PlayAnimation(  ANIMATION_DOOR_CLOSE ) );

        DelayCommand( 13.0, SetLocked( OBJECT_SELF, TRUE ) );
    }
}
