//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: cl_create_trap
//group:
//used as:  OnClose event of a door or PLC. Sets traps and spawns inventory items.
//date: 2009-01-25
//author: disco
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void SetTrap( int nTrap ){

    if ( !GetIsTrapped( OBJECT_SELF ) ){

        CreateTrapOnObject( nTrap, OBJECT_SELF );

        SetTrapDetectable( OBJECT_SELF, TRUE );

        SetTrapDisarmable( OBJECT_SELF, TRUE );

        SetTrapDetectDC( OBJECT_SELF, GetLocalInt( OBJECT_SELF, "ds_detect_dc" ) );

        SetTrapDisarmDC( OBJECT_SELF, GetLocalInt( OBJECT_SELF, "ds_disarm_dc" ) );

        SetTrapOneShot( OBJECT_SELF, TRUE );
    }
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main( ){

    string sTag    = GetLocalString( OBJECT_SELF, "ds_tag" ); //OrcPass
    string sResRef = GetLocalString( OBJECT_SELF, "ds_resref" ); //orckey
    int nTrap      = GetLocalInt( OBJECT_SELF, "ds_trap" );

    if ( sResRef != "" ){

        if ( sTag == "" ){

            sTag = sResRef;
        }

        object oItem = GetItemPossessedBy( OBJECT_SELF, sTag );

        if ( !GetIsObjectValid( oItem ) ){

            CreateItemOnObject( sResRef, OBJECT_SELF );
        }
    }

    if ( nTrap ){

        SetTrap( nTrap );
    }
}
