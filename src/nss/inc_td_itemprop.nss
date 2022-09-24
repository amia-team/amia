//-------------------------------------------------------------------------------
// Created By: Terra_777
// Filename: inc_td_itemprop
//-------------------------------------------------------------------------------

#include "x2_inc_itemprop"
//void main(){}

//-------------------------------------------------------------------------------
//Constants
//-------------------------------------------------------------------------------

//Includes
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
//Prototypes
//-------------------------------------------------------------------------------

//Same as Get2DAString only that this one catches the data for minimum
//Executation of Get2DAString
string Catch2DAString( string s2DA, string sColumn, int nRow );

//Same as GetStringByStrRef only that this one catches the data for minimum
//Executation of GetStringByStrRef
string CatchStringByStrRef( int nStrRef, int nGender = GENDER_BOTH );

//Get the item property string IE:
//"Ability Bonus: Charisma +1" etc
string GetItemPropertyString( itemproperty IP );

//Makes an invalid itemproperty
itemproperty ItemPropertyInvalid( );

//Creates an item property according to nType
//Differant itemproperties uses differant paramters
//IE: Ability bonus would use subtype for the ability and costtable value for bonus
itemproperty CreateItemProperty( int nType, int nSubType, int nCostValue, int nParam1Value );

//Save a item property on oObject for retrival later
void SetLocalItemProperty( object oObject, string sVarName, itemproperty IP );

//Retrive previously stored item property from oObject
itemproperty GetLocalItemProperty( object oObject, string sVarName );

//Delete a stored item property on oObject
void DeleteLocalItemProperty( object oObject, string sVarName );

//Returns true if oItem supports IP to be added on it
int GetItemPropertyIsApplyAbleOnItem( object oItem, itemproperty IP );

//Removes all itemproperties from oItem
void DeleteAllItemProperties( object oItem );

//Applies the itemproperties available on oMergeFrom to oMergeTo
//oPC reives the feedback messages, declare oPC OBJECT_INVALID if no feedback is wanted
void MergeItemProperties( object oPC ,object oMergeFrom, object oMergeTo, int nIgnoreUseLimitations = TRUE );

//Removes all item properties of a specific type from oItem
void RemoveItemPropertyByType( object oItem, int nIPType );

//Returns the name of the slot
string GetInventorySlotName( int nSlot );

// Returns Spell Target is a weapon or its main hand weapon, or
// its off hand weapon if nSpell was already cast on the main hand weapon
// - nSpell: SPELL_*
// - nType: 0 All Weapons, 1 melee weapon only, 2 ranged weapon only
object GetTargetedOrEquippedWeaponForSpell( int nSpell, int nType=0);

// Returns Spell Target is a weapon or its armor, or
// its shield if nSpell was already cast on the armor
// - nSpell: SPELL_*
object GetTargetedOrQuippedArmorForSpell( int nSpell );

// Get the object which is in oCreature's specified inventory slot if it doesn't
// have the specified spell's efect on it and checks if its either a weapon or armor.
// - nInventorySlot: INVENTORY_SLOT_*
// - nSpell: SPELL_*
// - oCreature
// - nType: 0 All Weapons, 1 melee weapon only, 2 ranged weapon only, 3 Armor.
// * Returns OBJECT_INVALID if oCreature is not a valid creature or there is no
//   item in nInventorySlot.
object GetItemInSlotForSpell ( int nInventorySlot, int nSpell, object oCreature=OBJECT_SELF, int nType = 0);
//-------------------------------------------------------------------------------
//Function definitons
//-------------------------------------------------------------------------------

