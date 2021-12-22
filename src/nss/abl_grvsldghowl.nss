/*
    Custom NPC Only Ability:
    Graveyard Sludge Death Howl
    - Colossal radius Howl Will Save DC 35 vs Fear for 1 round on all enemies.
*/

void main(){

    object oCritter = OBJECT_SELF;
    location lCritter = GetLocation( oCritter );
    effect eFearVis = EffectVisualEffect( VFX_FNF_HOWL_MIND );
    effect eFright = EffectVisualEffect( VFX_DUR_MIND_AFFECTING_FEAR );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eFearVis, oCritter );
    AssignCommand( oCritter, SpeakString( "<c ¥ >*releases a torrent of wailing souls trapped within the sludge*</c>" ) );
    effect eFear = EffectFrightened();

    object oTarget = GetFirstObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lCritter, FALSE, OBJECT_TYPE_CREATURE );
    while( GetIsObjectValid( oTarget ) )
    {
        if( GetIsEnemy( oTarget, oCritter ) )
        {
            if( WillSave( oTarget, 37, SAVING_THROW_TYPE_FEAR, oCritter ) == 0 )
            {
                effect eLink = EffectLinkEffects( eFear, eFright );
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oTarget, 6.0 );
            }
        }
        oTarget = GetNextObjectInShape( SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, lCritter, FALSE, OBJECT_TYPE_CREATURE );
    }
}
