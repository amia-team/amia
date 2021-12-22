//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_disarm
//description: gives xp for unlocking doors in dungeon
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

    object oPC = GetLastUnlocked();
    int nDC    = GetLockUnlockDC( OBJECT_SELF );
    int nXP    = nDC * 2;

    if ( GetLocalInt( OBJECT_SELF, GetPCPublicCDKey( oPC, TRUE ) ) != 1 ){

        SendMessageToPC( oPC, "You disarmed a DC"+IntToString( nDC )+" door and earned "+IntToString( nXP )+" XP for you and your party members." );

        GiveRewardToParty( oPC, nXP, 0, "Job" );

        SetLocalInt( OBJECT_SELF, GetPCPublicCDKey( oPC, TRUE ), 1 );
    }
    else{

        SendMessageToPC( oPC, "[You already picked the lock of this door...]" );
    }
}