string GetInventorySlotName( int nSlot ){

    switch( nSlot ){

        case INVENTORY_SLOT_ARMS: return "Arms";
        case INVENTORY_SLOT_ARROWS: return "Arrows";
        case INVENTORY_SLOT_BELT: return "Belt";
        case INVENTORY_SLOT_BOLTS: return "Bolts";
        case INVENTORY_SLOT_BOOTS: return "Boots";
        case INVENTORY_SLOT_BULLETS: return "Bullets";
        case INVENTORY_SLOT_CARMOUR: return "Creature hide";
        case INVENTORY_SLOT_CHEST: return "Chest";
        case INVENTORY_SLOT_CLOAK: return "Cloak";
        case INVENTORY_SLOT_CWEAPON_B: return "Creature weapon bite";
        case INVENTORY_SLOT_CWEAPON_L: return "Creature weapon left";
        case INVENTORY_SLOT_CWEAPON_R: return "Creature weapon right";
        case INVENTORY_SLOT_HEAD: return "Head";
        case INVENTORY_SLOT_LEFTHAND: return "Left hand";
        case INVENTORY_SLOT_LEFTRING: return "Left ring";
        case INVENTORY_SLOT_NECK: return "Neck";
        case INVENTORY_SLOT_RIGHTHAND: return "Right hand";
        case INVENTORY_SLOT_RIGHTRING: return "Right ring";
        default: break;
    }
    return "";
}


void RemoveItemPropertyByType( object oItem, int nIPType ){

    itemproperty IP = GetFirstItemProperty( oItem );
    while( GetIsItemPropertyValid( IP ) ){

        if( GetItemPropertyType( IP ) == nIPType )
            RemoveItemProperty( oItem, IP );

        IP = GetNextItemProperty( oItem );
    }
}

void MergeItemProperties( object oPC ,object oMergeFrom, object oMergeTo, int nIgnoreUseLimitations = TRUE ){

    if( GetObjectType( oMergeFrom ) != OBJECT_TYPE_ITEM || GetObjectType( oMergeTo ) != OBJECT_TYPE_ITEM  )
        return;

    itemproperty    IP      = GetFirstItemProperty( oMergeFrom );
    int             nType   = 0;

    while( GetIsItemPropertyValid( IP ) ){

        nType = GetItemPropertyType( IP );

        if( !nIgnoreUseLimitations ||

        (   nType != ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP       &&
            nType != ITEM_PROPERTY_USE_LIMITATION_CLASS                 &&
            nType != ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE           &&
            nType != ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT    &&
            nType != ITEM_PROPERTY_USE_LIMITATION_TILESET               ) ) {

            if( GetItemPropertyIsApplyAbleOnItem( oMergeTo, IP ) ){

                if( nType != ITEM_PROPERTY_UNLIMITED_AMMUNITION ) {

                    SendMessageToPC( oPC, "<cþ þ>"+GetItemPropertyString( IP ) );
                    AddItemProperty( DURATION_TYPE_PERMANENT, IP, oMergeTo );
                }
            }
            else
                SendMessageToPC( oPC, "<cþ  >"+GetItemPropertyString( IP ) );

        }
        IP = GetNextItemProperty( oMergeFrom );
    }
}

void DeleteAllItemProperties( object oItem ){

    itemproperty IP = GetFirstItemProperty( oItem );
    while( GetIsItemPropertyValid( IP ) ){
        RemoveItemProperty( oItem, IP );
        IP = GetNextItemProperty( oItem );
    }
}

