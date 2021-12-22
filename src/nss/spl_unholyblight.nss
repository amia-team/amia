/*
    Custom Spell:
    Unholy Blight
    - Level 4 Evil Domain Ranged (Evocation)
    - Metamagic Applies
    - All targets within Huge radius of target location/creature are affected.
    - Deals 1d8 Divine damage per 2 CL (max 5d8) to any target with a Will
    save vs Sickened effect for 1d4 rounds, and half damage if successful.
        - Sickened: -2 AB, -2 Damage, -2 Saves
        - Deals 1d6 Divine damage per 1 CL (max 10d6) to Outsiders instead.
*/

#include "x0_i0_spells"

void main()
{
    //Gather spell details
    object oCaster = OBJECT_SELF;
    object oTarget = GetSpellTargetObject( );
    location lTarget = GetSpellTargetLocation( );
    int nCasterLvl;
    int nSpellPen = 0;
    int nDC;
    int nSR;
    int nCHA = 0;
    float fDur;
    int nDice;
    int nMeta = GetMetaMagicFeat( );

    //Check for Spell Penetration feats
    if( GetHasFeat( FEAT_SPELL_PENETRATION, oCaster ) == TRUE )
    {
        nSpellPen = 2;
    }
    if( GetHasFeat( FEAT_GREATER_SPELL_PENETRATION, oCaster ) == TRUE )
    {
        nSpellPen = 4;
    }
    if( GetHasFeat( FEAT_EPIC_SPELL_PENETRATION, oCaster ) == TRUE )
    {
        nSpellPen = 6;
    }

    //Run normally if cast by a PC
    if( GetIsPC( oCaster ) && !GetIsDMPossessed( oCaster ) )
    {
        nCasterLvl = GetNewCasterLevel( oCaster );
        nSR = ( d20( 1 ) + nCasterLvl + nSpellPen );
        nDC = GetSpellSaveDC();
        float fCasterLvl = IntToFloat( nCasterLvl );
        nDice = 1 * FloatToInt( fCasterLvl * 0.5 );
    }
    //Otherwise generate custom attributes for NPCs
    else
    {
        nCasterLvl = GetHitDice( oCaster );
        nSR = ( d20( 1 ) + nCasterLvl + nSpellPen );
        nCHA = GetAbilityModifier( ABILITY_CHARISMA, oCaster );
        nDC = ( 10 + 8 + nCHA );
        nDice = nCasterLvl;
    }

    effect eImpact = EffectVisualEffect( VFX_FNF_GAS_EXPLOSION_EVIL );
    effect eRadius = EffectAreaOfEffect( AOE_PER_GREASE );
    int nDamage;
    int nRace;
    int nWill;
    effect eDamage;

    //initial radius VFX
    ApplyEffectAtLocation( DURATION_TYPE_TEMPORARY, eRadius, lTarget, 1.5 );

    //cycle through targets in radius
    oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_STINKING_CLOUD ) );

        if( GetSpellResistance( oTarget ) < nSR )
        {
            //More damage to Outsiders
            nRace = GetRacialType( oTarget );
            if( nRace == RACIAL_TYPE_OUTSIDER )
            {
                //cap dice at 10 versus outsiders
                if( nDice >= 11 )
                {
                    nDice = 10;
                }
                nDamage = d6( nDice );

                if( nMeta == METAMAGIC_MAXIMIZE )
                {
                    nDamage = 6 * nDice;
                }
                else if( nMeta == METAMAGIC_EMPOWER )
                {
                    nDamage = FloatToInt( nDamage * 1.5 );
                }
            }
            else
            {
                if( nDice >= 6 )
                {
                    nDice = 5;
                }
                nDamage = d8( nDice );

                if( nMeta == METAMAGIC_MAXIMIZE )
                {
                    nDamage = 8 * nDice;
                }
                else if( nMeta == METAMAGIC_EMPOWER )
                {
                    nDamage = FloatToInt( nDamage * 1.5 );
                }
            }

            //Will save
            int nWill = MySavingThrow( SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster );
            if( nWill == 0 )
            {
                //Sickness
                effect eSick = CreateDoomEffectsLink();
                       eSick = ExtraordinaryEffect( eSick );
                float fDur = IntToFloat( d4(1) );
                if( nMeta == METAMAGIC_MAXIMIZE )
                {
                    fDur = 4.0;
                }
                else if( nMeta == METAMAGIC_EMPOWER )
                {
                    fDur = fDur * 1.5;
                }

                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSick, oTarget, fDur );
                //Damage
                eDamage = EffectDamage( nDamage, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY );
                //Link
                effect eLink = EffectLinkEffects( eSick, eDamage );
                       eLink = EffectLinkEffects( eImpact, eLink );
                DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget ) );

            }
            //successful will save means half damage and no sickness at all
            else if( nWill == 1 )
            {
                //Damage
                eDamage = EffectDamage( nDamage / 2, DAMAGE_TYPE_DIVINE, DAMAGE_POWER_ENERGY );
                //Link
                effect eLink = EffectLinkEffects( eImpact, eDamage );
                DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget ) );
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, FALSE, OBJECT_TYPE_CREATURE );
    }
}
