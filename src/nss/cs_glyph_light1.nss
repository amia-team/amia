/*  Glyph: Lightning.

    --------
    Verbatim
    --------
    This glyph will deal 4d10 Lightning damage on a failed Fortitude, and Stun for 1d4 + 1 rounds on a failed Will.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080406  kfw         Initial release.
    090206  kfw         Bugfix: Trap setter immunity.
    030211  PoS         Utterly rebalanced.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables.
    object oTrap            = OBJECT_SELF;
    object oTrapCreator     = GetAreaOfEffectCreator( );
    int nDC                 = 30;
    object oTrapped         = GetEnteringObject( );


    // Filter: Trap setter.
    if( oTrapCreator == oTrapped )
        return;

    // Fortitude to resist Lightning damage.
    if( FortitudeSave( oTrapped, nDC, SAVING_THROW_TYPE_TRAP, oTrapCreator ) == 0 ){

        // Zap.
        ApplyEffectToObject(
            DURATION_TYPE_INSTANT,
            EffectLinkEffects(
                EffectVisualEffect( VFX_IMP_LIGHTNING_S ),
                EffectDamage( d10( 4 ), DAMAGE_TYPE_ELECTRICAL ) ),
            oTrapped );

        // Will to resist Stunning.
        if( WillSave( oTrapped, nDC, SAVING_THROW_TYPE_TRAP, oTrapCreator ) == 0 )

            // Stun.
            ApplyEffectToObject(
                DURATION_TYPE_TEMPORARY,
                EffectLinkEffects(
                    EffectVisualEffect( VFX_DUR_MIND_AFFECTING_DISABLED ),
                    EffectStunned( ) ),
                oTrapped,
                6.0 );

        }

    // Triggered, purge the trap.
    DestroyObject( oTrap, 0.1 );

    return;

}
