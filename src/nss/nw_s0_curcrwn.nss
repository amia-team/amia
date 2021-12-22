//::///////////////////////////////////////////////
//:: Cure Critical Wounds
//:: NW_S0_CurCrWn
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
// As cure light wounds, except cure critical wounds
// cures 4d8 points of damage plus 1 point per
// caster level (up to +20).
*/
//:://////////////////////////////////////////////
//:: Created By: Noel Borstad
//:: Created On: Oct 18, 2000
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 20, 2001
//:: Update Pass By: Preston W, On: July 26, 2001
//  7/11/2016   msheeler    added +1d8 per spell focus and AoE for epic spell focus

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"
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
    int nFociBonus = 4;
    int nMetaMagic = GetMetaMagicFeat();
    int nHP;
    int nCasterLevel = GetNewCasterLevel( OBJECT_SELF );
    effect eCure;
    effect eHarm;
    effect eVis;
    float fDelay;

//check for max bonus to HP roll
    if (nCasterLevel > 20)
    {
        nCasterLevel = 20;
    }

//check for foci and apply bonuses
    if (GetHasFeat (FEAT_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
        {
        nFociBonus = 5;
        }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
        nFociBonus = 6;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
        nFociBonus = 7;
        object oTarget = GetFirstObjectInShape (SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
        while (GetIsObjectValid (oTarget))
        {
            fDelay = GetRandomDelay();

            //Determine Healing/Harm Amount
            nHP = d8(nFociBonus) + nCasterLevel;

            //Make metamagic check
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                nHP = (8*nFociBonus) + nCasterLevel;
            }
            if (nMetaMagic == METAMAGIC_EMPOWER)
            {
                nHP = nHP + (nHP/2); //Damage/Healing is +50%
            }

            //If this is undead we harm them
            if (GetRacialType(oTarget) == RACIAL_TYPE_UNDEAD )
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CURE_CRITICAL_WOUNDS));

                //Make SR check
                if (!MyResistSpell(OBJECT_SELF, oTarget, fDelay))
                {
                    //Set the harm effect for correct HPs and Type
                    eHarm = EffectDamage (nHP, DAMAGE_TYPE_POSITIVE);
                    eVis = EffectVisualEffect (VFX_IMP_SUNSTRIKE);

                    //Apply positive damage and visual
                    DelayCommand(fDelay, ApplyEffectToObject (DURATION_TYPE_INSTANT, eHarm, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject (DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }

            else
            {
                //let's not heal enemies.
                if (GetIsReactionTypeFriendly (oTarget, OBJECT_SELF))
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CURE_CRITICAL_WOUNDS));

                    //Set the heal effect for correct HPs
                    eCure = EffectHeal (nHP);
                    eVis = EffectVisualEffect (VFX_IMP_HEALING_G);

                    //Apply healing and visual
                    DelayCommand(fDelay, ApplyEffectToObject (DURATION_TYPE_INSTANT, eCure, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject (DURATION_TYPE_INSTANT, eVis, oTarget));
                }
            }
            //get the next creature in range
            oTarget = GetNextObjectInShape (SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, GetSpellTargetLocation());
        }
    }
    else if (!GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
        spellsCure(d8(nFociBonus), 20, 32, VFX_IMP_SUNSTRIKE, VFX_IMP_HEALING_G, GetSpellId());
    }
}

