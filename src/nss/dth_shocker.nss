// OnDeath event of the gauntlet shocker.  Re-enables the trigger that
// spawns it.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050214   jking            Refactored constants.

#include "inc_userdefconst"
#include "logger"

void main( )
{
    object oTrigger = GetObjectByTag( "ShockerTrigger" );
    if ( !GetIsObjectValid(oTrigger) ) {
        LogError( "dth_shocker", "Could not find shocker trigger!" );
        return;
    }

    SignalEvent( oTrigger, EventUserDefined(SHOCKER_DEATH) );
}
