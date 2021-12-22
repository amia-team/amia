/*  Area :: OnEnter :: VFX Emitter

    --------
    Verbatim
    --------
    This script will make emitters shoot vfxs at a target.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062306  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables.
    object oTrigger     = OBJECT_SELF;

    object oEmit0       = GetNearestObjectByTag( "cs_emit0" );
    object oEmit1       = GetNearestObjectByTag( "cs_emit1" );
    object oEmit2       = GetNearestObjectByTag( "cs_emit2" );
    object oEmit3       = GetNearestObjectByTag( "cs_emit3" );

    object oTarget      = GetNearestObjectByTag( "cs_target" );

    // Initialize emitters.
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectBeam( VFX_BEAM_LIGHTNING, oEmit0, BODY_NODE_CHEST ), oTarget );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectBeam( VFX_BEAM_LIGHTNING, oEmit1, BODY_NODE_CHEST ), oTarget );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectBeam( VFX_BEAM_LIGHTNING, oEmit2, BODY_NODE_CHEST ), oTarget );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectBeam( VFX_BEAM_LIGHTNING, oEmit3, BODY_NODE_CHEST ), oTarget );

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, EffectVisualEffect( VFX_DUR_SPELLTURNING ), oTarget );

    // Purge triger.
    DestroyObject( oTrigger, 1.0 );

    return;

}
