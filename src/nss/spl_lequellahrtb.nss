/*
    Custom Spell (Ranged): 9 Wiz/Sorc (Conjuration)
    Light of Le'Quella
        - 10m radius AoE lasting 10 rounds
        - Deals 1d3 per CL (max 10d3) Fire Damage and 1d6 Positive Damage per
          round on failed Reflex save (evasion applies).
            - On failed save, attempt to apply Combustion effect as per standard
              NWN spell (incluting initial Reflex save).
        - Also, Reflex save made every 3rd round versus 1d4 rounds of Blindness.
        - Spell Resistance does not apply.
*/

#include "x0_i0_spells"
#include "x2_inc_toollib"
#include "x2_I0_SPELLS"
#include "inc_td_shifter"
void QuellaCombust( object oCaster, object oTarget, int nCasterLevel, int nDC );
void RunCombustImpact(object oTarget, object oCaster, int nLevel, int nMetaMagic);

void main()
{
    //Gather spell details
    object oCaster = GetAreaOfEffectCreator( );
    int nCasterLvl;
    int nDC;
    int nDur;
    int nDamage;
    int nBonusDam;
    object oQuella = GetNearestObjectByTag( "quellalight", OBJECT_SELF ) ;
    int nCounter = GetLocalInt( oQuella, "Counter" );
    int nSave;

    nCasterLvl = GetNewCasterLevel( oCaster );
    nDC = 10 + 9 + GetAbilityModifier( ABILITY_INTELLIGENCE, oCaster );
    int nDice = nCasterLvl;

    //damage caps at 10d3 and +10
    if( nDice >=11 )
    {
        nDice = 10;
    }

    nDamage = d3( nDice );
    nBonusDam = nDice;

    //add in appropriate Spell Focus bonus to save DC
    if( GetHasFeat( FEAT_SPELL_FOCUS_CONJURATION, oCaster ) == TRUE )
    {
        nDC = nDC + 2;
        if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_CONJURATION, oCaster ) == TRUE )
        {
            nDC = nDC + 2;
            if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_CONJURATION, oCaster ) == TRUE )
            {
                nDC = nDC + 2;
            }
        }
    }

    //variables
    effect eBright = EffectVisualEffect( 481 );
    effect ePulse = EffectVisualEffect( 22 );
    effect eBlind = EffectBlindness( );
    effect eBlindVFX = EffectVisualEffect( VFX_DUR_BLIND );
           eBlind = EffectLinkEffects( eBlindVFX, eBlind );
    effect eFire;
    effect eFireVFX = EffectVisualEffect( VFX_IMP_FLAME_M );
    effect ePositive;

    //set up round based effects
    nCounter = nCounter + 1;
    SetLocalInt( oQuella, "Counter", nCounter );

    if( nCounter == 4 || nCounter == 7 || nCounter == 10 )
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eBright, oQuella );
    }
    else
    {
        ApplyEffectToObject( DURATION_TYPE_INSTANT, ePulse, oQuella );
    }

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( OBJECT_SELF ), TRUE, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid( oTarget ) )
    {
        //enemies only
        if( GetIsEnemy( oTarget, oCaster ) )
        {
            //check first which round we're in, every 3rd check Blindness
            if( nCounter == 4 || nCounter == 7 || nCounter == 10 )
            {
                if( !MySavingThrow( SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster ) )
                {
                    nDur = ( d4( 1 ) );
                    SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_BLINDNESS_AND_DEAFNESS ) );
                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eBlind, oTarget, RoundsToSeconds( nDur ) );
                }
            }

            //then check for initial pulse damage
            nDice = GetReflexAdjustedDamage( nDice, oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster );

            eFire = EffectDamage( d3( nDice ), DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY );
            eFire = EffectLinkEffects( eFireVFX, eFire );
            ePositive = EffectDamage( d6( 1 ), DAMAGE_TYPE_POSITIVE, DAMAGE_POWER_ENERGY );
            eFire = EffectLinkEffects( ePositive, eFire );
            SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELL_FIREBALL ) );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eFire, oTarget );

            //then Combust the target if they fail another save
            int nNoStack = GetLocalInt( oTarget, "QuellaCombust" );
            if( !nNoStack && !MySavingThrow( SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_SPELL, oCaster ) )
            {
                SetLocalInt( oTarget, "QuellaCombust", 1 );
                QuellaCombust( oCaster, oTarget, nCasterLvl, nDC );
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation( OBJECT_SELF ), TRUE, OBJECT_TYPE_CREATURE );
    }
}

