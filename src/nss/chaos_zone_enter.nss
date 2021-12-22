//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  chaos_zone_enter
//group:   N/A
//used as: OnEnter Aura script for Chaos Growth PLCs
//date:    Oct 15 2012
//author:  Glim

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

void DoChaosZone1( object oTarget );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main()
{
    object oTarget = GetEnteringObject();
    int iRace = GetRacialType( oTarget );

    if( GetLocalInt( oTarget, "ChaosZone" ) != 1 )
    {
        SetLocalInt( oTarget, "ChaosZone", 1 );
    }

    if( iRace != RACIAL_TYPE_ABERRATION )
    {
        DoChaosZone1( oTarget );
    }
}

void DoChaosZone1( object oTarget )
{
    int iInRadius = GetLocalInt( oTarget, "ChaosZone" );

    if( iInRadius != 1 )
    {
        return;
    }

    int iRandom = d6(1);

    if( iRandom == 1 )
    {
        int iReflex = ReflexSave( oTarget, 16, SAVING_THROW_TYPE_CHAOS, OBJECT_SELF );

        if( iReflex == 0 )
        {
            effect eFire = EffectDamage( d6(1), DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY );
            effect eVis = EffectVisualEffect( VFX_IMP_FLAME_S );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eFire, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        else if( iReflex == 1)
        {
            effect eFire = EffectDamage( d3(1), DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY );
            effect eVis = EffectVisualEffect( VFX_IMP_FLAME_S );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eFire, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
    if( iRandom == 2 )
    {
        int iReflex = ReflexSave( oTarget, 16, SAVING_THROW_TYPE_CHAOS, OBJECT_SELF );

        if( iReflex == 0 )
        {
            effect eAcid = EffectDamage( d6(1), DAMAGE_TYPE_ACID, DAMAGE_POWER_ENERGY );
            effect eVis = EffectVisualEffect( VFX_IMP_ACID_S );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eAcid, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        else if( iReflex == 1)
        {
            effect eAcid = EffectDamage( d3(1), DAMAGE_TYPE_ACID, DAMAGE_POWER_ENERGY );
            effect eVis = EffectVisualEffect( VFX_IMP_ACID_S );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eAcid, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
    if( iRandom == 3 )
    {
        int iReflex = ReflexSave( oTarget, 16, SAVING_THROW_TYPE_CHAOS, OBJECT_SELF );

        if( iReflex == 0 )
        {
            effect eCold = EffectDamage( d6(1), DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );
            effect eVis = EffectVisualEffect( VFX_IMP_FROST_S );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eCold, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        else if( iReflex == 1)
        {
            effect eCold = EffectDamage( d3(1), DAMAGE_TYPE_COLD, DAMAGE_POWER_ENERGY );
            effect eVis = EffectVisualEffect( VFX_IMP_FROST_S );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eCold, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
    if( iRandom == 4 )
    {
        int iReflex = ReflexSave( oTarget, 16, SAVING_THROW_TYPE_CHAOS, OBJECT_SELF );

        if( iReflex == 0 )
        {
            effect eElec = EffectDamage( d6(1), DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_ENERGY );
            effect eVis = EffectVisualEffect( VFX_IMP_LIGHTNING_S );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eElec, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
        }
        else if( iReflex == 1)
        {
            effect eElec = EffectDamage( d3(1), DAMAGE_TYPE_ELECTRICAL, DAMAGE_POWER_ENERGY );
            effect eVis = EffectVisualEffect( VFX_IMP_LIGHTNING_S );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eElec, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget);
        }
    }
    if( iRandom == 5 )
    {
        int iFort = FortitudeSave( oTarget, 16, SAVING_THROW_TYPE_CHAOS, OBJECT_SELF );

        if( iFort == 0 )
        {
            effect eWeak = EffectAbilityDecrease( ABILITY_STRENGTH, d4(1) );
            effect eVis = EffectVisualEffect( VFX_IMP_REDUCE_ABILITY_SCORE );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eWeak, oTarget, 12.0 );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
        }
    }
    if( iRandom == 6 )
    {
        int iFort = FortitudeSave( oTarget, 16, SAVING_THROW_TYPE_CHAOS, OBJECT_SELF );

        if( iFort == 0 )
        {
            effect eSick = EffectAbilityDecrease( ABILITY_CONSTITUTION, d4(1) );
            effect eVis = EffectVisualEffect( VFX_IMP_DESTRUCTION );

            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eSick, oTarget, 12.0 );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oTarget );
        }
    }

    DelayCommand( 6.0, DoChaosZone1( oTarget ) );
}
