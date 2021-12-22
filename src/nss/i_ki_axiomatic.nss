// Axiomatic Strike
// 5 Monk levels - - 1x Stunning Fist per use
//
// Touch Attack. On hit, inflicts base monk damage + Strength modifier +
// 1d3 divine damage per Monk level versus a chaotic-aligned target.
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
void DoAxiomatic( object oTarget );
int GetMonkBaseDamage( object oPC, int nLevel );

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

    AssignCommand( oPC, DoAxiomatic( oTarget ) );

    AssignCommand( oPC, ActionAttack( oTarget, FALSE ));
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

void DoAxiomatic( object oTarget ) {

    object oPC = OBJECT_SELF;
    int nTouch = TouchAttackMelee( oTarget );
    if( nTouch > 0 ) {

        if( GetAlignmentLawChaos( oTarget ) != ALIGNMENT_CHAOTIC ) {
            FloatingTextStringOnCreature( "No Effect! Axiomatic Strike only works on chaotic creatures.", oPC, FALSE );
            return;
        }

        int nLevel = GetLevelByClass( CLASS_TYPE_MONK, oPC );
        int nBaseMonkDamage = GetMonkBaseDamage( oPC, nLevel );

        if( nTouch == 2 ) {
            nBaseMonkDamage *= 2;
        }

        int nDamage = nBaseMonkDamage + d3( nLevel );
        effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect(183), oTarget );
    }
}

int GetMonkBaseDamage( object oPC, int nLevel ) {

    int nDamage;

    if( GetCreatureSize( oPC ) < 3 ) {
        if( nLevel < 4 ) {
            nDamage = d4();
        } else if ( nLevel < 8 ) {
            nDamage = d6();
        } else if ( nLevel < 12 ) {
            nDamage = d8();
        } else if ( nLevel < 16 ) {
            nDamage = d10();
        } else {
            nDamage = d6( 2 );
        }
    } else {
        if( nLevel < 4 ) {
            nDamage = d6();
        } else if ( nLevel < 8 ) {
            nDamage = d8();
        } else if ( nLevel < 12 ) {
            nDamage = d10();
        } else if ( nLevel < 16 ) {
            nDamage = d12();
        } else {
            nDamage = d20();
        }
    }
    nDamage += GetAbilityModifier( ABILITY_STRENGTH, oPC );
    return nDamage;
}
