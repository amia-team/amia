// Tactical Approach
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2011 PoS              Initial Release.
// 02/10/2013 PoS              Fix for summons.
//

#include "x2_inc_spellhook"

void main(){

    // Variables.
    object oCreature    = GetExitingObject( );
    object oPC          = GetAreaOfEffectCreator( );
    object oArmor;

    // Remove the aura effects if the aura creator applied them.
    RemoveSpellEffects( 930, oPC, oCreature );

    if( GetAssociateType( oCreature ) == ASSOCIATE_TYPE_NONE )
    {
        oArmor = GetItemInSlot( INVENTORY_SLOT_CHEST, oCreature );
    }
    else
    {
        oArmor = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oCreature );
    }

    if ( GetHasSpellEffect( 930, oArmor ) )
    {
        RemoveEffectsFromSpell( oArmor, 930 );
    }
}
