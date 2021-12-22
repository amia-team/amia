// Knight Commander feat: Ordnance Support
//
// An aura that gives nearby enemies an immunity decrease to elements, along with
// reducing their spell resistance.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/06/2011 PoS              Initial Release.
//

#include "x2_inc_spellhook"

void main( ){

    // Variables.
    object oCreature    = GetExitingObject( );
    object oPC          = GetAreaOfEffectCreator( );

    // Prevent aura being deactivated due to lag
    if( oCreature == oPC )
        return;

    // Remove the aura effects if the aura creator applied them.
    RemoveSpellEffects( 896, oPC, oCreature );
}
