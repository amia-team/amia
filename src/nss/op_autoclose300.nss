// OnOpen event of door.  Automatically closes after 300 seconds.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Initial Release.
//2008-05-05  disco            Added DM block option
//

void main( ){

    object oDoor = OBJECT_SELF;

    if ( GetLocalInt( oDoor, "blocked" ) ){

        return;
    }

    DelayCommand( 300.0, ActionCloseDoor( oDoor ) );
}

