/*   Cast Mage Armor BG NE Summon
   Maverick00053 - 2/15/25

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
        SPELL_MAGE_ARMOR,
        oPC,
        METAMAGIC_ANY,
        TRUE,
        20,
        PROJECTILE_PATH_TYPE_DEFAULT,
        TRUE );

    return;

}
