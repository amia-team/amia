//::///////////////////////////////////////////////
//:: Blessed Exorcism
//:: amx_csp_besexor.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
Blessed Exorcism (Conjuration)
Level: Cleric 6
Components: V,S
Range: Personal
Area of effect: Large
Duration: Instantaneous
Valid Metamagic: Still, Extend, Silent
Save: Special
Spell Resistance: No/Yes (See Description)

The cleric exorcises the influence of spirits opposed to their patron.
All allies in the area of effect are freed from mind influencing maladies, fear, daze, domination, stun, or other mind effects.

Any hostile undead or outsiders in the area of effect must make a will save or be turned for 1d6+1 rounds.
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
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    effect eHeal;
    effect eNature = EffectVisualEffect(VFX_IMP_SUNSTRIKE);

    int nRand, nNumDice;
    int nCasterLevel = GetNewCasterLevel(OBJECT_SELF);

    int nMetaMagic = GetMetaMagicFeat();
    float fDelay;
    //Set off fire and forget visual
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eNature, GetLocation(OBJECT_SELF));
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.

    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while(GetIsObjectValid(oTarget))
    {
        fDelay = GetRandomDelay();
        //Check to see how the caster feels about the targeted object
        if(GetIsFriend(oTarget)) {
            effect eSearch = GetFirstEffect(oTarget);
            while(GetIsEffectValid(eSearch)) {
                int nEtype = GetEffectType(eSearch);
                //Check to see if the effect matches a particular type defined below
                if (nEtype == EFFECT_TYPE_DAZED || nEtype == EFFECT_TYPE_CHARMED
                    || nEtype == EFFECT_TYPE_SLEEP || nEtype == EFFECT_TYPE_CONFUSED
                    || nEtype == EFFECT_TYPE_STUNNED || nEtype == EFFECT_TYPE_DOMINATED) {
                    RemoveEffect(oTarget, eSearch);
                    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_HOLY);
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget));
                }
                eSearch = GetNextEffect(oTarget);
            }
        } else if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)) {
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NATURES_BALANCE));
            if(!GetIsReactionTypeFriendly(oTarget)) {
                if (!MyResistSpell(OBJECT_SELF, oTarget)) {
                    //Check for saving throw
                    int iRType = GetRacialType(oTarget);
                    if (iRType == RACIAL_TYPE_UNDEAD || iRType == RACIAL_TYPE_OUTSIDER) {
                        if (!MySavingThrow(SAVING_THROW_WILL, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC() ))) {
                            int nRounds = d6(1) + 1;
                            //Enter Metamagic conditions
                            if (nMetaMagic == METAMAGIC_EXTEND) {
                                 nRounds = nRounds * 2;
                            }
                            effect eDebuff = EffectTurned();

                            effect eVisTurn = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
                            effect eLink = EffectLinkEffects(eVisTurn, eDebuff);

                            effect eImpactVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_30);

                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nRounds)));
                            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpactVis, oTarget));

                        }
                    }
                }
            }
        }
        //Select the next target within the spell shape.
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF), FALSE);
    }
}
