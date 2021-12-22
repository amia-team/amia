/*  Mystra :: OnSpawn :: VFX Self

    --------
    Verbatim
    --------
    This script will give Mystra a "mist"-like appearance, to represent that she's
    the Weave itself.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    062306  kfw         Initial release.
    ----------------------------------------------------------------------------

*/

void main( ){

    object oMystra          = OBJECT_SELF;

    ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( VFX_DUR_GHOST_SMOKE_2 ) ), oMystra );
    ApplyEffectToObject( DURATION_TYPE_PERMANENT, SupernaturalEffect( EffectVisualEffect( VFX_DUR_PROT_PREMONITION ) ), oMystra );

    return;

}
