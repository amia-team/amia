// Luminous Cloud (OnExit)
//
// Creatures entering the aura take -20 hide, are invis purged, and if
// polymorphed, are unshifted.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 03/22/2012 Mathias          Initial Release.
//
#include "X0_I0_SPELLS"

void main()
{
    // Variables.
    object oCreature  = GetExitingObject( );
    object oPC      = GetAreaOfEffectCreator( );

    effect eEffect  = GetFirstEffect( oCreature );
    while( GetIsEffectValid( eEffect ) )
    {
        // // Find the skill decrease.
        if ( ( GetEffectType( eEffect ) == EFFECT_TYPE_SKILL_DECREASE ) && ( GetEffectCreator( eEffect ) == oPC ) )
        {
            // Remove it.
            RemoveEffect( oCreature, eEffect );
        }
        eEffect = GetNextEffect( oCreature );
    }
}
