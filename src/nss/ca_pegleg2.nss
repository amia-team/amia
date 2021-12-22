/*  Conversation :: 1-legged Pirate: Check : Teleport to Tarkuul

    --------
    Verbatim
    --------
    This script will teleport the player to Tarkuul.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    100506  kfw         Initial release.
    ----------------------------------------------------------------------------

*/


void main( ){

    // Variables.
    object oPC          = GetPCSpeaker( );
    location lDest      = GetLocation( GetWaypointByTag( "wp_cs_tark1_pirate1" ) );
    int nGold           = GetGold( );


    // Check gold status, then teleport.
    if( nGold >= 5000 ){
        TakeGoldFromCreature( 5000, oPC, TRUE );
        AssignCommand( oPC, JumpToLocation( lDest ) );
    }
    else
        SendMessageToPC( oPC, "- Pieces of eight! -" );

    return;

}
