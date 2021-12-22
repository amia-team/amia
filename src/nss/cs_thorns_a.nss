// Jungle of Thorns (OnEnter Aura)
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
    object oTarget = GetEnteringObject();

    // Used the same calculation as Web here.
    int nSlow = 65 - (GetAbilityScore(oTarget, ABILITY_STRENGTH)*2);
    if (nSlow <= 0)
    {
        nSlow = 1;
    }

    if (nSlow > 99)
    {
        nSlow = 99;
    }

    // Slows upon entry.
    effect eSlow = EffectMovementSpeedDecrease(nSlow);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        if(!GetHasFeat(FEAT_WOODLAND_STRIDE, oTarget) )
        {
            // Check Spell Resistance.
            if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
            {
                // Slow down the creature inside.
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
            }
        }
    }

}
