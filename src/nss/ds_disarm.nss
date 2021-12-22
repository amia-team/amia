//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_disarm
//description: disarms random traps in dungeon
//used as: OnEnter script
//date:    oct 23 2007
//author:  disco
//notes:  make sure you test this on Hardcore rules difficulty!

// 2009-05-26   Disco Added some anti exploit measures

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

    object oPC      = GetLastDisarmed();
    object oTrigger = GetLocalObject( OBJECT_SELF, "spt_obj" );
    int nDC         = GetTrapDisarmDC( OBJECT_SELF );
    int nXP         = nDC * 2;


    if ( GetLocalInt( oTrigger, GetPCPublicCDKey( oPC, TRUE ) ) == 1 ){

        SendMessageToPC( oPC, "You only get disarm XP for this trap once a reset." );
    }
    else{

        SetLocalInt( oTrigger, GetPCPublicCDKey( oPC, TRUE ), 1 );

        SendMessageToPC( oPC, "You disarmed a DC"+IntToString( nDC )+" trap and earned "+IntToString( nXP )+" XP for you and your party members." );

        GiveRewardToParty( oPC, nXP, 0, "Job" );
    }
}

