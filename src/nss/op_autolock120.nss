// OnOpen event of door.  Automatically closes and locks after 120 seconds.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Last Recorded Revision.
//2008-05-05  disco            Added DM block option
//

void main( ){

    object oDoor = OBJECT_SELF;

    if ( GetLocalInt( oDoor, "blocked" ) ){

        return;
    }

    DelayCommand( 120.0, ActionCloseDoor( oDoor ) );
    SetLocked( oDoor, TRUE );
}

