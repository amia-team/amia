// Script to shift user into a red wyrmling for six hours.

#include "x2_inc_switches"
#include "amia_include"

void ActivateItem( )
{
    // Declare variables
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    // Visual effect
    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect( VFX_IMP_POLYMORPH ),
        oPC
    );

    // Variables
    effect ePoly = EffectPolymorph( 54 );
    ePoly = SupernaturalEffect( ePoly );

    // Shift 'em!
    ApplyEffectToObject(
        DURATION_TYPE_TEMPORARY,
        ePoly,
        oPC,
        NewHoursToSeconds(6)
    );
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
