/*

OnEnter script for the Graveyard Sludge to apply beneficial aura effects onto
friendly targets that enter.

*/

void main()
{
    object oCritter = GetAreaOfEffectCreator( OBJECT_SELF );
    object oTarget = GetEnteringObject();

    effect eBuffVis = EffectVisualEffect( VFX_DUR_DEATH_ARMOR );
    effect eResist = EffectTurnResistanceIncrease( 5 );
    effect eDR = EffectDamageReduction( 15, DAMAGE_POWER_PLUS_SIX, 0 );
    effect eSave = EffectSavingThrowIncrease( SAVING_THROW_ALL, 5, SAVING_THROW_TYPE_ALL );
    effect eLink = EffectLinkEffects( eBuffVis, eResist );
           eLink = EffectLinkEffects( eDR, eLink );
           eLink = EffectLinkEffects( eSave, eLink );
           eLink = SupernaturalEffect( eLink );

    if( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD && !GetIsEnemy( oTarget, oCritter ) && !GetIsDead( oTarget ) )
    {
        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oTarget );
    }
}