int GetItemPropertyIsApplyAbleOnItem( object oItem, itemproperty IP ){

    int nItemType   = GetBaseItemType( oItem );
    int nIPTtype    = GetItemPropertyType( IP );
    string sColumn  = "";

    switch( nItemType ){

        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HANDAXE:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MORNINGSTAR:
        case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SCYTHE:
        case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHORTSWORD:
        case BASE_ITEM_SICKLE:
        case BASE_ITEM_TRIDENT:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WARHAMMER:
        case BASE_ITEM_WHIP:
            sColumn = "0_Melee";
            break;

        case BASE_ITEM_LONGBOW:
        case BASE_ITEM_SHORTBOW:
        case BASE_ITEM_SLING:
        case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_LIGHTCROSSBOW:
            sColumn = "1_Ranged";
            break;

        case BASE_ITEM_DART:
        case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_THROWINGAXE:
            sColumn = "2_Thrown";
            break;

        case BASE_ITEM_MAGICSTAFF:
        case BASE_ITEM_MAGICSTAFF2h:
            sColumn = "3_Staves";
            break;

        case BASE_ITEM_MAGICROD:
            sColumn = "4_Rods";
            break;

        case BASE_ITEM_ARROW:
        case BASE_ITEM_BOLT:
        case BASE_ITEM_BULLET:
            sColumn = "5_Ammo";
            break;

        case BASE_ITEM_SMALLSHIELD:
        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_TOWERSHIELD:
            sColumn = "6_Arm_Shld";
            break;

        case BASE_ITEM_HELMET:
            sColumn = "7_Helm";
            break;

        case BASE_ITEM_POTIONS:
            sColumn = "8_Potions";
            break;

        case BASE_ITEM_SCROLL:
            sColumn = "9_Scrolls";
            break;

        case BASE_ITEM_MAGICWAND:
            sColumn = "10_Wands";
            break;

        case BASE_ITEM_THIEVESTOOLS:
            sColumn = "11_Thieves";
            break;

        case BASE_ITEM_TRAPKIT:
            sColumn = "12_TrapKits";
            break;

        case BASE_ITEM_CREATUREITEM:
            sColumn = "13_Hide";
            break;

        case BASE_ITEM_CPIERCWEAPON:
        case BASE_ITEM_CSLASHWEAPON:
        case BASE_ITEM_CSLSHPRCWEAP:
        case BASE_ITEM_CBLUDGWEAPON:
            sColumn = "14_Claw";
            break;

        case BASE_ITEM_MISCLARGE:
        case BASE_ITEM_MISCMEDIUM:
        case BASE_ITEM_MISCSMALL:
        case BASE_ITEM_MISCTALL:
        case BASE_ITEM_MISCTHIN:
        case BASE_ITEM_MISCWIDE:
            sColumn = "15_Misc_Uneq";
            break;

        case BASE_ITEM_LARGEBOX:
            sColumn = "18_Containers";
            break;

        case BASE_ITEM_HEALERSKIT:
            sColumn = "19_HealerKit";
            break;

        case BASE_ITEM_TORCH:
            sColumn = "20_Torch";
            break;

        case BASE_ITEM_GLOVES:
            sColumn = "21_Glove";
            break;

        case BASE_ITEM_INVALID:
            sColumn = "17_No_Props";
            break;

        default:
            sColumn = "16_Misc";
            break;
    }

    return StringToInt( Catch2DAString( "ItemProps", sColumn, nIPTtype ) );
}

void SetLocalItemProperty( object oObject, string sVarName, itemproperty IP ){

    SetLocalInt( oObject, sVarName+"_type", GetItemPropertyType( IP ) );
    SetLocalInt( oObject, sVarName+"_ctv", GetItemPropertyCostTableValue( IP ) );
    SetLocalInt( oObject, sVarName+"_prm", GetItemPropertyParam1Value( IP ) );
    SetLocalInt( oObject, sVarName+"_styp", GetItemPropertySubType( IP ) );
    SetLocalInt( oObject, sVarName+"_vlid", TRUE );
}

itemproperty GetLocalItemProperty( object oObject, string sVarName ){

    if( GetLocalInt( oObject, sVarName+"_vlid" ) != TRUE )
        return ItemPropertyInvalid();

    int nType   = GetLocalInt( oObject, sVarName+"_type" );
    int nSubt   = GetLocalInt( oObject, sVarName+"_styp" );
    int nCost   = GetLocalInt( oObject, sVarName+"_ctv" );
    int nParm   = GetLocalInt( oObject, sVarName+"_prm" );

    return CreateItemProperty( nType, nSubt, nCost, nParm );
}

void DeleteLocalItemProperty( object oObject, string sVarName ){

    DeleteLocalInt( oObject, sVarName+"_vlid" );
    DeleteLocalInt( oObject, sVarName+"_type" );
    DeleteLocalInt( oObject, sVarName+"_ctv" );
    DeleteLocalInt( oObject, sVarName+"_prm" );
    DeleteLocalInt( oObject, sVarName+"_styp" );

}

