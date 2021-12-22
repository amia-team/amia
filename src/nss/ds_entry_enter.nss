/*
tha_area_enter

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
Stripped area enter for entry.

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
2008-10-05     disco      Start of header

------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    // Variables.
    object oArea        = OBJECT_SELF;
    object oPC          = GetEnteringObject( );

    if( GetIsDM( oPC ) ) WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - ds_entry_enter 36: DM has reached the OnEnter of the Entry area." );

    // Bug out on non-PC
    if( !GetIsPC( oPC ) ){

        return;
    }

    if ( ResolveTransport( oPC, oArea ) == FALSE ){

        UpdatePlayerRunTime( oPC, GetModule() );
    }

    return;
}
