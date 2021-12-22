// Darkhold :: Spooky Entrance Door - Automatically opens and closes the Darkhold Entrance.
void main( ){

    // Variables
    object oPC      = GetEnteringObject( );
    object oDoor    = GetNearestObjectByTag( "cs_dhold1_d1" );

    // Valid PC
    if( !GetIsPC( oPC ) )
        return;

    // Respawn
    if( GetLocalInt( OBJECT_SELF, "sesame" ) )
        return;

    SetLocalInt( OBJECT_SELF, "sesame", 1 );
    DelayCommand( 21.0, SetLocalInt( OBJECT_SELF, "sesame", 0 ) );

    // Open Sesame!
    AssignCommand( oDoor, ActionOpenDoor( oDoor ) );

    // Cleanup
    DelayCommand( 20.0, AssignCommand( oDoor, ActionCloseDoor( oDoor ) ) );

    return;

}
