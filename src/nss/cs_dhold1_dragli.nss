// Darkhold :: Dragon Lights! - Funky Dragon appearance.
void main( ){

    // Variables
    object oDragon          = GetNearestObjectByTag( "X2_PLC_STATU_DRA" );
    effect eGlow            = SupernaturalEffect( EffectVisualEffect( VFX_DUR_GLOW_RED ) );

    // Spawn once.
    if( GetLocalInt( OBJECT_SELF, "spawned" ) )
        return;

    SetLocalInt( OBJECT_SELF, "spawned", 1 );

    // Initialize Dragon Lights!
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, eGlow, oDragon, 0.0 );

    return;

}
