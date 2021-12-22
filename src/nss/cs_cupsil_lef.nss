void main( ){

    object oTarget  = GetExitingObject( );
    object oPC      = GetAreaOfEffectCreator( );

    int nFound = FALSE;
    effect eEffect = GetFirstEffect( oTarget );
    while( GetIsEffectValid( eEffect ) ){

        if( GetEffectType( eEffect ) == EFFECT_TYPE_SKILL_INCREASE && GetEffectCreator( eEffect ) == oPC && GetEffectSpellId( eEffect ) == 878 ){

            RemoveEffect( oTarget, eEffect );
            nFound=TRUE;
        }

        eEffect = GetNextEffect( oTarget );
    }

    if( nFound )
        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SONIC ), oTarget );
}
