// Shifts the user in a hybrid werecat shape permanently.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/08/2012 PaladinOfSune    Initial Release
//

#include "x2_inc_switches"
#include "amia_include"
#include "x2_inc_itemprop"

void ActivateItem( )
{
    // Declare variables
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    // Visual effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_POLYMORPH ), oPC );

    // Variables
    effect ePoly = EffectPolymorph( 198 );
    ePoly = SupernaturalEffect( ePoly );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, ePoly, oPC );
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