itemproperty CreateItemProperty( int nType, int nSubType, int nCostValue, int nParam1Value ){

    switch( nType ){

        case ITEM_PROPERTY_ABILITY_BONUS:
            return ItemPropertyAbilityBonus( nSubType, nCostValue );

        case ITEM_PROPERTY_AC_BONUS:
            return ItemPropertyACBonus( nCostValue );

        case ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP:
            return ItemPropertyACBonusVsAlign( nSubType, nCostValue );

        case ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE:
            return ItemPropertyACBonusVsDmgType( nSubType, nCostValue );

        case ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP:
            return ItemPropertyACBonusVsRace( nSubType, nCostValue );

        case ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT:
            return ItemPropertyACBonusVsSAlign( nSubType, nCostValue );

        case ITEM_PROPERTY_ADDITIONAL:
            return ItemPropertyAdditional( nCostValue );

        case ITEM_PROPERTY_ARCANE_SPELL_FAILURE:
            return ItemPropertyArcaneSpellFailure( nCostValue );

        case ITEM_PROPERTY_ATTACK_BONUS:
            return ItemPropertyAttackBonus( nCostValue );

        case ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP:
            return ItemPropertyAttackBonusVsAlign( nSubType, nCostValue );

        case ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP:
            return ItemPropertyAttackBonusVsRace( nSubType, nCostValue );

        case ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT:
            return ItemPropertyAttackBonusVsSAlign( nSubType, nCostValue );

        case ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION:
            return ItemPropertyWeightReduction( nCostValue );

        case ITEM_PROPERTY_BONUS_FEAT:
            return ItemPropertyBonusFeat( nSubType );

        case ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N:
            return ItemPropertyBonusLevelSpell( nSubType, nCostValue );

        case ITEM_PROPERTY_CAST_SPELL:
            return ItemPropertyCastSpell( nSubType, nCostValue );

        case ITEM_PROPERTY_DAMAGE_BONUS:
            return ItemPropertyDamageBonus( nSubType, nCostValue );

        case ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP:
            return ItemPropertyDamageBonusVsAlign( nSubType, nParam1Value ,nCostValue );

        case ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP:
            return ItemPropertyDamageBonusVsRace( nSubType, nParam1Value ,nCostValue );

        case ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT:
            return ItemPropertyDamageBonusVsSAlign( nSubType, nParam1Value ,nCostValue );

        case ITEM_PROPERTY_DAMAGE_REDUCTION:
            return ItemPropertyDamageReduction( nSubType, nCostValue );

        case ITEM_PROPERTY_DAMAGE_RESISTANCE:
            return ItemPropertyDamageResistance( nSubType, nCostValue );

        case ITEM_PROPERTY_DAMAGE_VULNERABILITY:
            return ItemPropertyDamageVulnerability( nSubType, nCostValue );

        case ITEM_PROPERTY_DARKVISION:
            return ItemPropertyDarkvision( );

        case ITEM_PROPERTY_DECREASED_ABILITY_SCORE:
            return ItemPropertyDecreaseAbility( nSubType, nCostValue );

        case ITEM_PROPERTY_DECREASED_AC:
            return ItemPropertyDecreaseAC( nSubType, nCostValue );

        case ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER:
            return ItemPropertyAttackPenalty( nCostValue );

        case ITEM_PROPERTY_DECREASED_DAMAGE:
            return ItemPropertyDamagePenalty( nCostValue );

        case ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER:
            return ItemPropertyEnhancementPenalty( nCostValue );

        case ITEM_PROPERTY_DECREASED_SAVING_THROWS:
            return ItemPropertyReducedSavingThrow( nSubType, nCostValue );

        case ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC:
            return ItemPropertyReducedSavingThrowVsX( nSubType, nCostValue );

        case ITEM_PROPERTY_DECREASED_SKILL_MODIFIER:
            return ItemPropertyDecreaseSkill( nSubType, nCostValue );

        case ITEM_PROPERTY_ENHANCED_CONTAINER_REDUCED_WEIGHT:
            return ItemPropertyContainerReducedWeight( nCostValue );

        case ITEM_PROPERTY_ENHANCEMENT_BONUS:
            return ItemPropertyEnhancementBonus( nCostValue );

        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP:
            return ItemPropertyEnhancementBonusVsAlign( nSubType, nCostValue );

        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP:
            return ItemPropertyEnhancementBonusVsRace( nSubType, nCostValue );

        case ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT:
            return ItemPropertyEnhancementBonusVsSAlign( nSubType, nCostValue );

        case ITEM_PROPERTY_EXTRA_MELEE_DAMAGE_TYPE:
            return ItemPropertyExtraMeleeDamageType( nSubType );

        case ITEM_PROPERTY_EXTRA_RANGED_DAMAGE_TYPE:
            return ItemPropertyExtraRangeDamageType( nSubType );

        case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
            return ItemPropertyFreeAction( );

        case ITEM_PROPERTY_HASTE:
            return ItemPropertyHaste( );

        case ITEM_PROPERTY_HEALERS_KIT:
            return ItemPropertyHealersKit( nCostValue );

        case ITEM_PROPERTY_HOLY_AVENGER:
            return ItemPropertyHolyAvenger( );

        case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
            return ItemPropertyDamageImmunity( nSubType, nCostValue );

        case ITEM_PROPERTY_IMMUNITY_MISCELLANEOUS:
            return ItemPropertyImmunityMisc( nSubType );

        case ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL:
            return ItemPropertySpellImmunitySpecific( nCostValue );

        case ITEM_PROPERTY_IMMUNITY_SPELL_SCHOOL:
            return ItemPropertySpellImmunitySchool( nSubType );

        case ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL:
            return ItemPropertyImmunityToSpellLevel( nCostValue );

        case ITEM_PROPERTY_IMPROVED_EVASION:
            return ItemPropertyImprovedEvasion( );

        case ITEM_PROPERTY_KEEN:
            return ItemPropertyKeen( );

        case ITEM_PROPERTY_LIGHT:
            return ItemPropertyLight( nCostValue, nParam1Value );

        case ITEM_PROPERTY_MASSIVE_CRITICALS:
            return ItemPropertyMassiveCritical( nCostValue );

        case ITEM_PROPERTY_MATERIAL:
            return ItemPropertyMaterial( nCostValue );

        case ITEM_PROPERTY_MIGHTY:
            return ItemPropertyMaxRangeStrengthMod( nCostValue );

       //case ITEM_PROPERTY_MIND_BLANK:
       //     return ItemPropertyAbilityBonus( nSubType, nCostValue );

        case ITEM_PROPERTY_MONSTER_DAMAGE:
            return ItemPropertyMonsterDamage( nCostValue );

        case ITEM_PROPERTY_NO_DAMAGE:
            return ItemPropertyNoDamage( );

        case ITEM_PROPERTY_ON_HIT_PROPERTIES:
            return ItemPropertyOnHitProps( nSubType, nCostValue, nParam1Value );

        case ITEM_PROPERTY_ON_MONSTER_HIT:
            return ItemPropertyOnMonsterHitProperties( nSubType, nParam1Value );

        case ITEM_PROPERTY_ONHITCASTSPELL:
            return ItemPropertyOnHitCastSpell( nSubType, nCostValue );

        //case ITEM_PROPERTY_POISON:
        //    return ItemPropertyAbilityBonus( nSubType, nCostValue );

        case ITEM_PROPERTY_QUALITY:
            return ItemPropertyQuality( nCostValue );

        case ITEM_PROPERTY_REGENERATION:
            return ItemPropertyRegeneration( nCostValue );

        case ITEM_PROPERTY_REGENERATION_VAMPIRIC:
            return ItemPropertyVampiricRegeneration( nCostValue );

        case ITEM_PROPERTY_SAVING_THROW_BONUS:
            return ItemPropertyBonusSavingThrowVsX( nSubType, nCostValue );

        case ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC:
            return ItemPropertyBonusSavingThrow( nSubType, nCostValue );

        case ITEM_PROPERTY_SKILL_BONUS:
            return ItemPropertySkillBonus( nSubType, nCostValue );

        case ITEM_PROPERTY_SPECIAL_WALK:
            return ItemPropertySpecialWalk( nSubType );

        case ITEM_PROPERTY_SPELL_RESISTANCE:
            return ItemPropertyBonusSpellResistance( nCostValue );

        case ITEM_PROPERTY_THIEVES_TOOLS:
            return ItemPropertyThievesTools( nCostValue );

        case ITEM_PROPERTY_TRAP:
            return ItemPropertyTrap( nSubType, nCostValue );

        case ITEM_PROPERTY_TRUE_SEEING:
            return ItemPropertyTrueSeeing( );

        case ITEM_PROPERTY_TURN_RESISTANCE:
            return ItemPropertyTurnResistance( nCostValue );

        case ITEM_PROPERTY_UNLIMITED_AMMUNITION:
            return ItemPropertyUnlimitedAmmo( nSubType );

        case ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP:
            return ItemPropertyLimitUseByAlign( nSubType );

        case ITEM_PROPERTY_USE_LIMITATION_CLASS:
            return ItemPropertyLimitUseByClass( nSubType );

        case ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE:
            return ItemPropertyLimitUseByRace( nSubType );

        case ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT:
            return ItemPropertyLimitUseBySAlign( nSubType );

        //case ITEM_PROPERTY_USE_LIMITATION_TILESET:
        //    return ItemPropertyAbilityBonus( nSubType, nCostValue );

        case ITEM_PROPERTY_WEIGHT_INCREASE:
            return ItemPropertyWeightIncrease( nCostValue );

        case ITEM_PROPERTY_VISUALEFFECT:
            return ItemPropertyVisualEffect( nSubType );
        default:break;
    }
    return ItemPropertyInvalid( );
}

