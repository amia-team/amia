// OnEnter event of Gauntlet Shocker spawn trigger.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/31/2004 jpavelch         Initial release.
//

#include "logger"

// Returns TRUE if this trigger is currently disabled.
//
int GetIsDisabled( )
{
    object oTrigger = OBJECT_SELF;
    return GetLocalInt( oTrigger, "SpawnDisabled" );
}

// Sets the disabled state of this trigger.
//
void SetIsDisabled( int isDisabled )
{
    object oTrigger = OBJECT_SELF;
    SetLocalInt( oTrigger, "SpawnDisabled", isDisabled );
}


void main( )
{
    object oPC = GetEnteringObject( );
    if ( !GetIsPC(oPC) ) return;

    if ( GetIsDisabled() ) return;

    object oTrigger = OBJECT_SELF;

    object oSpawn = GetWaypointByTag( "wp_spawnshocker" );
    if ( !GetIsObjectValid(oSpawn) ) {
        LogError( "en_shocktrigger", "Could not find shocker spawn waypoint!" );
        return;
    }

    CreateObject(
        OBJECT_TYPE_PLACEABLE,
        "gauntletshocker",
        GetLocation(oSpawn)
    );

    // Set a 5 minute countdown to automatically destroy the Shocker so that its heartbeat cannot continue indefinately
    DelayCommand(
        300.0,
        ExecuteScript(
            "dth_shocker",
            OBJECT_SELF));

    SetIsDisabled( TRUE );
    // Trigger will be re-enabled when shocker is destroyed.
}
