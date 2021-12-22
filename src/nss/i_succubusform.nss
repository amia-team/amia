// Succubus form item event script.


#include "x2_inc_switches"


// Succubus polymorph.
//
void ActivateItem( )
{
    object oPC = GetItemActivator( );
    object oItem = GetItemActivated( );

    ApplyEffectToObject(
        DURATION_TYPE_INSTANT,
        EffectVisualEffect( VFX_IMP_POLYMORPH ),
        oPC
    );

    effect ePoly = EffectPolymorph( 112 );
    ePoly = SupernaturalEffect( ePoly );
    ApplyEffectToObject(
        DURATION_TYPE_PERMANENT,
        ePoly,
        oPC
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
