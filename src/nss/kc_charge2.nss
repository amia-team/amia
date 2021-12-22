// Knight Commander feat: Vehement Charge (OnExit Aura)
//
// An aura that imparts a load of immunities and a speed bonus. A Discipline
// penalty, too.
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
    RemoveSpellEffects( 897, oPC, oCreature );
}
