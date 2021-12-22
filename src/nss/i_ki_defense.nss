// Ki Defense
// 18 Monk levels - 1x Empty Body per use
//
// Any enemies that strike with a melee attack take 1d6 + 2 per 5 Monk Levels
// of magic damage [caps at 1d6 + 10]. Lasts for Monk Level/Round.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/01/2016 PaladinOfSune    Rewritten, rebalanced
//
//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_switches"
#include "x0_i0_spells"

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------
void RemoveInvisEffects( object oPC );
void ActivateItem();
void DoKiDefense();

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {
        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem();
            break;
    }
}

void ActivateItem( )
{
    object oPC = GetItemActivator();
    object oTarget = GetItemActivatedTarget();

    if( !GetHasFeat( FEAT_EMPTY_BODY, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
        return;
    }

    int nKiDefense = GetLocalInt( oPC, "Ki_Defense" );
    if( nKiDefense == 1 ) {
        FloatingTextStringOnCreature( "<cþ  >- You are already under the effect of Ki Defense! -</c>", oPC, FALSE );
        return;
    }

    DecrementRemainingFeatUses( oPC, FEAT_EMPTY_BODY );

    AssignCommand( oPC, DoKiDefense( ) );
}

void DoKiDefense( ) {

    object oPC = OBJECT_SELF;
    int nLevel = GetLevelByClass( CLASS_TYPE_MONK, oPC );

    int nDamage = ( nLevel / 5 ) * 2;

    if ( nDamage < 2 ) {
        nDamage = 2;
    } else if ( nDamage > 10 ) {
        nDamage = 10;
    }

    effect eShield = EffectDamageShield( nDamage, DAMAGE_BONUS_1d6, DAMAGE_TYPE_MAGICAL );
    effect eLink = EffectLinkEffects( eShield, EffectVisualEffect( VFX_DUR_PDK_FEAR ) );

    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ExtraordinaryEffect( eLink ), oPC, RoundsToSeconds( nLevel ) );

    SetLocalInt( oPC, "Ki_Defense", 1 );
    DelayCommand( RoundsToSeconds( nLevel ), SetLocalInt( oPC, "Ki_Defense", 0 ) );
}
