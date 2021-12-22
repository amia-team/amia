// Knight Commander feat: Barricade of Swords (OnExit Aura)
//
// An aura that delivers damage back to attackers. Knight Commander gains this
// feat at level 1.
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

    // Remove the aura effects if the aura creator applied them.
    RemoveSpellEffects( 892, oPC, oCreature );
}
