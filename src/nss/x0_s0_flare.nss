//::///////////////////////////////////////////////
//:: Flare
//:: [X0_S0_Flare.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creature hit by flare loses 1 to attack rolls and is damaged by 1d4 per 3 caster levels points of fire damage.

    DURATION: 10 rounds.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:: Opustus 6/18/23 Added damage to scale 1d4 per 3 CL
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

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    int nCasterLevel = GetCasterLevel(OBJECT_SELF);
    int nDamageCount = nCasterLevel / 3;
    int nDamage;
    int nMeta = GetMetaMagicFeat();
    int nAttackDecrease = 1;

    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
       //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 416));

        //Make SR Check
        if ((!MyResistSpell(OBJECT_SELF, oTarget)))
        {
            // roll damage
            nDamage = d4(nDamageCount);
            //Make metamagic check
            if (nMeta == METAMAGIC_MAXIMIZE)
            {
               nDamage = 4*nDamageCount;
            }
            if (nMeta == METAMAGIC_EMPOWER)
            {
                nDamage = nDamage + nDamage/2;
            }

            effect eDamage = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);

            if (MySavingThrow(SAVING_THROW_FORT, oTarget, GetSpellSaveDC()) == FALSE)
            {
                effect eBad = EffectAttackDecrease(nAttackDecrease);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBad, oTarget, TurnsToSeconds(1));
            }
        }
    }
}
