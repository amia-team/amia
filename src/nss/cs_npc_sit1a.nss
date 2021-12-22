/*  On Spawn :: NPC Sit After Conversation

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
    NPC will sit at the nearest available seat, after a conversation

*/

void main( ){

    // Variables
    object oNPC             = OBJECT_SELF;
    string szSeatTag        = GetLocalString( oNPC, "Seating" );
    object oSeat            = GetNearestObjectByTag( szSeatTag );

    // Initiate Conversation.
    BeginConversation( );

    // Delayed Action :: Sit
    if( GetIsObjectValid( oSeat ) )
        DelayCommand( 10.0, AssignCommand( oNPC, ActionSit( oSeat ) ) );        // Seat found, sit on it.
    else
        DelayCommand( 10.0, AssignCommand( oNPC, ActionPlayAnimation( ANIMATION_LOOPING_SIT_CROSS ) ) );  // Seat not found, sit on the floor.

    return;

}
