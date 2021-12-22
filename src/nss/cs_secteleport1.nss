/*  Trigger :: OnEnter : Evil-only Entry Teleporter

    --------
    Verbatim
    --------
    This script will teleport an evil-aligned player to some waypoint destination (tag stored on the trigger itself).
    Also, you must possess the mirror key.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    090906  kfw         Initial release.
    091106  kfw         Added mirror key.
    ----------------------------------------------------------------------------

*/


void main( ){

    // Variables.
    object oTrigger     = OBJECT_SELF;
    object oPC          = GetEnteringObject( );
    object oKey         = GetItemPossessedBy( oPC, "trk_councilkey" );
    int nAlignment      = GetAlignmentGoodEvil( oPC );
    string szDestTag    = GetLocalString( oTrigger, "dest" );

    object oDest        = GetWaypointByTag( szDestTag );
    location lDest      = GetLocation( oDest );

    // Destination and teleporting player valid; and player has an evil alignment, then teleport the player
    if( GetIsObjectValid( oDest ) && GetIsPC( oPC ) && GetIsObjectValid( oKey ) ){

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_HARM ), oPC, 0.0 );

        DelayCommand( 0.3, AssignCommand( oPC, JumpToLocation( lDest ) ) );

    }

    else
        SendMessageToPC( oPC, "- Some force prevents you from using this portal! -" );

    return;

}
