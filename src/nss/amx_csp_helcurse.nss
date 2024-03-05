//::///////////////////////////////////////////////
//:: Helma's Curse
//:: amx_csp_helcurse.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Helma's Curse (Necromancy)
Level: Cleric 2
Components: V,S
Range: Short
Area of effect: Single
Duration: 1 Round/level
Valid Metamagic: Still, Extend, Silent
Save: Will Negates
Spell Resistance: Yes

The cleric utters a curse upon enemies of their faith. The curse causes weariness
and exhaustion, causing 2 points of strength drain, 2 points of constitution drain,
and inflicts a 30% movement speed decrease for 1 round per caster level. This effect
cannot be cured by a restoration, however a remove curse can remove the effect.
*/
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: Feb 12, 2024
//:://////////////////////////////////////////////
//::

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "inc_td_shifter"

void main()
{
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eCurse = EffectCurse(2, 0, 2, 0, 0, 0);
    effect eMD = EffectMovementSpeedDecrease(30);
    int nDur = GetNewCasterLevel(OBJECT_SELF);

    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDur = nDur + nDur;
    }

    //Make sure that curse is of type supernatural not magical
    eCurse = SupernaturalEffect(eCurse);
    eMD = SupernaturalEffect(eMD);
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(oTarget, SPELL_BESTOW_CURSE));
         //Make SR Check
         if (!MyResistSpell(OBJECT_SELF, oTarget))
         {
            //Make Will Save
            if (!/*Will Save*/ MySavingThrow(SAVING_THROW_WILL, oTarget, GetSpellSaveDC()))
            {
                //Apply Effect and VFX
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurse, oTarget, RoundsToSeconds(nDur));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMD, oTarget, RoundsToSeconds(nDur));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}