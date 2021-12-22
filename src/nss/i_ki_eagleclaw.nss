// Eagle Claw
// 3 Monk levels - 1x Stunning Fist per use
//
// Touch Attack. On hit, inflicts an Armor Class penalty of 1 per 10 Monk
// levels [minimum of 1, caps at -3] for Monk Level/Round. Also damages for
// base damage + Wisdom modifier + Dexterity modifier. Unstackable.
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
void DoEagleClaw( object oTarget );
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

    AssignCommand( oPC, DoEagleClaw( oTarget ) );

    DelayCommand( 0.5, AssignCommand( oPC, PlaySound( "as_an_hawk1" ) ) );

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


void DoEagleClaw( object oTarget ){

    object oPC = OBJECT_SELF;

    int nTouch = TouchAttackMelee( oTarget );
    if( nTouch > 0 ) {

        int nLevel = GetLevelByClass( CLASS_TYPE_MONK, oPC );
        int nBaseMonkDamage = GetMonkBaseDamage( oPC, nLevel );

        if( nTouch == 2 ) {
            nBaseMonkDamage *= 2;
        }

        int nDamage = nBaseMonkDamage + GetAbilityModifier(ABILITY_WISDOM, oPC) + GetAbilityModifier(ABILITY_DEXTERITY, oPC );
        effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_MAGICAL );

        ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_MAGBLUE ), oTarget);

        int nEagleClawed = GetLocalInt( oTarget, "Ki_Eagle_Claw");

        if( nEagleClawed == 1 ) {
            FloatingTextStringOnCreature( "<cþ  >Your enemy has already been affected by Eagle Claw!</c>", oPC, FALSE );
            return;
        }

        int nPenalty = nLevel / 10;

        if( nPenalty > 3 ) {
            nPenalty = 3;
        } else if ( nPenalty < 1 ) {
            nPenalty = 1;
        }

        effect ePenalty = EffectACDecrease( nPenalty );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePenalty, oTarget, RoundsToSeconds( nLevel ) );

        SetLocalInt( oTarget, "Ki_Eagle_Claw", 1 );
        DelayCommand( RoundsToSeconds( nLevel ), SetLocalInt( oTarget, "Ki_Eagle_Claw", 0 ) );
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