itemproperty ItemPropertyInvalid( ){

    itemproperty IP = GetFirstItemProperty( OBJECT_SELF );
    while( GetIsItemPropertyValid( IP ) ){
        IP = GetNextItemProperty( OBJECT_SELF );
    }
    return IP;
}

string Catch2DAString( string s2DA, string sColumn, int nRow ){

    object oMod = GetModule( );

    string sCatch   = s2DA + "_" + sColumn + "_" + IntToString( nRow );
    string sRec     = GetLocalString( oMod, sCatch );
    if( sRec == "!@#$%&{[]}\???" )
        return "";
    else if( sRec == "" ){

        sRec = Get2DAString( s2DA, sColumn, nRow );
        if( sRec == "" ){
            SetLocalString( oMod, sCatch, "!@#$%&{[]}\???" );
            return "";
        }
        SetLocalString( oMod, sCatch, sRec );
        return sRec;
    }

    return sRec;
}

string CatchStringByStrRef( int nStrRef, int nGender = GENDER_BOTH ){

    object oMod = GetModule( );

    string sCatch   = IntToString( GENDER_BOTH ) + "_catchstringref_" + IntToString( nStrRef );
    string sRec     = GetLocalString( oMod, sCatch );
    if( sRec == "!@#$%&{[]}\???" )
        return "";
    else if( sRec == "" ){

        sRec = GetStringByStrRef( nStrRef, nGender );
        if( sRec == "" ){
            SetLocalString( oMod, sCatch, "!@#$%&{[]}\???" );
            return "";
        }
        SetLocalString( oMod, sCatch, sRec );
        return sRec;
    }

    return sRec;
}

