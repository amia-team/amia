/*
---------------------------------------------------------------------------------
NAME: fw_kissofvamp
DESCRIPTION: The caster gains features of a vampire, and inherits spell failure.
LOG:
    Faded Wings [10/30/2015 - Created]
----------------------------------------------------------------------------------
*/

/* includes */
#include "inc_dc_spells"

/* prototypes */
void KissOfTheVampire( object oPC );

void main()
{
    KissOfTheVampire( OBJECT_SELF );
}

void KissOfTheVampire( object oPC )
{
    int nMetaMagic      =       GetMetaMagicFeat();
    int nDuration       =       GetCasterLevel( oPC );
    // Merged Low (26)
    int nMerge          =       26; // 101 - 75

    // Undead Properties
    effect eMind        =       EffectImmunity( IMMUNITY_TYPE_MIND_SPELLS );
    effect eFear        =       EffectImmunity( IMMUNITY_TYPE_FEAR );
    effect eSneak       =       EffectImmunity( IMMUNITY_TYPE_SNEAK_ATTACK );
    effect eParalyze    =       EffectImmunity( IMMUNITY_TYPE_PARALYSIS );
    effect ePoison      =       EffectImmunity( IMMUNITY_TYPE_POISON );
    effect eDisease     =       EffectImmunity( IMMUNITY_TYPE_DISEASE );
    effect eDeath       =       EffectImmunity( IMMUNITY_TYPE_DEATH );
    effect eNegLevel    =       EffectImmunity( IMMUNITY_TYPE_NEGATIVE_LEVEL );
    effect eAbility     =       EffectImmunity( IMMUNITY_TYPE_ABILITY_DECREASE );
    effect eCrit        =       EffectImmunity( IMMUNITY_TYPE_CRITICAL_HIT );
    effect eRegen       =       EffectRegenerate( 5, RoundsToSeconds(1) );
    // Spell Failure
    effect eFail        =       EffectSpellFailure( );
    // VFX
    effect eVFX1        =       EffectVisualEffect( VFX_IMP_HARM );
    effect eVFX2        =       EffectVisualEffect( VFX_IMP_DEATH );

    effect eHide        =       EffectSkillIncrease( SKILL_HIDE, nMerge );
    effect eMS          =       EffectSkillIncrease( SKILL_MOVE_SILENTLY, nMerge );

    effect eLink = EffectLinkEffects( eMind, eFear );
    eLink = EffectLinkEffects(eLink, eSneak );
    eLink = EffectLinkEffects(eLink, eParalyze );
    eLink = EffectLinkEffects(eLink, ePoison );
    eLink = EffectLinkEffects(eLink, eDisease );
    eLink = EffectLinkEffects(eLink, eDeath );
    eLink = EffectLinkEffects(eLink, eNegLevel );
    eLink = EffectLinkEffects(eLink, eAbility );
    eLink = EffectLinkEffects(eLink, eCrit );
    eLink = EffectLinkEffects(eLink, eFail );
    eLink = EffectLinkEffects(eLink, eRegen );
    // Movement Speed
    eLink = EffectLinkEffects(eLink, EffectMovementSpeedIncrease( 90 ) );
    eLink = EffectLinkEffects(eLink, eHide );
    eLink = EffectLinkEffects(eLink, eMS );

    //Meta Magic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    // Apply visual and effect.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eLink, oPC, NewHoursToSeconds( nDuration ) );
}



/* OLD SPELL

#include "inc_dc_spells"

void main() { }

void KissOfTheVampire( object oPC ) {

    int     nDuration   = GetCasterLevel( oPC );
    int     nMetaMagic  = GetMetaMagicFeat();
    effect  ePolymorph  = EffectPolymorph( 197 );
    effect  eAbility    = EffectAbilityIncrease( ABILITY_CHARISMA, 10 );
    effect  eVFX1       = EffectVisualEffect( VFX_IMP_HARM );
    effect  eVFX2       = EffectVisualEffect( VFX_IMP_DEATH );
    effect  eDur        = EffectVisualEffect( 710 );

    //Meta Magic check for extend
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2;   //Duration is +100%
    }

    effect  eShift      = EffectLinkEffects( ePolymorph, eDur );
            eShift      = EffectLinkEffects( eAbility, eShift );

    int bWeapon = StringToInt(Get2DAString("polymorph","MergeW",197)) == 1;
    int bArmor  = StringToInt(Get2DAString("polymorph","MergeA",197)) == 1;
    int bItems  = StringToInt(Get2DAString("polymorph","MergeI",197)) == 1;

    object oWeaponOld = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorOld = GetItemInSlot(INVENTORY_SLOT_CHEST,oPC);
    object oRing1Old = GetItemInSlot(INVENTORY_SLOT_LEFTRING,oPC);
    object oRing2Old = GetItemInSlot(INVENTORY_SLOT_RIGHTRING,oPC);
    object oAmuletOld = GetItemInSlot(INVENTORY_SLOT_NECK,oPC);
    object oCloakOld  = GetItemInSlot(INVENTORY_SLOT_CLOAK,oPC);
    object oBootsOld  = GetItemInSlot(INVENTORY_SLOT_BOOTS,oPC);
    object oBeltOld = GetItemInSlot(INVENTORY_SLOT_BELT,oPC);
    object oHelmetOld = GetItemInSlot(INVENTORY_SLOT_HEAD,oPC);
    object oShield    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    if (GetIsObjectValid(oShield)){

        if (GetBaseItemType(oShield) !=BASE_ITEM_LARGESHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_SMALLSHIELD &&
            GetBaseItemType(oShield) !=BASE_ITEM_TOWERSHIELD)
        {
            oShield = OBJECT_INVALID;
        }
    }

    int nCannotDrown = ds_check_uw_items( oPC );

    //Apply the VFX impact and effects
    ClearAllActions(); // prevents an exploit

    // Apply visual and effect.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX1, oPC );
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX2, oPC );
    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eShift, oPC, NewHoursToSeconds( nDuration ) );

    object oWeaponNew = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC);
    object oArmorNew = GetItemInSlot(INVENTORY_SLOT_CARMOUR,oPC);

    SetLocalInt( oPC, "CannotDrown", nCannotDrown );

    if (bWeapon)
    {
        IPWildShapeCopyItemProperties(oWeaponOld,oWeaponNew, TRUE);
    }
    if (bArmor)
    {
        IPWildShapeCopyItemProperties(oShield,oArmorNew);
        IPWildShapeCopyItemProperties(oHelmetOld,oArmorNew);
        IPWildShapeCopyItemProperties(oArmorOld,oArmorNew);
    }
    if (bItems)
    {
        IPWildShapeCopyItemProperties(oRing1Old,oArmorNew);
        IPWildShapeCopyItemProperties(oRing2Old,oArmorNew);
        IPWildShapeCopyItemProperties(oAmuletOld,oArmorNew);
        IPWildShapeCopyItemProperties(oCloakOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBootsOld,oArmorNew);
        IPWildShapeCopyItemProperties(oBeltOld,oArmorNew);
    }
    SetCreatureAppearanceType( oPC, APPEARANCE_TYPE_HUMAN );
}
*/
