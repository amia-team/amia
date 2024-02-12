//::///////////////////////////////////////////////
//:: Myrra's Hex
//:: amx_csp_myrrhex.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Myrra's Hex (Enchantment)
Level: Druid 1
Components: V,S
Range: Medium
Duration: 1 round, 1 round/level
Save: Will negates
Spell Resistance: Yes

This witch-hex will attempt to lay a curse of clumsiness upon the victim. The
victim must make a will save. If the save is failed, the victim will be knocked
down for 1 round, and be cursed with clumsiness, taking 1d6+1 points of
dexterity damage for 1 round per caster level. The dexterity damage cannot be
restored with a restoration, but a remove curse spell will remove it.
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
    effect eCurse = EffectCurse(0, d6(1)+1, 0, 0, 0, 0);
    effect eKD = EffectKnockdown();
    int nCL = GetNewCasterLevel(OBJECT_SELF);

    //Make sure that curse is of type supernatural not magical
    eCurse = SupernaturalEffect(eCurse);
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
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCurse, oTarget, RoundsToSeconds(nCL));
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKD, oTarget, RoundsToSeconds(1));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}