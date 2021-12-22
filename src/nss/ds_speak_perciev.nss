//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_speak_percieve
//group:   on percieve
//used as: generic one line announcements with cool down timer
//date:    july 07 2007
//author:  disco


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


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


void main(){

    object oPC     = GetLastSpeaker();
    object oTarget = OBJECT_SELF;
    string sTag    = GetLocalString( OBJECT_SELF, "ds_target" );


    if ( GetIsBlocked( ) > 0 ){

        return;
    }

    SetBlockTime( OBJECT_SELF, 0, 120 );


    if ( sTag != "" && GetLocalObject( OBJECT_SELF, "ds_target" ) == OBJECT_INVALID ){

        oTarget = GetNearestObjectByTag( sTag );

        if ( GetIsObjectValid( oTarget ) ){

            SetLocalObject( OBJECT_SELF, "ds_target", oTarget );
        }
    }
    else if ( sTag != "" ){

        oTarget = GetLocalObject( OBJECT_SELF, "ds_target" );
    }


    string sLine  = GetLocalString( OBJECT_SELF, "ds_speak" );
    int nLines    = GetLocalInt( OBJECT_SELF, "ds_speak" );
    vector vFace  = GetPosition( oPC );

    SetFacingPoint( vFace );

    if ( sLine != "" ){

        AssignCommand( oTarget, SpeakString( sLine ) );
    }
    else if ( nLines ){

        sLine = GetLocalString( OBJECT_SELF, "ds_speak_"+IntToString( Random( nLines ) + 1 ) );

        AssignCommand( oTarget, SpeakString( sLine ) );
    }
}
