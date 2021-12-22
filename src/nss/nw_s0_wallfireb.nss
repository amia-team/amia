//::///////////////////////////////////////////////
//:: Wall of Fire: On Exit
//:: NW_S0_wallfireb.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person exiting the AoE take 2d6 fire damage
    per round with ESF
*/
//:://////////////////////////////////////////////
//:: Created By: msheeler
//:: Created On: 7/29/2016
//:://////////////////////////////////////////////

// 1/10/2017    msheeler    Added SR Check and reflex save for onExit.

#include "x2_inc_spellhook"

void main()
{
    //Delcare variables
    int nDamage = d6(2);
    int nMetaMagic = GetMetaMagicFeat();
    object oCaster = GetAreaOfEffectCreator ();

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_MAXIMIZE)
    {
        nDamage = 12;//Damage is at max
    }
    if (nMetaMagic == METAMAGIC_EMPOWER)
    {
        nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
    }

    effect eVFX = EffectVisualEffect(VFX_DUR_INFERNO_CHEST);
    effect eBurn = EffectDamage (nDamage, DAMAGE_TYPE_FIRE);

    //Get the object that is exiting the AOE
    object oTarget = GetExitingObject();

    //check if caster had ESF
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_EVOCATION, oCaster))
    {
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
        {
            nDamage = GetReflexAdjustedDamage(nDamage, oTarget, GetSpellSaveDC(), SAVING_THROW_TYPE_FIRE);
            if (nDamage > 0)
            {
                //make sure we dont stack the effects
                if(GetHasSpellEffect(GetSpellId(), oTarget))
                {
                    RemoveEffectsFromSpell(oTarget, GetSpellId());
                }

                if(!GetIsFriend(oTarget,oCaster))
                {
                //apply the effects
                ApplyEffectToObject (DURATION_TYPE_TEMPORARY, eVFX, oTarget, RoundsToSeconds(3));
                DelayCommand (RoundsToSeconds(1), ApplyEffectToObject (DURATION_TYPE_INSTANT, eBurn, oTarget));
                DelayCommand (RoundsToSeconds(2), ApplyEffectToObject (DURATION_TYPE_INSTANT, eBurn, oTarget));
                DelayCommand (RoundsToSeconds(3), ApplyEffectToObject (DURATION_TYPE_INSTANT, eBurn, oTarget));
                }
            }
        }
    }
}
