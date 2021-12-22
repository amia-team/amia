// OnUsed event of Nexus Forest's crystal barrier.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/09/2011 PaladinOfSune    Initial release.
//

// Has a wrapper for delaying the CreateObject function. Yoink!
#include "nw_i0_2q4luskan"

void main()
{
    // Variables.
    object oPlc     = GetObjectByTag( "nexus_barrier" );
    object oPC      = GetLastUsedBy( );
    object oKey     = GetItemPossessedBy( oPC, "TheNatureofFaith" );
    location lLoc   = GetLocation( oPlc );

    // Return if the PC lacks the key.
    if( !GetIsObjectValid( oKey ) ) {
        FloatingTextStringOnCreature( "<cþ>- The barrier does not respond. -</c>", oPC, FALSE );
        return;
    }
    // Just to make sure it isn't spammed...
    else if ( GetLocalInt( OBJECT_SELF, "barrier_down" ) == 1 ) {
        return;
    }
    else {
        // Destroy the nearby barrier and make this object unuseable.
        DestroyObject( oPlc );
        SetLocalInt( OBJECT_SELF, "barrier_down", 1 );
        SetUseableFlag( OBJECT_SELF, FALSE );

        // Spawn another in x seconds.
        DelayCommand( 300.0f, SetUseableFlag( OBJECT_SELF, TRUE ) );
        DelayCommand( 300.0f, SetLocalInt( OBJECT_SELF, "barrier_down", 0 ) );

        DelayCommand( 300.0f,
            AssignCommand( OBJECT_SELF, CreateObjectVoid( OBJECT_TYPE_PLACEABLE, "nexus_barrier", lLoc ) )
        );
    }
}
