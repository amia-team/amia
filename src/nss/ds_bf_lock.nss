//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_bf_lock
//group:   black flag base
//used as: OnClose, takes item in coffin and opens door
//date:    apr 22 2007
//author:  disco

//update:  dec 17 2007      disco       Added a 1 item only check

#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC      = GetLastClosedBy();
    object oItem1   = GetFirstItemInInventory();
    object oItem2   = GetNextItemInInventory();
    string sResRef  = GetLocalString( OBJECT_SELF, "resref" );
    int nNumber     = GetLocalInt( OBJECT_SELF, "number" );
    object oDoor    = GetLocalObject( OBJECT_SELF, "oDoor" );

    if ( !GetIsObjectValid( oItem1 ) || GetIsObjectValid( oItem2 ) ){

        return;
    }

    if ( !GetIsObjectValid( oDoor ) ){

        oDoor    = GetObjectByTag( GetLocalString( OBJECT_SELF, "door" ), 0 );
        SetLocalObject( OBJECT_SELF, "oDoor", oDoor );
    }

    if ( GetObjectType( oDoor ) == OBJECT_TYPE_WAYPOINT ){

        oDoor    = GetObjectByTag( GetLocalString( OBJECT_SELF, "door" ), 1 );
        SetLocalObject( OBJECT_SELF, "oDoor", oDoor );
    }

    if ( GetResRef( oItem1 ) == sResRef ){

        if( GetItemStackSize( oItem1 ) == nNumber ){

            //return item
            CopyItemFixed( oItem1, oPC, TRUE );

            //unlock
            SetLocked( oDoor, FALSE );

            //feedback
            PlaySound( "gui_trapdisarm" );

            //destroy money in coffin
            DestroyObject( oItem1 );

            //delayed relock
            DelayCommand( 20.0, SetLocked( oDoor, TRUE ) );
        }
    }
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------



