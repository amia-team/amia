//::///////////////////////////////////////////////
//:: Premonition
//:: NW_S0_Premo
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the gives the creature touched 30/+5
    damage reduction.  This lasts for 1 hour per
    caster level or until 10 * Caster Level
    is dealt to the person.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: March 16 , 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/10/2012 Mathias          Changed to add +2 hp per CL per divination focus feat.
//

#include "nw_i0_spells"
#include "amia_include"
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

    object oTarget = GetSpellTargetObject();

    // Divination bonus
    int nLimitBonus = 0;

    // Check for divination focus feats.
    if ( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_DIVINATION, OBJECT_SELF ) ) {
        nLimitBonus += 6 * GetCasterLevel(OBJECT_SELF);
    }
    else if ( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_DIVINATION, OBJECT_SELF ) ) {
        nLimitBonus += 4 * GetCasterLevel(OBJECT_SELF);
    }
    else if ( GetHasFeat( FEAT_SPELL_FOCUS_DIVINATION, OBJECT_SELF ) ) {
        nLimitBonus += 2 * GetCasterLevel(OBJECT_SELF);
    }

    //Declare major variables
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nLimit = nDuration * 10;
    nLimit = nLimit + nLimitBonus;  // Apply the divination bonus if any.
    int nMetaMagic = GetMetaMagicFeat();
    effect eStone = EffectDamageReduction(30, DAMAGE_POWER_PLUS_FIVE, nLimit);
    effect eVis = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);
    //Link the visual and the damage reduction effect
    effect eLink = EffectLinkEffects(eStone, eVis);
    //Enter Metamagic conditions
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_PREMONITION, FALSE));
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    RemoveEffectsFromSpell(oTarget, SPELL_PREMONITION);
    //Apply the linked effect
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, NewHoursToSeconds(nDuration));
}
