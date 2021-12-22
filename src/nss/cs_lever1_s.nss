/*  Lever :: OnUsed :: Animate

    --------
    Verbatim
    --------
    This script will animate the lever.

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
    object oPanel       = OBJECT_SELF;

    PlayAnimation( ANIMATION_PLACEABLE_ACTIVATE );

    DelayCommand( 2.0, PlayAnimation( ANIMATION_PLACEABLE_DEACTIVATE ) );

    return;

}
