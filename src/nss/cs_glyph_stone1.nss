/*  Glyph: Stone.

    --------
    Verbatim
    --------
    This glyph will Petrify for 5 Turns on a failed Fortitude.

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


    // Fortitude to resist Petrification.
    if( FortitudeSave( oTrapped, nDC, SAVING_THROW_TYPE_TRAP, oTrapCreator ) == 0 ){

        // Petrify.
        ApplyEffectToObject(
            DURATION_TYPE_TEMPORARY,
            EffectLinkEffects(
                EffectVisualEffect( VFX_DUR_PETRIFY ),
                EffectPetrify( ) ),
            oTrapped,
            TurnsToSeconds( 5 ) );

    }

    // Triggered, purge the trap.
    DestroyObject( oTrap, 0.1 );

    return;

}
