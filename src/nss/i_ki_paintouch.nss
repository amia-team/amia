// Pain Touch
// 3 Monk levels - 1x Stunning Fist per use
//
// Touch Attack. On hit, inflicts an AB penalty of 1 per 5 Monk levels
// [caps at -6] for Monk Level/Round. Unstackable.
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
void DoPainTouch( object oTarget );

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

    if ( GetObjectType( oTarget ) != OBJECT_TYPE_CREATURE || !GetIsEnemy( oTarget, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You must target an enemy creature! -</c>", oPC, FALSE );
        return;
    }

    if( !GetHasFeat( FEAT_STUNNING_FIST, oPC ) ) {
        FloatingTextStringOnCreature( "<cþ>- You do not have any remaining uses for this ability! -</c>", oPC, FALSE );
        return;
    }

    DecrementRemainingFeatUses( oPC, FEAT_STUNNING_FIST );

    RemoveInvisEffects( oPC );

    AssignCommand( oPC, DoPainTouch( oTarget ) );

    AssignCommand( oPC, ActionAttack( oTarget, FALSE ) );
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


void DoPainTouch( object oTarget ){

    object oPC = OBJECT_SELF;

    if( TouchAttackMelee( oTarget ) > 0 ) {

        int nWeakenTouched = GetLocalInt( oTarget, "Ki_Pain_Touched");

        if( nWeakenTouched == 1 ) {
            FloatingTextStringOnCreature( "<cþ  >Your enemy has already been affected by Pain Touch!</c>", oPC, FALSE );
            return;
        }

        int nLevel = GetLevelByClass( CLASS_TYPE_MONK, oPC );
        int nPenalty = nLevel / 5;

        if( nPenalty > 6 ) {
            nPenalty = 6;
        } else if ( nPenalty < 1 ) {
            nPenalty = 1;
        }

        effect ePenalty = EffectAttackDecrease( nPenalty );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePenalty, oTarget, RoundsToSeconds( nLevel ) );

        SetLocalInt( oTarget, "Ki_Pain_Touched", 1 );
        DelayCommand( RoundsToSeconds( nLevel ), SetLocalInt( oTarget, "Ki_Pain_Touched", 0 ) );
    }
}
