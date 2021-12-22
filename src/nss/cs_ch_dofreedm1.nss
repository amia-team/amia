/*  Henchy: Cast Freedom of Movement

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032806  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Casts freedom of movement on the henchy's master.

*/

/* Includes */
#include "NW_I0_GENERIC"

void main( ){

    // Variables
    object oHenchy      = OBJECT_SELF;
    object oPC          = GetMaster( oHenchy );

    AssignCommand(
        oHenchy,
        ActionPlayAnimation( ANIMATION_LOOPING_CONJURE1, 1.0, 3.0 ) );

    ActionCastSpellAtObject(
        SPELL_FREEDOM_OF_MOVEMENT,
        oPC,
        METAMAGIC_ANY,
        TRUE,
        7,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE );

    return;

}