string GetItemPropertyString( itemproperty IP ){

    int nType = GetItemPropertyType( IP );
    string sName = CatchStringByStrRef( StringToInt( Get2DAString( "ItemPropDef", "Name", nType ) ), GENDER_BOTH );
    string sSub = Catch2DAString( "ItemPropDef", "SubTypeResRef", nType );
    int nData;
    string sSep = ": ";

    if( sSub != "" ){

        nData = StringToInt( Catch2DAString( sSub, "Name", GetItemPropertySubType( IP ) ) );
        if( nData > 0 ){
            sName = sName + sSep + CatchStringByStrRef( nData, GENDER_BOTH );
            sSep = " ";
        }
    }

    sSub = Catch2DAString( "iprp_costtable", "Name", GetItemPropertyCostTable( IP ) );

    if( sSub != "" ){

        nData = StringToInt( Catch2DAString( sSub, "Name", GetItemPropertyCostTableValue( IP ) ) );
        if( nData > 0 )
            sName = sName + sSep + CatchStringByStrRef( nData, GENDER_BOTH );
    }

    int nParm = GetItemPropertyParam1( IP );

    if( nParm < 0 ){
        sSub = Get2DAString( "ItemPropDef", "Param1ResRef", nType );
        if( sSub != "" )
            nParm = StringToInt( sSub );
        else
            nParm = StringToInt( Catch2DAString( Catch2DAString( "ItemPropDef", "SubTypeResRef", nType ), "Param1ResRef", GetItemPropertySubType( IP ) ) );
    }

    sSub = Catch2DAString( "iprp_paramtable", "TableResRef", nParm );

    if( sSub != "" ){

        nData = StringToInt( Catch2DAString( sSub, "Name", GetItemPropertyParam1Value( IP ) ) );
        if( nData > 0 )
            sName = sName + sSep + CatchStringByStrRef( nData, GENDER_BOTH );
    }

    return sName;
}

