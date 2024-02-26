//::///////////////////////////////////////////////
//:: Vinna's Greater Globe
//:: amx_csp_vinglobe.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Vinna's Greater Globe (Transmutation)
Level: Druid 4
Components: V,S
Range: Long
Area of Effect: Large
Duration 1 round/caster level/Instantaneous
Valid Metamagic: Still, Silent, Extend
Save: Reflex Negates, Fortitude Partial
Spell Resistance: Yes

This spell casts a globe of ravaging plants to assail their foes. Any enemies
caught in the spell's radius must make a reflex save or be entangled. The
victim's can make subsequent saves to escape the entanglement.
However, any targets hit by the entanglement must make a fortitude save or be
poisoned. The poison does 2d6 points of dexterity damage.
Also noted: If the target fails the reflex save but has freedom, while they
won't be entangled, they will still be subject to the poison.
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

    object oCaster      = OBJECT_SELF;
    int nCL      = GetNewCasterLevel(oCaster);
    int nMetaMagic      = GetMetaMagicFeat();
    location lTarget    = GetSpellTargetLocation();
    int nDur = nCL / 2;
    if (nMetaMagic == METAMAGIC_EXTEND) {
        nDur = nDur + nDur;
    }

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget)) {
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) {

            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

            float fDelay = 1.0f;
            if (!MyResistSpell(OBJECT_SELF, oTarget)) {
                if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, GetSpellSaveDC())) {
                    // Apply Entangle
                    effect eHold = EffectEntangle();
                    effect eEntangle = EffectVisualEffect(VFX_DUR_ENTANGLE);
                    //Link Entangle and Hold effects
                    effect eLink = EffectLinkEffects(eHold, eEntangle)
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur)));

                    if(!MySavingThrow(SAVING_THROW_FORTITUDE, oTarget, GetSpellSaveDC(). SAVING_THROW_TYPE_POISON)) {
                        // Apply Poison
                        //effect ePoison = EffectPoison(POISON_GIANT_WASP_POISON);
                        //DelayCommand(fDelay+fDelay,ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget));
                        effect ePoison = EffectAbilitydecrease(ABILITY_DEXTERITY, d6(2));
                        effect ePoivis = EffectVisualEffect(VFX_IMP_POISON_S);
                        effect eLink2 = EffectLinkEffects(ePoison, ePoivis);
                        DelayCommand(fDelay+fDelay, ApplyEffectToOjbect(DURATION_TYPE_PERMANENT, eLink2, oTarget);
                    }
                }
            }
        }

        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
}