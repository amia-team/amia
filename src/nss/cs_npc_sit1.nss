/*  On Spawn :: NPC Sit

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032906  kfw         Initial release.
    071506  kfw         Improvements: No seat found, sit on the floor instead.
    ----------------------------------------------------------------------------

    --------
    Verbatim
    --------
    NPC will sit at the nearest available seat.

*/

void main( ){

    // Variables
    object oNPC             = OBJECT_SELF;
    string szSeatTag        = GetLocalString( oNPC, "Seating" );
    object oSeat            = GetNearestObjectByTag( szSeatTag );

    // Action :: Sit
    if( GetIsObjectValid( oSeat ) )
        AssignCommand( oNPC, ActionSit( oSeat ) );     // Seat found, sit on it.
    else
        AssignCommand( oNPC, ActionPlayAnimation( ANIMATION_LOOPING_SIT_CROSS ) );  // Seat not found, sit on the floor.

    return;

}
