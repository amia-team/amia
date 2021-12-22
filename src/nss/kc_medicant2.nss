// Knight Commander feat: Medicant (OnExit Aura)
//
// An aura that imparts allies with regeneration and a bonus to Heal.
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
    RemoveSpellEffects( 895, oPC, oCreature );
}
