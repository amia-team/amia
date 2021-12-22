// Gives the user 25% acid immunity for 24 hours. Stackable, though there are limited uses
// on the item.
//
// Revision History
// Date       Name             Description
// ---------- -----------------------------------------------------------
// 12/03/2005 PoS              Initial release.
// 07/23/2012 PoS              Rewrote to be less... terrible.
//
#include "x2_inc_switches"
#include "amia_include"

void ActivateItem()
{
    object oUser = GetItemActivator();

    // Variables.
    effect eVFX1   = EffectVisualEffect( VFX_IMP_PULSE_NATURE );
    effect eVFX2   = EffectVisualEffect( VFX_DUR_FREEDOM_OF_MOVEMENT );
    effect eAcid   = EffectDamageImmunityIncrease( DAMAGE_TYPE_ACID, 25 );

    effect eBoost  = EffectLinkEffects( eVFX2, eAcid );

    // Apply the effect
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oUser );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBoost, oUser, NewHoursToSeconds( 24 ) );
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
