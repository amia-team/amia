// Item event script for Winter's Might. Same effect as Abyssal Might, but gives 50% cold immunity in exchange for
// using up two uses of Turn Undead.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 06/12/2014 PaladinOfSune    Initial release.
// 09/09/2017 PaladinOfSune    Changed duration to hours to match Abyssal Might.
//

#include "x2_inc_switches"
#include "inc_ds_records"
#include "amia_include"

void ActivateItem( )
{
    // Major variables.
    object oPC  = GetItemActivator();

    // Remove two Turn Undead uses.
    int x;
    for ( x = 0; x < 2; x++ ) {
        if( !GetHasFeat( FEAT_TURN_UNDEAD, oPC ) ) {
            FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
            return;
        }
        DecrementRemainingFeatUses( oPC, FEAT_TURN_UNDEAD );
    }

    effect eSTR  =  EffectAbilityIncrease( ABILITY_STRENGTH, 2 );
    effect eCON  =  EffectAbilityIncrease( ABILITY_CONSTITUTION, 2 );
    effect eDEX  =  EffectAbilityIncrease( ABILITY_DEXTERITY, 2 );
    effect eCold =  EffectDamageImmunityIncrease( DAMAGE_TYPE_COLD, 50 );

    effect eVFX  = EffectVisualEffect( VFX_IMP_PULSE_COLD );
    effect eDur1 = EffectVisualEffect( VFX_DUR_ICESKIN );
    effect eDur2 = EffectVisualEffect( VFX_DUR_GHOST_SMOKE_2 );
    effect eDur3 = EffectVisualEffect( 695 );

    int nDuration = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC );

    effect eLink = EffectLinkEffects( eSTR, eCON );
    eLink = EffectLinkEffects( eDEX, eLink );
    eLink = EffectLinkEffects( eCold, eLink );
    eLink = EffectLinkEffects( eDur1, eLink );
    eLink = EffectLinkEffects( eDur2, eLink );
    eLink = EffectLinkEffects( eDur3, eLink );

    ExtraordinaryEffect( eLink );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, HoursToSeconds( nDuration ) );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oPC );

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