void QuellaCombust( object oCaster, object oTarget, int nCasterLvl, int nDC )
{
    //--------------------------------------------------------------------------
    // Calculate the damage, 2d6 + casterlevel, capped at +10
    //--------------------------------------------------------------------------
    int nDamage = nCasterLvl;
    if( nDamage > 10 )
    {
        nDamage = 10;
    }
    nDamage = nDamage + d6( 2 );

    //--------------------------------------------------------------------------
    // Calculate the duration (we need a duration or bad things would happen
    // if someone is immune to fire but fails his safe all the time)
    //--------------------------------------------------------------------------
    int nDuration = 10 + nCasterLvl;
    if( nDuration < 1 )
    {
        nDuration = 10;
    }

    //--------------------------------------------------------------------------
    // Setup Effects
    //--------------------------------------------------------------------------
    effect eDam = EffectDamage( nDamage, DAMAGE_TYPE_FIRE );
    effect eDur = EffectVisualEffect( 498 );

    SignalEvent( oTarget, EventSpellCastAt( OBJECT_SELF, SPELL_COMBUST ) );

    //-------------------------------------------------------------------
    // Apply VFX
    //-------------------------------------------------------------------
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eDam, oTarget );
    TLVFXPillar( VFX_IMP_FLAME_M, GetLocation( oTarget ), 5, 0.1f, 0.0f, 2.0f );

    //------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type,
    // that's enough
    //------------------------------------------------------------------
    if( GetHasSpellEffect( SPELL_COMBUST, oTarget ) || GetHasSpellEffect( SPELL_INFERNO, oTarget ) )
    {
        FloatingTextStrRefOnCreature( 100775, OBJECT_SELF, FALSE );
        return;
    }

    //------------------------------------------------------------------
    // Apply the VFX that is used to track the spells duration
    //------------------------------------------------------------------
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oTarget, 6.0 );

    //------------------------------------------------------------------
    // Tick damage after 6 seconds again
    //------------------------------------------------------------------
    DelayCommand( 6.0, RunCombustImpact( oTarget, oCaster, nCasterLvl, nDC ) );
}

void RunCombustImpact( object oTarget, object oCaster, int nCasterLvl, int nDC )
{
    if( GetIsDead( oTarget ) == FALSE )
    {
        if( !MySavingThrow( SAVING_THROW_REFLEX, oTarget, nDC, SAVING_THROW_TYPE_FIRE ) )
        {
            //------------------------------------------------------------------
            // Calculate the damage, 1d6 + casterlevel, capped at +10
            //------------------------------------------------------------------
            int nDamage = nCasterLvl;
            if( nDamage > 10 )
            {
                nDamage = 10;
            }
            nDamage = nDamage + d6( 1 );

            effect eDmg = EffectDamage( nDamage, DAMAGE_TYPE_FIRE );
            effect eDur = EffectVisualEffect( 498 );
            effect eVFX = EffectVisualEffect( VFX_IMP_FLAME_S );

            ApplyEffectToObject( DURATION_TYPE_INSTANT, eDmg, oTarget );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oTarget );
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oTarget, 6.0 );

            //------------------------------------------------------------------
            // After six seconds (1 round), check damage again
            //------------------------------------------------------------------
            DelayCommand( 6.0f, RunCombustImpact( oTarget, oCaster, nCasterLvl, nDC ) );
        }
        else
        {
            SetLocalInt( oTarget, "QuellaCombust", 0 );
        }
   }
}
