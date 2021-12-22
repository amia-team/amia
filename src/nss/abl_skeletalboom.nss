/*
    Custom NPC Only Ability:
    Skeletal Boom
    - Explodes on death (actually at 1% HP), dealing 15d6 Slashing and 15d6
    Piercing on failed Reflex Save DC 35 (Evasion applies) to all in radius.
*/

void main()
{
    object oCritter = OBJECT_SELF;
    location lCritter = GetLocation( oCritter );
    effect eVis = EffectVisualEffect( VFX_COM_CHUNK_BONE_MEDIUM );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oCritter );

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lCritter, TRUE, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid( oTarget ) )
    {
        int nDamage = GetReflexAdjustedDamage( d6(15), oTarget, 35, SAVING_THROW_TYPE_NONE, oCritter );
        effect ePierce = EffectDamage( nDamage, DAMAGE_TYPE_PIERCING, DAMAGE_POWER_NORMAL );
        effect eSlash = EffectDamage( nDamage, DAMAGE_TYPE_SLASHING, DAMAGE_POWER_NORMAL );
        effect eLink = EffectLinkEffects( ePierce, eSlash );
               eLink = EffectLinkEffects( eVis, eLink );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eLink, oTarget );

        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lCritter, TRUE, OBJECT_TYPE_CREATURE );
    }
}
