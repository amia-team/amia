// Lesser Decoy item event script.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/15/2004 jpavelch         Initial Release
// 10/17/2004 jpavelch         Added two minute self-distruct.
// 20050214   jking            Refactored constants.

#include "inc_userdefconst"
#include "x2_inc_switches"


// Creates a combat dummy decoy
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    location lLocation = GetItemActivatedTargetLocation( );

    object oDecoy = CreateObject(
                        OBJECT_TYPE_CREATURE,
                        "lesserdecoy",
                        lLocation
                    );
    SetLocalObject( oDecoy, "Creator", oPC );
    SignalEvent( oDecoy, EventUserDefined(INITIALIZE) );
    DestroyObject( oDecoy, 120.0 );
}


void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}
