//------------------------------------------------------------------------------
// Custom Aura Script - Water Vortex OnEnter - Water Vortex Creature
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// prototypes
//------------------------------------------------------------------------------
void DoVortexCapture (object oCritter, object oTarget );

//------------------------------------------------------------------------------
// main
//------------------------------------------------------------------------------
void main()
{
    object oCritter = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    if( GetIsEnemy( oTarget, oCritter ) )
    {
        DoVortexCapture( oCritter, oTarget );
    }
}

void DoVortexCapture( object oCritter, object oTarget )
{
    //Check to see if target gets caught in the vortex, if so deal damage and repeat next round
    int nReflex = ReflexSave( oTarget, 32, SAVING_THROW_TYPE_NONE, oCritter );
    int nTrap = GetLocalInt( oTarget, "ShadowseaVortex" );

    if( nReflex == 0 && nTrap != 1 )
    {
        //Make sure they don't get trapped by two vortexes
        SetLocalInt( oTarget, "ShadowseaVortex", 1 );

        //Trap in vortex
        string sName = GetName( oTarget );
        effect eTrap = EffectCutsceneImmobilize();
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eTrap, oTarget, 5.0 );
        AssignCommand( oTarget, ClearAllActions() );
        AssignCommand( oTarget, JumpToObject( oCritter ) );

        //Deal damage
        int nDamage = d4(4) + 15;
        effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_ENERGY );
        effect eVis = EffectVisualEffect( VFX_IMP_FROST_S );
        effect eLink = EffectLinkEffects( eVis, eDamage );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );

        //Apply penalties
        effect eDEX = EffectAbilityDecrease( ABILITY_DEXTERITY, 4 );
        effect eAB = EffectAttackDecrease( 2, ATTACK_BONUS_MISC );
        effect ePenalty = EffectLinkEffects( eDEX, eAB );
               ePenalty = SupernaturalEffect( ePenalty );
        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, ePenalty, oTarget, 6.0 );
        //Repeat check next round
        DelayCommand( 6.0, DoVortexCapture( oCritter, oTarget ) );
    }
    //Otherwise just do a check for damage this round and let them continue on
    else
    {
        nReflex = ReflexSave( oTarget, 32, SAVING_THROW_TYPE_NONE , oCritter );
        if( nReflex == 0 )
        {
            int nDamage = d4(4) + 15;
            effect eDamage = EffectDamage( nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_ENERGY );
            effect eVis = EffectVisualEffect( VFX_IMP_FROST_S );
            effect eLink = EffectLinkEffects( eVis, eDamage );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );
            SetLocalInt( oTarget, "ShadowseaVortex", 0 );
        }
    }
}
