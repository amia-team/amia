//::///////////////////////////////////////////////
//:: Negative Energy Protection
//:: NW_S0_NegProt.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Grants immunity to negative damage, level drain
    and Ability Score Damage
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

/*
    19/05/2014  Glim    Changed Immunity to 50% instead of 100% with Abjuration
                        Focus bonuses of 5% per grade of Spell Focus.
*/

#include "x2_inc_spellhook"

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

// End of Spell Cast Hook


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);

    effect eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 50);
    effect eLevel = EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL);
    effect eAbil = EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE);

    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

    //Bonus of 5% Immunity per grade of Abjuration focus
    if( GetHasFeat( FEAT_SPELL_FOCUS_ABJURATION, OBJECT_SELF ) == TRUE )
    {
        eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 55);
    }
    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_ABJURATION, OBJECT_SELF ) == TRUE )
    {
        eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 60);
    }
    else if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_ABJURATION, OBJECT_SELF ) == TRUE )
    {
        eNeg = EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE, 65);
    }

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Link Effects
    effect eLink = EffectLinkEffects(eNeg, eLevel);
    eLink = EffectLinkEffects(eLink, eAbil);
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_NEGATIVE_ENERGY_PROTECTION, FALSE));

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration));
}

