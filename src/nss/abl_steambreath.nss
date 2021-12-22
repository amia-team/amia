/*
    Custom NPC Ability:
    Breath Weapon - Steam
    - An 18.3 meter long cone of boiling water and steam dealing 1d4 Fire and
    1d4 Blunt (not subject to DR) damage per Hit Dice
    - Reflex save for half vs DC 10 + HD + CON modifier (evasion applies)
*/

void main()
{
    object oCaster = OBJECT_SELF;
    object oInitial = GetLocalObject( oCaster, "abl_steambreath" );
    location lInitial = GetLocation( oInitial );
    int nCasterLvl = GetHitDice( oCaster );
    int nDC = nDC = ( 10 + nCasterLvl + GetAbilityModifier( ABILITY_CONSTITUTION, oCaster ) );
    int nDamage;

    ActionCastFakeSpellAtObject( SPELLABILITY_DRAGON_BREATH_SLEEP, oInitial );

    object oTarget = GetFirstObjectInShape( SHAPE_SPELLCONE, 18.3, lInitial, TRUE, OBJECT_TYPE_CREATURE );

    while( GetIsObjectValid( oTarget ) )
    {
        nDamage = GetReflexAdjustedDamage( nDamage, oTarget, nDC, SAVING_THROW_TYPE_FIRE, oCaster );

        if( nDamage != 0 && oTarget != oCaster )
        {
            effect eFire = EffectDamage( nDamage, DAMAGE_TYPE_FIRE, DAMAGE_POWER_ENERGY );
            effect eBlunt = EffectDamage( nDamage, DAMAGE_TYPE_BLUDGEONING, DAMAGE_POWER_ENERGY );
            effect eImpact = EffectVisualEffect( VFX_DUR_GHOST_SMOKE_2 );
            effect eLink = EffectLinkEffects( eFire, eBlunt );
            DelayCommand( 1.0, ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget ) );
            DelayCommand( 0.5, ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eImpact, oTarget, 4.0 ) );

            SignalEvent( oTarget, EventSpellCastAt( oCaster, SPELLABILITY_DRAGON_BREATH_WEAKEN ) );
        }
        oTarget = GetNextObjectInShape( SHAPE_SPELLCONE, 18.3, lInitial, TRUE, OBJECT_TYPE_CREATURE );
    }
}
