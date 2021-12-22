/*

OnHeartbeat script for the Deathbringers to deal Negative Energy damage in radius

*/

void main()
{
    object oCritter = GetAreaOfEffectCreator( OBJECT_SELF );
    location lCritter = GetLocation( oCritter );
    effect eVis = EffectVisualEffect( VFX_IMP_NEGATIVE_ENERGY );

    object oTarget = GetFirstInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid( oTarget ) )
    {
        if( GetRacialType( oTarget ) == RACIAL_TYPE_UNDEAD || GetTag( oTarget ) == "lab_gravesludge" )
        {
            effect eHeal = EffectHeal( d6(1) + 4 );
            effect eLink = EffectLinkEffects( eVis, eHeal );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );
        }
        else
        {
            effect eDamage = EffectDamage( d6(1) + 4, DAMAGE_TYPE_NEGATIVE, DAMAGE_POWER_ENERGY );
            effect eLink = EffectLinkEffects( eVis, eDamage );
            ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );
        }
        oTarget = GetNextInPersistentObject( OBJECT_SELF, OBJECT_TYPE_CREATURE );
    }
}
