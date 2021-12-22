#include "amia_include"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

void BladeSong( object oPC );

void main(){

    BladeSong( OBJECT_SELF );
}

void BladeSong( object oPC )
{
    object oPC = OBJECT_SELF;
    int nINT        = GetAbilityModifier( ABILITY_INTELLIGENCE, oPC );
    object oWeapon  = GetWeapon( oPC );
    object oShield  = GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oPC );

    if( nINT > 7 )
    {
        nINT = 7;
    }

    if( nINT < 0 )
    {
        nINT = 0;
    }

    // General Bladesinger bonuses
    effect eAC                  = EffectACIncrease( nINT, AC_SHIELD_ENCHANTMENT_BONUS );
    effect eConc                = EffectSkillIncrease( SKILL_CONCENTRATION, 5 );
    effect eDisc                = EffectSkillIncrease( SKILL_DISCIPLINE, 5 );
    effect eParry               = EffectSkillIncrease( SKILL_PARRY, 10 );
    effect eSpell               = EffectSkillDecrease( SKILL_SPELLCRAFT, 10 );
    effect eVFX1                = EffectVisualEffect( 685 );

    // Song of Fury bonuses
    effect eAttack              = EffectModifyAttacks( 1 );
    effect eAB                  = EffectAttackDecrease( 2 );
    effect eConc2               = EffectSkillDecrease( SKILL_CONCENTRATION, 10 );
    effect eVFX2                = EffectVisualEffect( 687 );
    itemproperty ipOnHitDaze    = ItemPropertyOnHitProps( IP_CONST_ONHIT_DAZE, IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS );
    itemproperty ipDamage       = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_MAGICAL, IP_CONST_DAMAGEBONUS_1d6 );

    effect eLink                = EffectLinkEffects( eAC, eConc );
           eLink                = EffectLinkEffects( eDisc, eLink );
           eLink                = EffectLinkEffects( eParry, eLink );
           eLink                = EffectLinkEffects( eSpell, eLink );
           eLink                = EffectLinkEffects( eVFX1, eLink );
           eLink                = EffectLinkEffects( eAttack, eLink );
           eLink                = EffectLinkEffects( eAB, eLink );
           eLink                = EffectLinkEffects( eConc2, eLink );

    eLink   = ExtraordinaryEffect( eLink );

    if( GetHasSpellEffect( GetSpellId(), oPC ) )
    {
        FloatingTextStringOnCreature( " - Bladesong Deactivated -", oPC, FALSE );
        RemoveEffectsFromSpell( oPC, GetSpellId() );
        RemoveEffectsFromSpell( oWeapon, GetSpellId() );
        return;
    }
    else if( GetHasSpellEffect( GetSpellId(), oWeapon ) )
    {
        FloatingTextStringOnCreature( " - Bladesong Deactivated -", oPC, FALSE );
        RemoveEffectsFromSpell( oPC, GetSpellId() );
        RemoveEffectsFromSpell( oWeapon, GetSpellId() );
        return;
    }
    else
    {
        if( oShield != OBJECT_INVALID )
        {
            FloatingTextStringOnCreature( " - You cannot Bladesing with an off-hand weapon/shield equipped! -", oPC, FALSE );
            return;
        }

        if ( GetHasSpellEffect( SPELL_DARKFIRE, oWeapon ) || GetHasSpellEffect( SPELL_FLAME_WEAPON, oWeapon ) )
        {
            RemoveEffectsFromSpell( oWeapon, SPELL_DARKFIRE );
            RemoveEffectsFromSpell( oWeapon, SPELL_FLAME_WEAPON );
        }

        FloatingTextStringOnCreature( " - Bladesong Activated -", oPC, FALSE );

        ApplyEffectToObject( DURATION_TYPE_PERMANENT, eLink, oPC );
        ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC );
        IPSafeAddItemProperty( oWeapon, ipDamage, 1000000.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
        IPSafeAddItemProperty( oWeapon, ipOnHitDaze, 1000000.0f, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE );
    }
}
