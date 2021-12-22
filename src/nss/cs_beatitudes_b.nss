// Beatitudes OnExit script - custom spell.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 04/14/2013 PoS              Initial Release.
//

#include "x2_inc_spellhook"

void main(){

    // Variables.
    object oCreature    = GetExitingObject();
    object oPC          = GetAreaOfEffectCreator( );

    if( oCreature == oPC )
        return;

    RemoveSpellEffects( 888, oPC, oCreature );
}
