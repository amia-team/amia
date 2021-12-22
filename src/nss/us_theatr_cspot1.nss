/*  Mystra's Grove Theatre Center Spotlight Lever

    --------
    Verbatim
    --------
    This script will operate Mystra's Grove Theatre center spotlight.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    050306  kfw         Initial Release.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables
    object oLever           = OBJECT_SELF;
    object oDest            = GetWaypointByTag( "wp_mystratheatr_lite1" );

    // On, Toggle off.
    if( GetLocalInt( oLever, "spawned" ) ){

        // Lever anim off.
        PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE );

        // Toggle off.
        DestroyObject( GetNearestObjectByTag( "cs_plc_thtrl1" ) );

        // Set the control integer.
        SetLocalInt( oLever, "spawned", 0 );

    }
    // Off, Toggle on.
    else{

        // Lever anim on.
        PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );

        // Toggle on.
        CreateObject( OBJECT_TYPE_PLACEABLE, "cs_plc_thtrl1", GetLocation( oDest ) );

        // Set the control integer.
        SetLocalInt( oLever, "spawned", 1 );

    }

    return;

}
