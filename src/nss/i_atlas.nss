// Item event script for the Atlas. It reveals the minimap for the target.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/10/2011 PaladinOfSune    Initial release.
//

#include "x2_inc_switches"

void ActivateItem( )
{
    // Declare variables
    object oPC     = GetItemActivator( );
    object oTarget = GetItemActivatedTarget( );

    // Prevent stacking.
    if ( !GetIsPC( oTarget ) ) {
        FloatingTextStringOnCreature( "<cþ>- Invalid target. -</c>", oPC, FALSE );
        return;
    }

    ExploreAreaForPlayer( GetArea( oTarget ), oTarget, TRUE );
    FloatingTextStringOnCreature( "You reveal the area details for "+ GetName( oTarget ) + "!", oPC, FALSE );
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
