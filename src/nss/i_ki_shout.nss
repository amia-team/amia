// Ki Shout
// 16 Monk levels - 1x Quivering Palm per use
//
// Stuns any enemies within colossal range if they fail a Will
// save [DC: 10 + Monk level / 2 + WIS modifier]. In addition, all enemies take
// 1d4 Sonic damage per Monk level. Deafened enemies are not affected.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/01/2016 PaladinOfSune    Rewritten, rebalanced
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
void DoKiShout();

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

void ActivateItem( ) {

    object oPC = GetItemActivator();

    if( !GetHasFeat( FEAT_QUIVERING_PALM, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
        return;
    }

    DecrementRemainingFeatUses( oPC, FEAT_QUIVERING_PALM );

    RemoveInvisEffects( oPC );

    AssignCommand( oPC, DoKiShout() );
}

void RemoveInvisEffects( object oPC ) {

    effect eEffect = GetFirstEffect( oPC );
    int nType;
    while( GetIsEffectValid( eEffect ) ) {
        nType = GetEffectType( eEffect );
        if( nType == EFFECT_TYPE_INVISIBILITY || nType == EFFECT_TYPE_ETHEREAL || nType == EFFECT_TYPE_SANCTUARY ) {
            RemoveEffect( oPC, eEffect );
        }
        eEffect = GetNextEffect( oPC );
    }
}

void DoKiShout() {

    object oPC = OBJECT_SELF;
    location lLocation = GetLocation( oPC );

    int nLevel = GetLevelByClass( CLASS_TYPE_MONK, oPC );
    int nDC = 10 + ( nLevel / 2 ) + GetAbilityModifier( ABILITY_WISDOM, oPC );

    effect eLink = EffectLinkEffects( EffectStunned(), EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED ) );

    float fDelay;

    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_FNF_LOS_NORMAL_30 ), oPC );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SONIC ), oPC );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation, FALSE, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid( oTarget ) ) {

        if( GetIsEnemy( oTarget, oPC ) ) {

            if( !GetHasEffect( EFFECT_TYPE_SILENCE, oTarget ) && !GetHasEffect( EFFECT_TYPE_DEAF, oTarget ) ) {

                fDelay = GetDistanceBetweenLocations( lLocation, GetLocation( oTarget ) ) / 20;

                if( WillSave( oTarget, nDC, SAVING_THROW_TYPE_SONIC, oPC ) < 1 ) {
                    DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( 3 ) ) );
                }

                DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectDamage( d4( nLevel ), DAMAGE_TYPE_SONIC ), oTarget ) );
                DelayCommand(fDelay, ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_COM_HIT_SONIC ), oTarget ) );
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lLocation, FALSE, OBJECT_TYPE_CREATURE );
    }
}
