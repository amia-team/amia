//Add a visual effect also, soft warm glow maybe.
/*
    Custom Feat (Full Action): Sacred Healing
        Prerequisites: Heal 8 ranks, ability to Turn Undead.
        Benefit: Expend on use of Turn Undead to grant 3 Regeneration to all living creatures (not
                    undead or constructs) within a 60ft burst, lasting for rounds equal to 1 + Wisdom
                    modifier.

    Created: January 3rd, 2015 - Glim
*/

#include "x2_inc_spellhook"
void SacredHealing( object oPC );

void main()
{
    SacredHealing( OBJECT_SELF );
}

void SacredHealing( object oPC )
{
    if( !GetHasFeat( FEAT_TURN_UNDEAD, oPC ) )
    {
        SendMessageToPC( oPC, "You have no remaining uses of Turn Undead and cannot use this feat." );
        return;
    }

    effect eRegen = EffectRegenerate( 3, 6.0 );
    effect eVFXCast = EffectVisualEffect( VFX_IMP_PULSE_HOLY );
    effect eVFXImp = EffectVisualEffect( VFX_IMP_HEAD_HEAL );
    effect eVFXDur = EffectVisualEffect( VFX_DUR_AURA_PULSE_ORANGE_WHITE );
    effect eLink = EffectLinkEffects( eVFXDur, eRegen );
    location lPC = GetLocation( oPC );
    int nMod = GetAbilityModifier( ABILITY_WISDOM, oPC );
    float fDur = RoundsToSeconds( 1 + nMod );

    DecrementRemainingFeatUses( oPC, FEAT_TURN_UNDEAD );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFXCast, oPC );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lPC, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid( oTarget ) )
    {
        if( !GetIsReactionTypeHostile( oTarget, oPC ) && !GetLocalInt( oTarget, "SacredHealing" ) )
        {
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFXImp, oTarget );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, fDur );
            SetLocalInt( oTarget, "SacredHealing", 1 );
            DelayCommand( fDur, DeleteLocalInt( oTarget, "SacredHealing" ) );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, lPC, OBJECT_TYPE_CREATURE );
    }
}
