//::///////////////////////////////////////////////
//:: Cure Light Wounds
//:: NW_S0_CurLgtW
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// When laying your hand upon a living creature,
// you channel positive energy that cures 1d8 points
// of damage plus 1 point per caster level (up to +5).
// Since undead are powered by negative energy, this
// spell inflicts damage on them instead of curing
// their wounds. An undead creature can attempt a
// Will save to take half damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Brennon Holmes
//:: Created On: Oct 12, 2000
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 26, 2001
//  7/11/2016   msheeler    added +1d8 per spell focus and AoE for epic spell focus
//  1/30/2022   The1Kobra   Fixed script to include better targetting for AoE version, also added will save for undead.
//

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "amx_curwnds"

void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook

// Added variables to check for foci
    int nFociBonus = 1;
    int nMetaMagic = GetMetaMagicFeat();
    int nHP;
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    effect eCure;
    effect eHarm;
    effect eVis;
    float fDelay;
    object oSpecificTarget = GetSpellTargetObject();

    //check for max bonus to HP roll
    if (nCasterLevel > 5)
    {
        nCasterLevel = 5;
    }

    // Check if cast from an item. Don't apply foci in that case.
    if( GetIsObjectValid( GetSpellCastItem( ))) {
        HealTarget(GetSpellTargetObject(),nFociBonus, nCasterLevel, nMetaMagic, VFX_IMP_HEALING_S, VFX_IMP_SUNSTRIKE, TRUE);
        return;
    }

    //check for foci and apply bonuses
    if (GetHasFeat (FEAT_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
        {
        nFociBonus = 2;
        }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
        nFociBonus = 3;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
        nFociBonus = 4;
        AoEHeal(nFociBonus, nCasterLevel, nMetaMagic, VFX_IMP_HEALING_S, VFX_IMP_SUNSTRIKE, oSpecificTarget);
    }
    else if (!GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
        HealTarget(GetSpellTargetObject(),nFociBonus, nCasterLevel, nMetaMagic, VFX_IMP_HEALING_S, VFX_IMP_SUNSTRIKE);
    }
}
