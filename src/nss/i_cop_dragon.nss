// Item event script for The Final Ritual. Shifts into a copper dragon for
// Hours/level.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/23/2011 PaladinOfSune    Initial release.
//

#include "x2_inc_switches"
#include "amia_include"

void ActivateItem( )
{
    // Declare variables
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    // Visual effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( 683 ), oPC );

    // Variables
    effect ePoly = EffectPolymorph( 195 );
    ePoly = SupernaturalEffect( ePoly );

    // Shift 'em!
    DelayCommand( 3.0, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePoly, oPC, NewHoursToSeconds( GetHitDice( oPC ) ) ) );
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
