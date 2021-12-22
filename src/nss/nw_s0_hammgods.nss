//::///////////////////////////////////////////////
//:: Hammer of the Gods
//:: [NW_S0_HammGods.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Does 1d8 damage to all enemies within the
//:: spells 20m radius and dazes them if a
//:: Will save is failed.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 12, 2001
//:://////////////////////////////////////////////
//:: VFX Pass By: Preston W, On: June 21, 2001
//:: Update Pass By: Preston W, On: Aug 1, 2001

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

// End of Spell Cast Hook


    //Declare major variables
    int nCasterLvl = GetNewCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    int nBonusMaxDice= 0;
    effect eDam;
    effect eDaze = EffectDazed();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);

    effect eLink = EffectLinkEffects(eMind, eDaze);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eVis = EffectVisualEffect(VFX_IMP_DIVINE_STRIKE_HOLY);
    effect eStrike = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
    float fDelay;
    int nDamageDice = nCasterLvl/2;
    int nDamageDie;
    if(nDamageDice == 0)
    {
        nDamageDice = 1;
    }
    //Limit caster level
    if (nDamageDice > 5)
    {
        nDamageDice = 5;
    }

    // determine bonus for spell foci
    if (GetHasFeat (FEAT_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nBonusMaxDice = 2;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nBonusMaxDice = 4;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, OBJECT_SELF))
    {
        nBonusMaxDice = 6;
    }

    int nDamage;
    //Apply the holy strike VFX
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, GetSpellTargetLocation());
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
    while (GetIsObjectValid(oTarget))
    {
       //Make faction checks
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_HAMMER_OF_THE_GODS));
            //Make SR Check
            if (!MyResistSpell(OBJECT_SELF, oTarget))
            {
                if ((GetAlignmentGoodEvil (OBJECT_SELF) == ALIGNMENT_GOOD) && (GetAlignmentGoodEvil (oTarget) == ALIGNMENT_EVIL))
                {
                    nDamageDie = 10;
                }
                else if ((GetAlignmentGoodEvil (OBJECT_SELF) == ALIGNMENT_EVIL) && (GetAlignmentGoodEvil (oTarget) == ALIGNMENT_GOOD))
                {
                    nDamageDie = 10;
                }
                else if ((GetAlignmentLawChaos (OBJECT_SELF) == ALIGNMENT_LAWFUL) && (GetAlignmentLawChaos (oTarget) == ALIGNMENT_CHAOTIC))
                {
                    nDamageDie = 10;
                }
                else if ((GetAlignmentLawChaos (OBJECT_SELF) == ALIGNMENT_CHAOTIC) && (GetAlignmentLawChaos (oTarget) == ALIGNMENT_LAWFUL))
                {
                    nDamageDie = 10;
                }
                else
                {
                    nDamageDie = 8;
                }
                fDelay = GetRandomDelay(0.6, 1.3);
                //Roll damage
                if (nDamageDie == 10)
                {
                    nDamage = d10(nDamageDice + nBonusMaxDice);
                }
                else
                {
                    nDamage = d8(nDamageDice + nBonusMaxDice);
                }
                //Make metamagic checks
                if (nMetaMagic == METAMAGIC_MAXIMIZE)
                {
                    nDamage = nDamageDie * (nDamageDice + nBonusMaxDice);
                }
                else if (nMetaMagic == METAMAGIC_EMPOWER)
                {
                    nDamage = FloatToInt( IntToFloat(nDamage) * 1.5 );
                }
                //Make a will save for half damage and negation of daze effect
                if (MySavingThrow(SAVING_THROW_WILL, oTarget, GetShifterDC( OBJECT_SELF, GetSpellSaveDC()), SAVING_THROW_TYPE_DIVINE, OBJECT_SELF, 0.5))
                {
                    nDamage = nDamage / 2;
                }
                else
                {
                    if( GetIsPolymorphed( OBJECT_SELF) )
                    {
                        //Apply daze effect
                        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(1)));
                    }
                    else
                    {
                        //Apply daze effect
                        DelayCommand(0.5, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(d6())));
                    }
                }
                //Set damage effect
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_DIVINE );
                //Apply the VFX impact and damage effect
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
             }
        }
        //Get next target in shape
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, GetSpellTargetLocation());
    }
}
