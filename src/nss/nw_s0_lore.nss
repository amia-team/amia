//::///////////////////////////////////////////////
//:: Legend Lore
//:: NW_S0_Lore.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the caster a boost to Lore skill of 10
    plus 1 / 2 caster levels.  Lasts for 1 Turn per
    caster level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 22, 2001
//:://////////////////////////////////////////////
//:: 2003-10-29: GZ: Corrected spell target object
//::             so potions work wit henchmen now
/*
    Modified 04/10/13 Glim - Changed base lore bonus and per level bonus, as
                             well as adding bonuses based on Divination feats.
    Modified and fixed 1/23/2016 msheeler -
                            Greater Spell Focus allows the ability to add to Craft
                            Armor and Weapons skills. Epic Skill Focus allows the
                            spell to add to Spellcraft skill.
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
    int nLevel = GetCasterLevel(oTarget);
    int nBonus = 5 + (nLevel / 2);

    //check for Divination Spell Focus feats and apply bonus
    if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_DIVINATION, oTarget ) )
    {
        nBonus = nBonus + 15;
    }
    else if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_DIVINATION, oTarget ) )
    {
        nBonus = nBonus + 10;
    }
    else if( GetHasFeat( FEAT_SPELL_FOCUS_DIVINATION, oTarget ) )
    {
        nBonus = nBonus + 5;
    }

    effect eLore = EffectSkillIncrease(SKILL_LORE, nBonus);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGICAL_VISION);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eLink = EffectLinkEffects(eLore, eDur);
    effect eCraftArmor = EffectSkillIncrease(SKILL_CRAFT_ARMOR, nBonus);
    effect eCraftWeapon = EffectSkillIncrease (SKILL_CRAFT_WEAPON, nBonus);
    effect eSpellcraft = EffectSkillIncrease(SKILL_SPELLCRAFT, nBonus);

    int nMetaMagic = GetMetaMagicFeat();
    //Meta-Magic checks
    if(nMetaMagic == METAMAGIC_EXTEND)
    {
        nLevel *= 2;
    }
    //Make sure the spell has not already been applied
    if(!GetHasSpellEffect(SPELL_IDENTIFY, oTarget) || !GetHasSpellEffect(SPELL_LEGEND_LORE, oTarget))
    {
         SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_LEGEND_LORE, FALSE));
         //Apply linked and VFX effects
         ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nLevel));
         ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
         if( GetHasFeat( FEAT_GREATER_SPELL_FOCUS_DIVINATION, oTarget ) )
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCraftArmor, oTarget, TurnsToSeconds(nLevel));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eCraftWeapon, oTarget, TurnsToSeconds(nLevel));
        }
        if( GetHasFeat( FEAT_EPIC_SPELL_FOCUS_DIVINATION, oTarget ) )
        {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpellcraft, oTarget, TurnsToSeconds(nLevel));
        }
    }

}

