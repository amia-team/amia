/*  Henchy: Cast Improved Invisibility

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032706  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Casts improved invisibility on the henchy's master.

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
        SPELL_IMPROVED_INVISIBILITY,
        oPC,
        METAMAGIC_ANY,
        TRUE,
        7,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE );

    return;

}