object GetTargetedOrEquippedWeaponForSpell(int nSpell, int nType=0)
{
    object oTarget  =  GetSpellTargetObject();
    if(GetObjectType(oTarget)== OBJECT_TYPE_CREATURE)
    {
        object oRightHand   = GetItemInSlotForSpell(INVENTORY_SLOT_RIGHTHAND, nSpell, oTarget, nType);
        object oLeftHand    = GetItemInSlotForSpell(INVENTORY_SLOT_LEFTHAND, nSpell, oTarget, nType);
        object oBite        = GetItemInSlotForSpell(INVENTORY_SLOT_CWEAPON_B, nSpell, oTarget, nType);
        object oArms        = GetItemInSlotForSpell(INVENTORY_SLOT_ARMS, nSpell, oTarget, nType);
        if (GetIsObjectValid(oRightHand)) return oRightHand;
        if (GetIsPC(oTarget) && GetIsObjectValid(oLeftHand))  return oLeftHand;
        if (GetIsPC(oTarget) && GetIsObjectValid(oArms)) return oArms;
        if (GetIsObjectValid(oBite))      return oBite;
    }
    if( (nType != 2 && IPGetIsMeleeWeapon(oTarget))
        || (nType != 1 && IPGetIsRangedWeapon(oTarget)))
       return oTarget;
    return IPGetTargetedOrEquippedMeleeWeapon();
}

object GetTargetedOrEquippedArmorForSpell( int nSpell )
{
    object oTarget  =  GetSpellTargetObject();
    if(GetObjectType(oTarget)== OBJECT_TYPE_CREATURE)
    {
        object oChest    = GetItemInSlotForSpell(INVENTORY_SLOT_CHEST, nSpell, oTarget, 3);
        object oLeftHand = GetItemInSlotForSpell(INVENTORY_SLOT_LEFTHAND, nSpell, oTarget, 3);
        if (GetIsObjectValid(oChest)) return oChest;
        if (GetIsPC(oTarget) && GetIsObjectValid(oLeftHand))  return oLeftHand;
    }
    int nBase = GetBaseItemType(oTarget);
    if(nBase == BASE_ITEM_ARMOR || nBase == BASE_ITEM_LARGESHIELD
                || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_SMALLSHIELD
                || nBase == BASE_ITEM_TOWERSHIELD)
       return oTarget;
    return IPGetTargetedOrEquippedArmor();
}


object GetItemInSlotForSpell ( int nInventorySlot, int nSpell, object oCreature=OBJECT_SELF, int nType = 0)
{
    object oItem = GetItemInSlot(nInventorySlot, oCreature);
    if (GetIsObjectValid(oItem) && !GetHasSpellEffect(nSpell,oItem))
    {
        // - nType: 0 All Weapons, 1 melee weapon only, 2 ranged weapon only, 3 Armor.
        int nBase = GetBaseItemType(oItem);
        //SendMessageToPC(GetFirstPC(), IntToString(nBase));
        if (nType == 3)
        {
            if (nBase == BASE_ITEM_ARMOR || nBase == BASE_ITEM_LARGESHIELD
                || nBase == BASE_ITEM_LARGESHIELD || nBase == BASE_ITEM_SMALLSHIELD
                || nBase == BASE_ITEM_TOWERSHIELD) return oItem;
        }
        else if ( (nType != 1 && IPGetIsRangedWeapon(oItem)) ||
                  (nType != 2 && (IPGetIsMeleeWeapon(oItem)  ||
                             nBase == BASE_ITEM_CSLSHPRCWEAP ||
                             nBase == BASE_ITEM_CPIERCWEAPON ||
                             nBase == BASE_ITEM_CBLUDGWEAPON ||
                             nBase == BASE_ITEM_CSLASHWEAPON ||
                             nBase == BASE_ITEM_GLOVES)))
        {
            return oItem;
        }
    }
    return OBJECT_INVALID;
}
