// OnOpen event of door.  Automatically closes and locks after 60 seconds.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 09/14/2003 jpavelch         Last Recorded Revision.
//

void main( )
{
    object oDoor = OBJECT_SELF;

    DelayCommand( 40.0, ActionCloseDoor(oDoor) );
    SetLocked( oDoor, TRUE );
    DelayCommand( 41.0, SetLockUnlockDC(oDoor,(25+d12())));
}
