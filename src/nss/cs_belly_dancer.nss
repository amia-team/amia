/*  NPC :: Belly Dancing!

    --------
    Verbatim
    --------
    A quick script, which'll have to be tidied up at some point.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    082806  kfw         Initial.
    ----------------------------------------------------------------------------

*/

void main( ){

    // Variables.
    object oNPC         = OBJECT_SELF;


    // Belly-dancing anim.
    AssignCommand( oNPC, ActionPlayAnimation( ANIMATION_LOOPING_CONJURE2 ) );

    // Prevent cancelling.
    DelayCommand( 1.0, SetCommandable( FALSE ) );

    return;

}
