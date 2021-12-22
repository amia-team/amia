// Grove Treetop Swinging Rope :: The player can swing on a rope to some place.
void main( ){

    // Variables
    object oPC      = GetEnteringObject( );
    object oDest    = GetWaypointByTag( "wp_grv_treeptop1" );

    // Rope destination valid
    if( GetIsObjectValid( oDest ) ){

        // Swing (teleport) the player to it.
        AssignCommand( oPC, JumpToLocation( GetLocation( oDest ) ) );

        // Notify the player
        SendMessageToPC( oPC, "- You swing across to the other side~! -" );

    }

    return;

}
