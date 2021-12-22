//::///////////////////////////////////////////////
//:: Death Armor
//:: X2_S0_DthArm
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    You are surrounded with a magical aura that injures
    creatures that contact it. Any creature striking
    you with its body or handheld weapon takes 1d4 points
    of damage +1 point per 2 caster levels (maximum +5).
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Jan 6, 2003
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs, 02/06/2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//2011/10/23    PoS         Added PM levels to caster level and SR calculation

#include "x2_inc_spellhook"
#include "x0_i0_spells"

void main()
{

    /*
      Spellcast Hook Code
      Added 2003-07-07 by Georg Zoeller
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more

    */

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    if( GetAppearanceType(OBJECT_SELF) == 376 ||
        GetAppearanceType(OBJECT_SELF) == 377 ||
        GetAppearanceType(OBJECT_SELF) == 378 ||
        GetAppearanceType(OBJECT_SELF) == 379 ||
        GetAppearanceType(OBJECT_SELF) == 380 ||
        GetAppearanceType(OBJECT_SELF) == 975 )
    {
        FloatingTextStringOnCreature( "This spell cannot be used in your current form!", OBJECT_SELF, FALSE );
        return;
    }

    // End of Spell Cast Hook
    object oTarget = GetSpellTargetObject();
    int nPMLevel = GetLevelByClass( CLASS_TYPE_PALEMASTER, oTarget );

    int nDuration = GetCasterLevel(oTarget) + nPMLevel;
    int nCasterLvl = GetCasterLevel(oTarget)/2;
    if(nCasterLvl > 5)
    {
        nCasterLvl = 5;
    }
    int nMetaMagic = GetMetaMagicFeat();

    effect eShield = EffectDamageShield(nCasterLvl, DAMAGE_BONUS_1d4, DAMAGE_TYPE_MAGICAL);
    effect eDur = EffectVisualEffect(463);

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eDur);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    //Stacking Spellpass, 2003-07-07, Georg
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    if ( GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD) ) {
        RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, oTarget );
    }
    if ( GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH) ) {
        RemoveSpellEffects(SPELL_MESTILS_ACID_SHEATH, OBJECT_SELF, oTarget );
    }
    if ( GetHasSpellEffect(SPELL_WOUNDING_WHISPERS) ) {
        RemoveSpellEffects(SPELL_WOUNDING_WHISPERS, OBJECT_SELF, oTarget );
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
}

