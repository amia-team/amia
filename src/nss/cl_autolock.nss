// OnClose event of a placeable object.  Automatically relocks it.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/03/2004 jpavelch         Initial Release.
//


void close_and_lock( ){

    if ( GetIsOpen( OBJECT_SELF ) == TRUE ){

        ActionCloseDoor( OBJECT_SELF );
        SetLocked( OBJECT_SELF, TRUE );
    }
    else{


        SetLocked( OBJECT_SELF, TRUE );
    }
}

void main( ){


    DelayCommand( GetLocalFloat( OBJECT_SELF, "ds_delay" ), close_and_lock() );
}



