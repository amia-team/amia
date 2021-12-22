// Item event script for Life Feasting.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 10/28/2013 PaladinOfSune    Initial release.
//

#include "x2_inc_switches"
#include "inc_ds_records"
#include "amia_include"


void ActivateItem( )
{
    // Major variables.
    object oPC      = GetItemActivator();

    // Remove two Turn Undead uses.
    int x;
    for ( x = 0; x < 2; x++ ) {
        if( !GetHasFeat( FEAT_TURN_UNDEAD, oPC ) ) {
            FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
            return;
        }
        DecrementRemainingFeatUses( oPC, FEAT_TURN_UNDEAD );
    }

    int nDuration   = GetLevelByClass( CLASS_TYPE_BLACKGUARD, oPC ) / 2;

    effect eBonus1  = EffectRegenerate( 1, 6.0 );
    effect eBonus2  = EffectImmunity( IMMUNITY_TYPE_DEATH );
    effect eVFX1    = EffectVisualEffect( 378 );
    effect eVFX2    = EffectVisualEffect( 1046 );

    effect eLink    = EffectLinkEffects( eBonus1, eBonus2 );
    eLink           = EffectLinkEffects( eVFX1, eLink );

    ExtraordinaryEffect( eLink );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, TurnsToSeconds( nDuration ) );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eVFX2, oPC, 3.0 );
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent )
    {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;

        case X2_ITEM_EVENT_EQUIP:
            log_to_exploits( GetPCItemLastEquippedBy(), "Equipped: "+GetName(GetPCItemLastEquipped()), GetTag(GetPCItemLastEquipped()) );
            break;
    }
}
