// User-defined events for gauntlet shocker spawn trigger.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 20050130   jking            Hook into standard handler (end)

#include "area_constants"


void DoShockerDeath( )
{
    object oTrigger = OBJECT_SELF;
    SetLocalInt( oTrigger, "SpawnDisabled", FALSE );
}


void main( )
{
    int nEvent = GetUserDefinedEventNumber( );
    switch ( nEvent ) {
        case SHOCKER_DEATH:  DelayCommand( 300.0, DoShockerDeath() );   break;
        default:             AreaHandleUserDefinedEventDefault(nEvent); break;
    }
}
