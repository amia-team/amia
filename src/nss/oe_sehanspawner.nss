// OnEvent event of the trigger at Crystal Lake.
// Spawns an idol of Sehanine at night if they have her set as their deity.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/10/2011 PaladinOfSune    Initial release.
//


void main() {

    object oPC = GetEnteringObject();

    if ( GetLocalInt( OBJECT_SELF, "blocker" ) == 1 ) {// To ensure only one is spawned
        return;
    }
    if ( !GetIsPC( oPC ) ) {
        return;
    }
    if ( GetDeity( oPC ) != "Sehanine Moonbow" ) { // Only for those of her faith
        return;
    }
    if ( GetIsDay() ) { // Only works at night
        return;
    }

    object oWaypoint = GetWaypointByTag( "sehanine_spawner" );
    location lLoc = GetLocation( oWaypoint );

    // Create the idol and give it a light VFX.
    object oIdol = CreateObject( OBJECT_TYPE_PLACEABLE, "idol_sehan", lLoc );
    DelayCommand( 0.1, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectVisualEffect( VFX_DUR_LIGHT_WHITE_20 ), oIdol, 119.9 ) );

    // Destroy after an hour IG and allow it to be used again.
    DestroyObject( oIdol, 120.0 );
    SetLocalInt( OBJECT_SELF, "blocker", 1 );
    DelayCommand( 120.0, DeleteLocalInt( OBJECT_SELF, "blocker" ) );
}
