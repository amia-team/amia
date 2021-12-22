/*  Glyph: Warning.

    --------
    Verbatim
    --------
    This glyph will reveal to the Harper (tingle in the mind) that someone has triggered it.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    080406  kfw         Initial release.
    090206  kfw         Bugfix: Trap setter immunity.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables.
    object oTrap            = OBJECT_SELF;
    object oTrapCreator     = GetAreaOfEffectCreator( );
    object oTrapped         = GetEnteringObject( );


    // Filter: Trap setter.
    if( oTrapCreator == oTrapped )
        return;


    // "Tingle."
    SendMessageToPC( oTrapCreator, "- You feel a tingle: Someone may have set off one of your Glyph's of Warning. -" );
    // Destroy the glpyh.
    DestroyObject( oTrap, 0.1 );

    return;

}
