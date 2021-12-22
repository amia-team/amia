// Jungle of Thorns (OnExit Aura)
//
// Creates an area of effect that slows upon entry and deals damage depending
// on whether the effect is saved or not. Also entangles if failed.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/18/2012 PaladinOfSune    Initial Release.
//

#include "X0_I0_SPELLS"

void main()
{
    // Variables.
    object oTarget  = GetExitingObject( );
    object oPC      = GetAreaOfEffectCreator( );

    effect eEffect  = GetFirstEffect( oTarget );
    while( GetIsEffectValid( eEffect ) )
    {
        // // Find the Movement Speed Decrease.
        if ( ( GetEffectType( eEffect ) == EFFECT_TYPE_MOVEMENT_SPEED_DECREASE ) && ( GetEffectCreator( eEffect ) == oPC ) )
        {
            // Remove it.
            RemoveEffect( oTarget, eEffect );
        }
        eEffect = GetNextEffect( oTarget );
    }
}
