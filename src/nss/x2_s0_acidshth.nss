//::///////////////////////////////////////////////
//:: Mestil's Acid Sheath
//:: X2_S0_AcidShth
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell creates an acid shield around your
    person. Any creature striking you with its body
    does normal damage, but at the same time the
    attacker takes 1d6 points +2 points per caster
    level of acid damage. Weapons with exceptional
    reach do not endanger thier uses in this way.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:://////////////////////////////////////////////
//  7/11/2016   msheeler    damage changed to 1d6+cl, added 10(15)/- elemental resistance

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

    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    int nTransmutation    = GetLocalInt( OBJECT_SELF, "ds_spell_"+IntToString( SPELL_MESTILS_ACID_SHEATH ) );




    //Declare major variables
    effect eVis = EffectVisualEffect(448);
    int nDuration = GetCasterLevel(OBJECT_SELF);
    int nDamage = nDuration;
    int nMetaMagic = GetMetaMagicFeat();
    int nDice = 1;
    int nResist = 10;
    object oTarget = OBJECT_SELF;

    //Check for spell foci
    if (GetHasFeat (FEAT_GREATER_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
        nDice = 2;
    }
    if (GetHasFeat (FEAT_EPIC_SPELL_FOCUS_CONJURATION, OBJECT_SELF))
    {
        nDice = 3;
        nResist = 15;
    }

    //Set up effects
    effect eShield = EffectDamageShield(nDamage, d6(nDice), DAMAGE_TYPE_ACID);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eResistance = EffectDamageResistance(DAMAGE_TYPE_ACID, nResist, 0);
    //--------------------------------------------------------------------------
    // Transmutation
    //--------------------------------------------------------------------------
    if ( nTransmutation == 2 ){

        eShield = EffectDamageShield( nDamage, d6(nDice), DAMAGE_TYPE_COLD );
        eVis = EffectVisualEffect(VFX_DUR_GLOW_WHITE);
        eResistance = EffectDamageResistance(DAMAGE_TYPE_COLD, nResist, 0);
    }
    else if ( nTransmutation == 3 ){

        eShield = EffectDamageShield( nDamage, d6(nDice), DAMAGE_TYPE_FIRE );
        eVis = EffectVisualEffect(VFX_DUR_GLOW_RED);
        eResistance = EffectDamageResistance(DAMAGE_TYPE_FIRE, nResist, 0);
    }

    //Link effects
    effect eLink = EffectLinkEffects(eShield, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }

    // 2003-07-07: Stacking Spell Pass, Georg
    RemoveEffectsFromSpell(oTarget, GetSpellId());

    if ( GetHasSpellEffect(SPELL_ELEMENTAL_SHIELD) ) {
        RemoveSpellEffects(SPELL_ELEMENTAL_SHIELD, OBJECT_SELF, oTarget );
    }
    if ( GetHasSpellEffect(SPELL_DEATH_ARMOR) ) {
        RemoveSpellEffects(SPELL_DEATH_ARMOR, OBJECT_SELF, oTarget );
    }
    if ( GetHasSpellEffect(SPELL_WOUNDING_WHISPERS) ) {
        RemoveSpellEffects(SPELL_WOUNDING_WHISPERS, OBJECT_SELF, oTarget );
    }

    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eResistance, oTarget, RoundsToSeconds(nDuration));
}

