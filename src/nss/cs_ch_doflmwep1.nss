/*  Henchy: Cast Flame Weapon

    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    032806  kfw         Initial release
    ----------------------------------------------------------------------------

    Verbatim
    --------
    Casts flame weapon on the henchy's master.

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
        SPELL_FLAME_WEAPON,
        oPC,
        METAMAGIC_ANY,
        TRUE,
        20,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE );

    return;

}
