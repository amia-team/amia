// Knight Commander feat: Bulwark of Vigilance (OnExit Aura)
//
// An aura that slows down attackers in the radius, and applies a Tumble penalty.
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
    RemoveSpellEffects( 894, oPC, oCreature );
}
