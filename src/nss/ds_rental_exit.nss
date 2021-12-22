//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_exit
//group: rentable housing
//used as: area exit script
//date: 2009-09-04
//author: disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_rental"


void CleanUpHouse( object oPC, object oHouse ){

    object oDoorOut  = GetLocalObject( oHouse, RNT_DOOR );
    object oDoorIn   = GetLocalObject( oDoorOut, RNT_TARGET );

    SendMessageToPC( oPC, "Debug: CleanUpHouse: Removing "+GetTag( oDoorOut )+" on "+GetName( oHouse )+"." );

    DeleteLocalObject( oDoorIn, RNT_TARGET );
    DeleteLocalString( oDoorOut, RNT_OWNER );
    DeleteLocalString( oHouse, RNT_OWNER );
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    // Variables.
    object oHouse       = OBJECT_SELF;
    object oPC          = GetExitingObject( );
    int nCount          = GetLocalInt( oHouse, "PlayerCount" ) - 1;

    if( !GetIsPC( oPC ) ){

        return;
    }

    if ( nCount <= 0 ){

        nCount = 0;
    }

    SetLocalInt( oHouse, "PlayerCount", nCount );

    //record last exit time + 5 mins
    SetLocalInt( oHouse, RNT_TIMESTAMP, GetRunTime( 5 ) );

    return;
}

