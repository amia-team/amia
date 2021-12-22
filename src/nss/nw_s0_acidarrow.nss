//:: Melf's Acid Arrow
//:: MelfsAcidArrow.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    An acidic arrow springs from the caster's hands
    and does 3d6 acid damage to the target.  For
    every 3 levels the caster has the target takes an
    additional 1d6 per round.
*/
/////////////////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/09/01
//:://////////////////////////////////////////////
//:: Rewritten: Georg Zoeller, Oct 29, 2003
//:: Now uses VFX to track its own duration, cutting
//:: down the impact on the CPU to 1/6th
//:://////////////////////////////////////////////
//  7/11/2016   msheeler    added bonus damage for spell focus
//  11/15/2016  msheeler    Shadow Melf's Acid Arrow: Deals 3d6 cold + 3d6 negative
//                          energy damage, and 1d6 cold, 1d6 negative energy every
//                          round after for CL/3 rounds. Each spell focus adds 1d6
//                          cold/1d6 negative to the secondary damage.
//  11/16/2016  msheeler    re-wrote script to ditch wildly inefficient Bio-ware code.


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "x2_i0_spells"
#include "inc_td_shifter"

void main()
{
    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    // Variables
    object oTarget = GetSpellTargetObject();
    effect eDamCold;
    effect eDamNeg;
    effect eVisCold = EffectVisualEffect(VFX_IMP_FROST_L);
    effect eVisNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eDam;
    effect eVis;
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eArrow = EffectVisualEffect(245);
    effect ePoison;
    int nDuration = 1 + (GetNewCasterLevel(OBJECT_SELF)/3);
    int nDamage;
    int nSpellId = GetSpellId();
    int nDice = 3;
    int nBonus;
    int nArrowDamage;
    int nPoison;
    int nMetaMagic = GetMetaMagicFeat();
    float fDist = GetDistanceToObject(oTarget);
    float fDelay = (fDist/25.0);//(3.0 * log(fDist) + 2.0);

    // Check for spell focus and apply bonuses
    if (GetHasFeat (FEAT_SPELL_FOCUS_CONJURATION, OBJECT_SELF) && nSpellId == 115)
    {
        nDice = 4;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_CONJURATION, OBJECT_SELF) && nSpellId == 115)
    {
        nDice = 5;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, OBJECT_SELF) && nSpellId == 115)
    {
        nDice = 6;
    }
    if (GetHasFeat (FEAT_SPELL_FOCUS_ILLUSION, OBJECT_SELF) && nSpellId == 350)
    {
        nBonus = 1;
    }
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_ILLUSION, OBJECT_SELF) && nSpellId == 350)
    {
        nBonus = 2;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_ILLUSION, OBJECT_SELF) && nSpellId == 350)
    {
        nBonus = 3;
    }

    // Stop spell from stacking with like variant but allow shadow and normal variant to stack

    if (nSpellId == 115 && (GetHasSpellEffect(115,oTarget)))
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }
    if (nSpellId == 350 && (GetHasSpellEffect(350, oTarget)))
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }
    eDur = ExtraordinaryEffect(eDur);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration));

    // make sure duration is atleast 1 round
    if (nDuration < 1)
    {
        nDuration = 1;
    }

    // Set VFX for Normal or Shadow variant
    if (nSpellId == 115)
    {
        eVis = EffectVisualEffect(VFX_IMP_ACID_L);
    }

    if (nSpellId == 350)
    {
        eVis = EffectLinkEffects(eVisNeg, eVisCold);
    }

    // Transmutation
    if (nSpellId == 115)
    {
        nArrowDamage    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_MELFS_ACID_ARROW ) );
        nPoison         = POISON_MEDIUM_SPIDER_VENOM;
    }

    // * Dec 2003- added the reaction check back in
    if (GetIsReactionTypeFriendly(oTarget) == FALSE)
    {
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

        if (nArrowDamage == 2 && nSpellId == 115)
        {
            //set poison arrow
            if(GetMetaMagicFeat() == METAMAGIC_EMPOWER)
            {
                nPoison = POISON_LARGE_SPIDER_VENOM;
            }
            else if(GetMetaMagicFeat() == METAMAGIC_MAXIMIZE)
            {
                nPoison = POISON_HUGE_SPIDER_VENOM;
            }
            //set effect
            ePoison = EffectPoison( nPoison );

            //apply poison effect
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePoison, oTarget, RoundsToSeconds(nDuration)));
        }

        else if(MyResistSpell(OBJECT_SELF, oTarget) == FALSE)
        {
            // Do the initial damage
            if (nSpellId == 115)
            {
                nDamage = MaximizeOrEmpower(6, nDice, nMetaMagic);
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
            }
            if (nSpellId == 350)
            {
                nDamage = MaximizeOrEmpower(6,3,nMetaMagic);
                eDamCold = EffectDamage(nDamage,DAMAGE_TYPE_COLD );
                eDamNeg = EffectDamage(nDamage,DAMAGE_TYPE_NEGATIVE);
                eDam = EffectLinkEffects(eDamCold, eDamNeg);
            }

            DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay,ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

            //Set VFX to non-dispellable and apply to track targets that have spell effect.
            eDur = ExtraordinaryEffect(eDur);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nDuration+1));
        }

        else
        {
            // Indicate Failure
            effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
            DelayCommand(fDelay+0.1f,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
        }

        //loop through and set up extra rounds of damage
        while (nDuration > 0)
        {
            if (nSpellId == 115)
            {
                nDamage = MaximizeOrEmpower(6, nDice-2, nMetaMagic);
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_ACID);
                eVis = EffectVisualEffect(VFX_IMP_ACID_S);
            }
            if (nSpellId == 350)
            {
                nDamage = MaximizeOrEmpower(6, 1+nBonus, nMetaMagic);
                eDamCold = EffectDamage(nDamage, DAMAGE_TYPE_COLD);
                eDamNeg = EffectDamage(nDamage, DAMAGE_TYPE_NEGATIVE);
                eDam = EffectLinkEffects(eDamCold, eDamNeg);
                eVisCold = EffectVisualEffect(VFX_IMP_FROST_S);
                eVisNeg = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
                eVis = EffectLinkEffects(eVisCold, eVisNeg);
            }
            eDam = EffectLinkEffects(eVis,eDam);
            DelayCommand(RoundsToSeconds(nDuration), ApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget));
            nDuration -= 1;
        }
    }

    ApplyEffectToObject(DURATION_TYPE_INSTANT, eArrow, oTarget);
}

