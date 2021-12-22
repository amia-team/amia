//------------------------------------------------------------------------------
// Custom Aura Script - Unholy Aura OnEnter - Wastrilith Creature
//------------------------------------------------------------------------------

void main()
{
    object oTarget = GetEnteringObject();
    object oCritter = GetAreaOfEffectCreator();
    int nAura = GetLocalInt( oTarget, "UnholyAura" );
    string sTag = GetTag( oCritter );

    //If not an enemy and not already affected, provide protective bonuses
    if ( !GetIsEnemy( oTarget, oCritter ) && nAura == 0 )
    {
        effect eAC = EffectACIncrease( 4, AC_DEFLECTION_BONUS );
        effect eSaves = EffectSavingThrowIncrease( SAVING_THROW_ALL, 4 );
        effect eSR = EffectSpellResistanceIncrease( 25 );
        effect eMind = EffectImmunity( IMMUNITY_TYPE_MIND_SPELLS );
        effect eLink = EffectLinkEffects( eAC, eSaves );
               eLink = EffectLinkEffects( eSR, eLink );
               eLink = EffectLinkEffects( eMind, eLink );
               eLink = SupernaturalEffect( eLink );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget );
        SetLocalInt( oTarget, "UnholyAura", 1 );
    }
    //If is an enemy and not already affected, drain strength
    else if( GetIsEnemy( oTarget, oCritter ) && nAura == 0 )
    {
        effect eStrength = EffectAbilityDecrease( ABILITY_STRENGTH, d6(1) );
               eStrength = SupernaturalEffect( eStrength );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eStrength, oTarget );
        SetLocalInt( oTarget, "UnholyAura", 1 );
    }
}
