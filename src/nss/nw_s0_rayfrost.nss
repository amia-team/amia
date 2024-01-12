//::///////////////////////////////////////////////
//:: Ray of Frost
//:: [NW_S0_RayFrost.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If the caster succeeds at a ranged touch attack
    the target takes 1d4 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: feb 4, 2001
//:://////////////////////////////////////////////
//:: Bug Fix: Andrew Nobbs, April 17, 2003
//:: Notes: Took out ranged attack roll.
//:: Opustus 6/18/23 Changed to scale 1d3 per 2 CL
//:://////////////////////////////////////////////


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{
    CantripRefresh();
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

    // Declare major variables
    object oTarget   = GetSpellTargetObject();
    int nMeta        = GetMetaMagicFeat();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDamageCount = nCasterLevel / 2;
    int nDamage;
    effect eVis      = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eRay      = EffectBeam(VFX_BEAM_COLD, OBJECT_SELF, BODY_NODE_HAND);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_FROST));

        //Make SR Check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // roll damage
             nDamage= d3(nDamageCount);
            //Make metamagic  check
            if (nMeta == METAMAGIC_MAXIMIZE)
            {
                nDamage= 3*nDamageCount;
            }
            if (nMeta == METAMAGIC_EMPOWER)
            {
                nDamage = nDamage + nDamage/2;
            }
            //Set damage effect
            effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
            //Apply the VFX impact and damage effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
        }
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 1.7);
}
