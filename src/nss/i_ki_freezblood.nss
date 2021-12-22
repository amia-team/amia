// Freeze Lifeblood
// 10 Monk levels - 1x Stunning Fist per use
//
// Touch Attack. On hit, paralyzes [DC: 10 + Monk level / 2 + WIS modifier]
// their target for 3 rounds.
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
void DoFreezeLifeblood( object oTarget );

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

    AssignCommand( oPC, DoFreezeLifeblood( oTarget ) );

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

void DoFreezeLifeblood( object oTarget ) {

    object oPC = OBJECT_SELF;

    if( TouchAttackMelee( oTarget, TRUE ) > 0 ) {

        int nDC = 10 + ( GetLevelByClass( CLASS_TYPE_MONK, oPC) / 2 ) + GetAbilityModifier( ABILITY_WISDOM, oPC );

        if( FortitudeSave( oTarget, nDC, SAVING_THROW_TYPE_NONE, oPC ) < 1 ) {

            effect eEffect = EffectParalyze();
            effect eLink = EffectLinkEffects( eEffect, EffectVisualEffect( VFX_DUR_FREEZE_ANIMATION ) );
            eLink = EffectLinkEffects( eLink, EffectVisualEffect( VFX_FNF_DEMON_HAND ) );
            eLink = EffectLinkEffects( eLink, EffectVisualEffect( VFX_DUR_PARALYZED ) );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds( 3 ) );
        }
    }
}
