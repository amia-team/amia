//::///////////////////////////////////////////////
//:: Ball of Sound
//:: [amx_csp_bsound.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
1d3 per 2 caster levels points of sonic damage to one target.
*/
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: Feb 17 2024
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
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
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDamageCount = nCasterLevel / 2;
    int nDamage;
    int nMeta = GetMetaMagicFeat();

    effect eVis = EffectVisualEffect(VFX_COM_HIT_SONIC);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));
        //Make SR Check
        if(!MyResistSpell(OBJECT_SELF, oTarget))
        {
            // roll damage
            nDamage = d3(nDamageCount);
            //Make metamagic  check
            if (nMeta == METAMAGIC_MAXIMIZE)
            {
               nDamage = 3*nDamageCount;
            }
            if (nMeta == METAMAGIC_EMPOWER)
            {
                nDamage = nDamage + nDamage/2;
            }

            //Set damage effect

            effect eBad = EffectDamage(nDamage, DAMAGE_TYPE_SONIC);
            //Apply the VFX impact and damage effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eBad, oTarget);
        }
    }
}