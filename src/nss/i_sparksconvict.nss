// Item event script for Sparks of Convinction - adds 1d10 electrical damage equal
// to rounds of WM level, decrements Ki Damage each use.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 07/07/2012 PaladinOfSune    Initial release.
//

#include "x2_inc_switches"
#include "inc_ds_records"
#include "amia_include"

void ActivateItem( )
{
    // Major variables.
    object oPC  = GetItemActivator();
    int nLevel  = GetLevelByClass( CLASS_TYPE_WEAPON_MASTER, oPC );

    // Return if PC has no more Ki Damage uses.
    if ( !GetHasFeat( FEAT_KI_DAMAGE, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
        return;
    }

    // Prevent stacking.
    if ( GetIsBlocked( oPC, "sparked_on" ) > 0 ) {
        FloatingTextStringOnCreature( "<cþ>- You are already under this effect! -</c>", oPC, FALSE );
        return;
    }

    // Effect variables.
    effect eDamage  = EffectDamageIncrease( DAMAGE_BONUS_1d10, DAMAGE_TYPE_ELECTRICAL );
    effect eDur     = EffectVisualEffect( VFX_DUR_GLOW_WHITE );
    effect eVis1    = EffectVisualEffect( 463 );
    effect eLink    = EffectLinkEffects( eDamage, eDur );

    // Apply it together.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ExtraordinaryEffect( eLink ), oPC, RoundsToSeconds( nLevel ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVis1, oPC, 1.0 );

    // Decrement a feat usage.
    DecrementRemainingFeatUses( oPC, FEAT_KI_DAMAGE );

    // Set stackage prevention time.
    SetBlockTime( oPC, 0, FloatToInt( RoundsToSeconds( nLevel ) ), "sparked_on" );
}

void main( ){
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;

        case X2_ITEM_EVENT_EQUIP:

            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
    }
}
