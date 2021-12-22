// Sandstorm (OnEnter Aura)
//
// Creates an area of effect that blinds, slows and confuses targets inside.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 30/09/2012 PoS              Initial Release.
//

#include "X0_I0_SPELLS"
#include "inc_dc_spells"

void main()
{
    // Variables.
    object oTarget          = GetEnteringObject( );
    object oPC              = GetAreaOfEffectCreator( );
    int    nSpellDCBonus;
    int    nDamage;

    effect eDamage;
    effect eDamVis          = EffectVisualEffect( VFX_IMP_DUST_EXPLOSION );

    effect eBlind           = EffectBlindness( );
    effect eBlindVis        = EffectVisualEffect( VFX_IMP_BLIND_DEAF_M );

    effect eConfu           = EffectConfused( );
    effect eConfuVis        = EffectVisualEffect( VFX_IMP_CONFUSION_S );
    effect eConfuVis2       = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED );

    effect eSlow            = EffectSlow( );
    effect eSlowVis         = EffectVisualEffect( VFX_IMP_SLOW );

    effect eSkill1          = EffectSkillDecrease( SKILL_CONCENTRATION, 5 );
    effect eSkill2          = EffectSkillDecrease( SKILL_SPOT, 5 );
    effect eSkill3          = EffectSkillDecrease( SKILL_DISCIPLINE, 5 );
    effect eSkill4          = EffectSkillDecrease( SKILL_LISTEN, 5 );


    // Apply bonus DC from spell focuses.
    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_CONJURATION, oPC ) )
        nSpellDCBonus = 6;
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_CONJURATION, oPC ) )
        nSpellDCBonus = 4;
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_CONJURATION, oPC ) )
        nSpellDCBonus = 2;

    // All custom spells are evocation school, so we need this code here to make sure the DC is calcuated correctly.
    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_EVOCATION, oPC ) )
        nSpellDCBonus -= 6;
    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_EVOCATION, oPC ) )
        nSpellDCBonus -= 4;
    else if( GetHasFeat( FEAT_SPELL_FOCUS_EVOCATION, oPC ) )
        nSpellDCBonus -= 2;

    // Only affect hostiles.
    if( GetIsReactionTypeHostile( oTarget, oPC ) )
    {
        SignalEvent( oTarget, EventSpellCastAt( oPC, DC_SPELL_R_9 ) );

        // Make SR check.
        if( !MyResistSpell( oPC, oTarget ) )
        {
            if( !MySavingThrow( SAVING_THROW_FORT, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC ) )
            {
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds( 1 ) );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eBlindVis, oTarget );
            }

            if( !MySavingThrow( SAVING_THROW_WILL, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC ) )
            {
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eConfu, oTarget, RoundsToSeconds( 1 ) );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eConfuVis, oTarget );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eConfuVis2, oTarget, RoundsToSeconds( 1 ) );
            }

            if( !MySavingThrow( SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_NONE, oPC ) )
            {
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSlow, oTarget, RoundsToSeconds( 5 ) );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eSlowVis, oTarget );
            }

            nDamage     = d6( 5 );
            eDamage     = EffectDamage( nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_PLUS_FIVE );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamVis, oTarget );

            // Cycle active effects to find those affected by the caster
            effect eEffects = GetFirstEffect( oTarget );
            while( GetIsEffectValid( eEffects ) )
            {
                // Find skill decrease caused by the caster.
                if ( ( GetEffectType( eEffects ) == EFFECT_TYPE_SKILL_DECREASE ) && ( GetEffectCreator( eEffects ) == oPC ) )
                {
                    return;
                }
                eEffects = GetNextEffect( oTarget );
            }

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSkill1, oTarget, RoundsToSeconds( 1 ) );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSkill2, oTarget, RoundsToSeconds( 1 ) );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSkill3, oTarget, RoundsToSeconds( 1 ) );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSkill4, oTarget, RoundsToSeconds( 1 ) );
        }
    }
}
