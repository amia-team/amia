// Item event script for Wielded Passion - adds 1d10 fire damage equal
// to rounds of WM level, decrements Ki Damage each use.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 01/22/2011 PaladinOfSune    Initial release.
// 03/14/2011 PaladinOfSune    Fixes.
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
    if ( GetIsBlocked( oPC, "wielded_on" ) > 0 ) {
        FloatingTextStringOnCreature( "<cþ>- You are already under this effect! -</c>", oPC, FALSE );
        return;
    }

    // Effect variables.
    effect eDamage  = EffectDamageIncrease( DAMAGE_BONUS_1d10, DAMAGE_TYPE_FIRE );
    effect eDur     = EffectVisualEffect( VFX_DUR_GLOW_LIGHT_RED );
    effect eVis1    = EffectVisualEffect( VFX_IMP_DIVINE_STRIKE_HOLY );
    effect eVis2    = EffectVisualEffect( VFX_IMP_FLAME_M );
    effect eVis3    = EffectVisualEffect( VFX_IMP_PULSE_FIRE );
    effect eVis4    = EffectVisualEffect( VFX_IMP_HEAD_FIRE );

    effect eLink    = EffectLinkEffects( eDamage, eDur );

    // Apply it together.
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ExtraordinaryEffect( eLink ), oPC, RoundsToSeconds( nLevel ) );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis1, oPC );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis3, oPC );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis4, oPC );
    DelayCommand( 1.0f, ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis2, oPC ) );

    // Decrement a feat usage.
    DecrementRemainingFeatUses( oPC, FEAT_KI_DAMAGE );

    // Set stackage prevention time.
    SetBlockTime( oPC, 0, FloatToInt( RoundsToSeconds( nLevel ) ), "wielded_on" );
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
