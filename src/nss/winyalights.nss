// Winyan Light Script
// Makes the Winyan lights show up at night and fade at day.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/26/2012 Mathias          Initial release.
//


// Feedback function for testing
//void Debug( string sGetMessage ) {
//    sGetMessage = "DEBUG: " + sGetMessage;
//    SendMessageToPC( GetFirstPC(), sGetMessage );
//    SendMessageToAllDMs( sGetMessage );
//    PrintString( sGetMessage );
//}

void main() {

    object oPC = GetEnteringObject();

    if ( GetLocalInt( OBJECT_SELF, "blocker" ) == 1 ) {// To ensure only one is spawned
        return;
    }
    if ( !GetIsPC( oPC ) ) {
        return;
    }

    if ( GetIsDay() ) { // Only works at night
        return;
    }

    // First find the time, and calculate how long until dawn
    int nCurrentHour = GetTimeHour();
    int nTimeToDawn;
    if (nCurrentHour > 17) {
        nTimeToDawn = ( 23 - nCurrentHour ) + 7;
    } else {
        nTimeToDawn = 7 - nCurrentHour;
    }
    float fLightDelay = HoursToSeconds(nTimeToDawn);

    // !!FOR TESTING ONLY!!
    // fLightDelay = 15.0;
//    Debug( "Current hour is " + IntToString( nCurrentHour) + ", and there are " + IntToString( nTimeToDawn ) + " hours to dawn." );
//    Debug( "Delay is set for " + FloatToString( fLightDelay ) + " seconds." );

    // White lights - look for waypoints first
    string sWhiteTag        = "WINYALIGHT_WHITE";
    object oWhiteWaypoint   = GetNearestObjectByTag( sWhiteTag );
    int i                   = 1;

    // Cycle through the waypoints found one by one
    while ( GetIsObjectValid( oWhiteWaypoint ) ){

        // Create the actual orb
        location lCurrentLocation = GetLocation( oWhiteWaypoint );
        object oCurrentLight = CreateObject( OBJECT_TYPE_PLACEABLE, "winyalight2", lCurrentLocation );

        // Apply white light, and destroy the item after the time is up
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_LIGHT_WHITE_5 ), oCurrentLight, (fLightDelay - 0.1 ) ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_GLOW_WHITE ), oCurrentLight, (fLightDelay - 0.1 ) ) );
        DestroyObject( oCurrentLight, fLightDelay );

        // Load the next waypoint
         ++i;
        oWhiteWaypoint = GetNearestObjectByTag( sWhiteTag, OBJECT_SELF, i );

    }
    // White Debug
//    Debug( IntToString( (i-1) ) + " white lights created.");

    // Blue lights - look for waypoints first
    string sBlueTag         = "WINYALIGHT_BLUE";
    object oBlueWaypoint    = GetNearestObjectByTag( sBlueTag );
    i                       = 1;

    // Cycle through the waypoints found one by one
    while ( GetIsObjectValid( oBlueWaypoint ) ){

        // Create the actual orb
        location lCurrentLocation = GetLocation( oBlueWaypoint );
        object oCurrentLight = CreateObject( OBJECT_TYPE_PLACEABLE, "winyalight2", lCurrentLocation );

        // Apply BLUE light, and destroy the item after the time is up
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_LIGHT_BLUE_5 ), oCurrentLight, (fLightDelay - 0.1 ) ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_GLOW_BLUE ), oCurrentLight, (fLightDelay - 0.1 ) ) );
        DestroyObject( oCurrentLight, fLightDelay );

        // Load the next waypoint
         ++i;
        oBlueWaypoint = GetNearestObjectByTag( sBlueTag, OBJECT_SELF, i );

    }
    // Blue Debug
//    Debug( IntToString( (i-1) ) + " blue lights created.");

    // Purple lights - look for waypoints first
    string sPurpleTag       = "WINYALIGHT_PURPLE";
    object oPurpleWaypoint  = GetNearestObjectByTag( sPurpleTag );
    i                       = 1;

    // Cycle through the waypoints found one by one
    while ( GetIsObjectValid( oPurpleWaypoint ) ){

        // Create the actual orb
        location lCurrentLocation = GetLocation( oPurpleWaypoint );
        object oCurrentLight = CreateObject( OBJECT_TYPE_PLACEABLE, "winyalight2", lCurrentLocation );

        // Apply PURPLE light, and destroy the item after the time is up
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_LIGHT_PURPLE_5 ), oCurrentLight, (fLightDelay - 0.1 ) ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_GLOW_PURPLE ), oCurrentLight, (fLightDelay - 0.1 ) ) );
        DestroyObject( oCurrentLight, fLightDelay );

        // Load the next waypoint
         ++i;
        oPurpleWaypoint = GetNearestObjectByTag( sPurpleTag, OBJECT_SELF, i );

    }
    // Purple Debug
//    Debug( IntToString( (i-1) ) + " purple lights created.");

    // Green lights - look for waypoints first
    string sGreenTag       = "WINYALIGHT_GREEN";
    object oGreenWaypoint  = GetNearestObjectByTag( sGreenTag );
    i                       = 1;

    // Cycle through the waypoints found one by one
    while ( GetIsObjectValid( oGreenWaypoint ) ){

        // Create the actual orb
        location lCurrentLocation = GetLocation( oGreenWaypoint );
        object oCurrentLight = CreateObject( OBJECT_TYPE_PLACEABLE, "winyalight2", lCurrentLocation );

        // Apply PURPLE light, and destroy the item after the time is up
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_LIGHT_GREY_5 ), oCurrentLight, (fLightDelay - 0.1 ) ) );
        DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_GLOW_GREEN ), oCurrentLight, (fLightDelay - 0.1 ) ) );
        DestroyObject( oCurrentLight, fLightDelay );

        // Load the next waypoint
         ++i;
        oGreenWaypoint = GetNearestObjectByTag( sGreenTag, OBJECT_SELF, i );

    }
    // Green Debug
//    Debug( IntToString( (i-1) ) + " green lights created.");

    // block and unblock
    SetLocalInt( OBJECT_SELF, "blocker", 1 );
    DelayCommand( fLightDelay, DeleteLocalInt( OBJECT_SELF, "blocker" ) );
}
