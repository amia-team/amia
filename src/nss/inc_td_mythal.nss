//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_td_mythal
//description: Hold constants and mythal related functions
//used as: library
//date:    080901
//author:  Terra

/*  Mythal Crafting :: Common functions and constants.

    --------
    Verbatim
    --------
    This script contains the common functions and constants used in the Mythal Crafting System.

    ---------
    Changelog
    ---------
    Date    Name        Reason
    ----------------------------------------------------------------------------
    050806  kfw         Initial Release.
    060206  kfw/Sune    Official costing.
    060206  kfw         Modified the crafting roll as follows:
                            1. Craft Armor      ->  Armor.
                            2. Craft Weapon     ->  Weaponry and Ammo.
                            3. Spellcraft       ->  Items.
    072006  kfw         Modified the Crafting Power Infusion Restrictions in accordance to DM suggestions.
    072106  kfw         Modified the Crafting DC to be scaleable.
    080806  kfw         Removed destroying crystals on a failure.
    081106  kfw         Force unequip to prevent ILR interference.
    081406  kfw         Added original power variable tracking for Discosux.
    082906  kfw         New feature: Malign powers won't count toward total powers.
  20070823  disco       Added deletion of 'org' flag on items
  20080101  selmak      Allowed helmets and shields to be crafted with Craft Armor.
  20080107  selmak      Added a switch to enable/disable the Mighty warning for throwing weapons.
  20080415  selmak      Recosted specific saving throws (Fort/Reflex/Will)
  20080826  disco       Added bugfix made by Selmak
  20080831  disco       Added another bugfix made by Selmak
  20080901  Terra       Epic clean up
  20111028  Selmak      Added containers with Personalise option only.
  20120213  Selmak      Changed power valuation, All AC is 1 power up to +4,
                        2 powers for +5.
  20170902  PoS         Added increased weight property to list of item properties ignored for power limit.
    ----------------------------------------------------------------------------

*/

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_itemprop"
#include "inc_ds_actions"
#include "inc_td_itemprop"


// crafting DCs

const int MYTHAL_DC_PERSONALIZE         = 7;
const int MYTHAL_DC_KEEN                = 34;

const int MYTHAL_DC_ENHANCEMENT_1       = 12;
const int MYTHAL_DC_ENHANCEMENT_2       = 18;
const int MYTHAL_DC_ENHANCEMENT_3       = 24;
const int MYTHAL_DC_ENHANCEMENT_4       = 30;
const int MYTHAL_DC_ENHANCEMENT_5       = 36;

const int MYTHAL_DC_AB_1                = 8;
const int MYTHAL_DC_AB_2                = 14;
const int MYTHAL_DC_AB_3                = 20;
const int MYTHAL_DC_AB_4                = 26;
const int MYTHAL_DC_AB_5                = 32;

const int MYTHAL_DC_VREGEN_1            = 12;
const int MYTHAL_DC_VREGEN_2            = 24;
const int MYTHAL_DC_VREGEN_3            = 36;

const int MYTHAL_DC_UAMMO               = 30;

const int MYTHAL_DC_MIGHTY_1            = 8;
const int MYTHAL_DC_MIGHTY_2            = 14;
const int MYTHAL_DC_MIGHTY_3            = 20;
const int MYTHAL_DC_MIGHTY_4            = 26;
const int MYTHAL_DC_MIGHTY_5            = 32;

const int MYTHAL_DC_VFX                 = 24;

const int MYTHAL_DC_MCRITICAL_1         = 8;
const int MYTHAL_DC_MCRITICAL_2         = 16;
const int MYTHAL_DC_MCRITICAL_3         = 24;
const int MYTHAL_DC_MCRITICAL_4         = 32;

const int MYTHAL_DC_DAMAGE_1D           = 10;
const int MYTHAL_DC_DAMAGE_1D4          = 20;
const int MYTHAL_DC_DAMAGE_1D6          = 30;

const int MYTHAL_DC_OHIT                = 24;

const int MYTHAL_DC_SKILL_1             = 10;
const int MYTHAL_DC_SKILL_2             = 20;
const int MYTHAL_DC_SKILL_3             = 30;

const int MYTHAL_DC_REGEN_1             = 30;

const int MYTHAL_DC_AC_1                = 12;
const int MYTHAL_DC_AC_2                = 18;
const int MYTHAL_DC_AC_3                = 24;
const int MYTHAL_DC_AC_4                = 30;
const int MYTHAL_DC_AC_5                = 36;

const int MYTHAL_DC_SR                  = 26;

const int MYTHAL_DC_BSLOT_1             = 12;
const int MYTHAL_DC_BSLOT_2             = 20;
const int MYTHAL_DC_BSLOT_3             = 28;

const int MYTHAL_DC_ABILITY_1           = 12;
const int MYTHAL_DC_ABILITY_2           = 24;
const int MYTHAL_DC_ABILITY_3           = 36;

const int MYTHAL_DC_SAVING_1            = 10;
const int MYTHAL_DC_SAVING_2            = 20;
const int MYTHAL_DC_SAVING_3            = 30;

const int MYTHAL_DC_UNI_SAVE_1          = 25;
const int MYTHAL_DC_UNI_SAVE_2          = 35;

const int MYTHAL_DC_CSPELL_1            = 10;
const int MYTHAL_DC_CSPELL_2            = 20;
const int MYTHAL_DC_CSPELL_3            = 30;

const int MYTHAL_DC_DR_1                = 8;
const int MYTHAL_DC_DR_2                = 14;
const int MYTHAL_DC_DR_3                = 20;
const int MYTHAL_DC_DR_4                = 26;
const int MYTHAL_DC_DR_5                = 32;

const int MYTHAL_DC_DMGRES              = 24;

// Crafting Costs.
const int MYTHAL_COST_PERSONALIZE       = 1000;
const int MYTHAL_COST_KEEN              = 50000;

const int MYTHAL_COST_ENHANCEMENT_1     = 2000;
const int MYTHAL_COST_ENHANCEMENT_2     = 5000;
const int MYTHAL_COST_ENHANCEMENT_3     = 15000;
const int MYTHAL_COST_ENHANCEMENT_4     = 35000;
const int MYTHAL_COST_ENHANCEMENT_5     = 75000;

const int MYTHAL_COST_AB_1              = 500;
const int MYTHAL_COST_AB_2              = 2000;
const int MYTHAL_COST_AB_3              = 5000;
const int MYTHAL_COST_AB_4              = 15000;
const int MYTHAL_COST_AB_5              = 35000;

const int MYTHAL_COST_VREGEN_1          = 2000;
const int MYTHAL_COST_VREGEN_2          = 15000;
const int MYTHAL_COST_VREGEN_3          = 75000;

const int MYTHAL_COST_UAMMO             = 35000;

const int MYTHAL_COST_MIGHTY_1          = 500;
const int MYTHAL_COST_MIGHTY_2          = 2000;
const int MYTHAL_COST_MIGHTY_3          = 5000;
const int MYTHAL_COST_MIGHTY_4          = 15000;
const int MYTHAL_COST_MIGHTY_5          = 35000;

const int MYTHAL_COST_VFX               = 15000;

const int MYTHAL_COST_MCRITICAL_1       = 500;
const int MYTHAL_COST_MCRITICAL_2       = 2000;
const int MYTHAL_COST_MCRITICAL_3       = 10000;
const int MYTHAL_COST_MCRITICAL_4       = 20000;

const int MYTHAL_COST_DAMAGE_1D         = 500;
const int MYTHAL_COST_DAMAGE_1D4        = 5000;
const int MYTHAL_COST_DAMAGE_1D6        = 20000;

const int MYTHAL_COST_OHIT              = 10000;

const int MYTHAL_COST_SKILL_1           = 500;
const int MYTHAL_COST_SKILL_2           = 2000;
const int MYTHAL_COST_SKILL_3           = 10000;

const int MYTHAL_COST_REGEN_1           = 20000;

const int MYTHAL_COST_AC_1              = 2000;
const int MYTHAL_COST_AC_2              = 5000;
const int MYTHAL_COST_AC_3              = 15000;
const int MYTHAL_COST_AC_4              = 35000;
const int MYTHAL_COST_AC_5              = 75000;

const int MYTHAL_COST_SR                = 8000;

const int MYTHAL_COST_BSLOT_1           = 10000;
const int MYTHAL_COST_BSLOT_2           = 20000;
const int MYTHAL_COST_BSLOT_3           = 30000;

const int MYTHAL_COST_ABILITY_1         = 2000;
const int MYTHAL_COST_ABILITY_2         = 10000;
const int MYTHAL_COST_ABILITY_3         = 30000;

const int MYTHAL_COST_SAVING_1          = 500;
const int MYTHAL_COST_SAVING_2          = 2000;
const int MYTHAL_COST_SAVING_3          = 10000;

const int MYTHAL_COST_UNI_SAVE_1        = 5000;
const int MYTHAL_COST_UNI_SAVE_2        = 15000;

const int MYTHAL_COST_CSPELL_1          = 3000;
const int MYTHAL_COST_CSPELL_2          = 6000;
const int MYTHAL_COST_CSPELL_3          = 12000;

const int MYTHAL_COST_DR_1              = 4000;
const int MYTHAL_COST_DR_2              = 6000;
const int MYTHAL_COST_DR_3              = 9000;
const int MYTHAL_COST_DR_4              = 13000;
const int MYTHAL_COST_DR_5              = 25000;

const int MYTHAL_COST_DMGRES            = 17000;

//Mythal specific
const string MYTHAL_POWER_LIMIT         = "cs_mythal_power_limit";
const string MYTHAL_CURRENT_NO_POWER    = "cs_mythal_current_no_powers";
const string MYTHAL_ITEM_ORIG_POW_COUNT = "cs_mythal_item_original_power_count";
const string MYTHAL_FORGE               = "cs_plc_mforge";
const string MYTHAL_REAGENT             = "cs_mythal_reagent";

const int MYTHAL_MAX_POWERS_CAT1        = 3;
const int MYTHAL_MAX_POWERS_CAT2        = 4;
const int MYTHAL_MAX_POWERS_CAT3        = 2;

const string BIOWARE_COST_TABLE         = "iprp_costtable";
const string BIOWARE_COLUMN_NAME        = "Name";
const string BIOWARE_COLUMN_LABEL       = "Label";

string MYTHAL_2DA_FILE      = "mythal";
string SAVE_TO_USE_VAR_NAME = "myth_save";

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//Returns:
// 0 invalid
// 1 Minor
// 2 Lesser
// 3 Intermediate
// 4 Greater
// 5 Flawless
// 6 Perfect
// 7 Divine
int GetMythalType(object oMythal);

//Returns TRUE if the object is a mythal
int GetIsMythal( object oMythal );

// Returns the mythal type as a string
// EX: "Intermediate"
string GetMythalRegentType( object oMythal );

//Cleans all action varialbes
//Sets ds_check_#
//Sets ds_action
//Sets the custom tookens and the mythal variables
void SetMythalChecks( object oUser , object oItem , object oMythal , object oForge , string sConversation );

// Verifies mythal infusion was successful.
int GetIsMythalInfusionSuccessful( object oPC, object oReagent, int nGoldRequired, int nDC, itemproperty ipItemProp );

// Gets the Number of Powers Worth of an Item.
int GetMythalItemPowerWorth( object oItem );

// Gets the Actual Power Worth of an Item Power.
int GetMythalActualItemPowerWorth( itemproperty ipItemProp, int nItemPropType, int nItemType );

//Selmak addition
//Checks if the item property already exists
int GetItemHasIdenticalProperty( object oItem, itemproperty ipItemPropTest );

//Selmak addition
//Compares item properties
int CompareItemProperties( itemproperty ipExisting, itemproperty ipItemPropTest );

// This macro retrieves the modifier of an Item Power.
string GetMythalItemPowerModifier( itemproperty ipItemProp );

//Returns a item property with the correct parameters from the dialogue
itemproperty GetItemPropertyFromNode( int iNode , object oPC );

// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT1 item properties only.
int GetMythalMaxPropertiesToCraft( object oPC );

// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT2 item properties only.
int GetMythalMaxPropertiesToCraft2( object oPC );

// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT3 item properties only.
int GetMythalMaxPropertiesToCraft3( object oPC );

// Gets the Item Property Descriptor for an Item Property.
string GetMythalItemPropertyDescriptor( itemproperty ipItemProp );

// Returns true if oWeapon is a two handed weapon
int GetIsTwoHander( object oWeapon );

//------------------------------------------------------------------------------
// functions
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
int GetMythalType(object oMythal)
{
string  sResRef = GetResRef( oMythal );
string  sMythal = GetSubString( sResRef , 0, 6 );
if( sMythal == "mythal" )sMythal = GetSubString( sResRef , 6, 1 );
else return 0;

return StringToInt( sMythal );
}
//------------------------------------------------------------------------------
string GetMythalRegentType( object oMythal )
{
if( !GetIsMythal( oMythal) )return "";

string sName       = GetName( oMythal );
int iStart         = FindSubString(sName, ", " )+2;
return GetSubString(sName, iStart , GetStringLength( sName )-iStart );
}
//------------------------------------------------------------------------------
int GetIsMythal( object oMythal )
{
string  sMythal = GetSubString( GetResRef( oMythal ) , 0, 6 );

if( sMythal == "mythal" )return TRUE;

return FALSE;
}
//------------------------------------------------------------------------------
void SetMythalChecks( object oUser , object oItem , object oMythal , object oForge , string sConversation )
{
    //CLEAN!
    clean_vars( oUser , 4 );
    DeleteLocalInt( oUser, SAVE_TO_USE_VAR_NAME );
    DeleteLocalInt( oUser, "myth_choise" );
    DeleteLocalInt( oUser, "myth_type" );
    DeleteLocalInt( oUser, "myth_type_2" );
    DeleteLocalInt( oUser, "myth_cost");
    DeleteLocalInt( oUser, "myth_dc");
    DeleteLocalInt( oUser, "myth_node" );

    SetLocalObject( oUser, "myth_regent", oMythal );
    SetLocalObject( oUser, "myth_target", oItem );

    int iLoop = 1;

    do{
    DeleteLocalInt( oUser, "myth_"+IntToString(iLoop) );
    iLoop++;
    }while(iLoop <= 30);

    int iMythalType = GetMythalType( oMythal );
    int i2DA        = 0;
    int nItemType   = GetBaseItemType( oItem );
    int iSkillToUse = SKILL_SPELLCRAFT;

    string sType    = "";

    if( IPGetIsMeleeWeapon( oItem )
    &&  nItemType != BASE_ITEM_ARROW
    &&  nItemType != BASE_ITEM_BOLT
    &&  nItemType != BASE_ITEM_BULLET
    &&  nItemType != BASE_ITEM_SHURIKEN
    &&  nItemType != BASE_ITEM_DART
    &&  nItemType != BASE_ITEM_THROWINGAXE )
    {
    iSkillToUse = SKILL_CRAFT_WEAPON;

    GetMythalMaxPropertiesToCraft2( oUser );

    sType = "this melee weapon";

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Ability" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_1", 1 );
    SetLocalInt( oUser , "myth_1", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "AB" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_2", 1 );
    SetLocalInt( oUser , "myth_2", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Damage" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_4", 1 );
    SetLocalInt( oUser , "myth_4", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Enchantment" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_5", 1 );
    SetLocalInt( oUser , "myth_5", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Keen" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_6", 1 );
    SetLocalInt( oUser , "myth_6", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "MassCrit" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_7", 1 );
    SetLocalInt( oUser , "myth_7", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Onhit" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_8", 1 );
    SetLocalInt( oUser , "myth_8", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Rename" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_9", 1 );
    SetLocalInt( oUser , "myth_9", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "VampReg" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_10", 1 );
    SetLocalInt( oUser , "myth_10", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Visual" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_11", 1 );
    SetLocalInt( oUser , "myth_11", i2DA );
    }

    }

    if( IPGetIsRangedWeapon( oItem )
    &&  nItemType != BASE_ITEM_ARROW
    &&  nItemType != BASE_ITEM_BOLT
    &&  nItemType != BASE_ITEM_BULLET
    &&  nItemType != BASE_ITEM_SHURIKEN
    &&  nItemType != BASE_ITEM_DART
    &&  nItemType != BASE_ITEM_THROWINGAXE )
    {
    GetMythalMaxPropertiesToCraft2( oUser );
    iSkillToUse = SKILL_CRAFT_WEAPON;

    sType = "this ranged weapon";

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Ability" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_1", 1 );
    SetLocalInt( oUser , "myth_1", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "AB" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_2", 1 );
    SetLocalInt( oUser , "myth_2", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Mighty" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_12", 1 );
    SetLocalInt( oUser , "myth_12", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "MassCrit" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_7", 1 );
    SetLocalInt( oUser , "myth_7", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Rename" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_9", 1 );
    SetLocalInt( oUser , "myth_9", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "UnlimitedAmmo" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_13", 1 );
    SetLocalInt( oUser , "myth_13", i2DA );
    }

    }

    if( nItemType == BASE_ITEM_SHURIKEN
    ||  nItemType == BASE_ITEM_DART
    ||  nItemType == BASE_ITEM_THROWINGAXE )
    {
    sType = "this throwing weapon";
    GetMythalMaxPropertiesToCraft2( oUser );
    iSkillToUse = SKILL_CRAFT_WEAPON;

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "AB" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_2", 1 );
    SetLocalInt( oUser , "myth_2", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Damage" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_4", 1 );
    SetLocalInt( oUser , "myth_4", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Enchantment" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_5", 1 );
    SetLocalInt( oUser , "myth_5", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Mighty" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_12", 1 );
    SetLocalInt( oUser , "myth_12", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "MassCrit" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_7", 1 );
    SetLocalInt( oUser , "myth_7", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Onhit" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_8", 1 );
    SetLocalInt( oUser , "myth_8", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Rename" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_9", 1 );
    SetLocalInt( oUser , "myth_9", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "VampReg" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_10", 1 );
    SetLocalInt( oUser , "myth_10", i2DA );
    }


    }

    if( nItemType == BASE_ITEM_ARROW
    ||  nItemType == BASE_ITEM_BOLT
    ||  nItemType == BASE_ITEM_BULLET )
    {
    GetMythalMaxPropertiesToCraft3( oUser );
    iSkillToUse = SKILL_CRAFT_WEAPON;
    sType = "this ammo";
    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Damage" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_4", 1 );
    SetLocalInt( oUser , "myth_4", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Onhit" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_8", 1 );
    SetLocalInt( oUser , "myth_8", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Rename" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_9", 1 );
    SetLocalInt( oUser , "myth_9", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "VampReg" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_10", 1 );
    SetLocalInt( oUser , "myth_10", i2DA );
    }

    }

    if( nItemType == BASE_ITEM_AMULET
    ||  nItemType == BASE_ITEM_ARMOR
    ||  nItemType == BASE_ITEM_BELT
    ||  nItemType == BASE_ITEM_BOOTS
    ||  nItemType == BASE_ITEM_CLOAK
    ||  nItemType == BASE_ITEM_HELMET
    ||  nItemType == BASE_ITEM_RING
    ||  nItemType == BASE_ITEM_SMALLSHIELD
    ||  nItemType == BASE_ITEM_LARGESHIELD
    ||  nItemType == BASE_ITEM_TOWERSHIELD
    ||  nItemType == BASE_ITEM_BRACER)
    {

    switch( nItemType )
    {
    case BASE_ITEM_AMULET:      iSkillToUse = SKILL_SPELLCRAFT;sType = "this amulet";
    GetMythalMaxPropertiesToCraft( oUser );break;
    case BASE_ITEM_ARMOR:       iSkillToUse = SKILL_CRAFT_ARMOR;sType = "this armor";
    GetMythalMaxPropertiesToCraft2( oUser );break;
    case BASE_ITEM_BELT:        iSkillToUse = SKILL_SPELLCRAFT;sType = "this belt";
    GetMythalMaxPropertiesToCraft( oUser );break;
    case BASE_ITEM_BOOTS:       iSkillToUse = SKILL_SPELLCRAFT;sType = "these boots";
    GetMythalMaxPropertiesToCraft( oUser );break;
    case BASE_ITEM_CLOAK:       iSkillToUse = SKILL_SPELLCRAFT;sType = "this cloak";
    GetMythalMaxPropertiesToCraft( oUser );break;
    case BASE_ITEM_HELMET:      iSkillToUse = SKILL_CRAFT_ARMOR;sType = "this helmet";
    GetMythalMaxPropertiesToCraft( oUser );break;
    case BASE_ITEM_RING:        iSkillToUse = SKILL_SPELLCRAFT;sType = "this ring";
    GetMythalMaxPropertiesToCraft( oUser );break;
    case BASE_ITEM_SMALLSHIELD: iSkillToUse = SKILL_CRAFT_ARMOR;sType = "this small shield";
    GetMythalMaxPropertiesToCraft( oUser );break;
    case BASE_ITEM_LARGESHIELD: iSkillToUse = SKILL_CRAFT_ARMOR;sType = "this large shield";
    GetMythalMaxPropertiesToCraft( oUser );break;
    case BASE_ITEM_TOWERSHIELD: iSkillToUse = SKILL_CRAFT_ARMOR;sType = "this tower shield";
    GetMythalMaxPropertiesToCraft( oUser );break;
    case BASE_ITEM_BRACER:      iSkillToUse = SKILL_SPELLCRAFT;sType = "these bracers";
    GetMythalMaxPropertiesToCraft2( oUser );break;
    default:break;
    }

    SetLocalInt(oUser , SAVE_TO_USE_VAR_NAME , iSkillToUse );

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Ability" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_1", 1 );
    SetLocalInt( oUser , "myth_1", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "AC" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_3", 1 );
    SetLocalInt( oUser , "myth_3", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Rename" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_9", 1 );
    SetLocalInt( oUser , "myth_9", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "BonusSpellSlot" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_14", 1 );
    SetLocalInt( oUser , "myth_14", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "DamageReduction" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_15", 1 );
    SetLocalInt( oUser , "myth_15", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "DamageResistance" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_16", 1 );
    SetLocalInt( oUser , "myth_16", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Regeneration" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_20", 1 );
    SetLocalInt( oUser , "myth_20", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "SavingThrowBonus" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_17", 1 );
    SetLocalInt( oUser , "myth_17", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "UniversalSave" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_18", 1 );
    SetLocalInt( oUser , "myth_18", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "SkillBonus" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_21", 1 );
    SetLocalInt( oUser , "myth_21", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "SpellCast" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_22", 1 );
    SetLocalInt( oUser , "myth_22", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "SR20" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_19", 1 );
    SetLocalInt( oUser , "myth_19", i2DA );
    }

    }

    if( nItemType == BASE_ITEM_GLOVES )
    {
    GetMythalMaxPropertiesToCraft2( oUser );
    iSkillToUse = SKILL_SPELLCRAFT;
    sType = "these gloves";

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Ability" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_1", 1 );
    SetLocalInt( oUser , "myth_1", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "AC" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_3", 1 );
    SetLocalInt( oUser , "myth_3", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Rename" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_9", 1 );
    SetLocalInt( oUser , "myth_9", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "BonusSpellSlot" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_14", 1 );
    SetLocalInt( oUser , "myth_14", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "DamageReduction" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_15", 1 );
    SetLocalInt( oUser , "myth_15", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "DamageResistance" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_16", 1 );
    SetLocalInt( oUser , "myth_16", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Regeneration" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_20", 1 );
    SetLocalInt( oUser , "myth_20", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "SavingThrowBonus" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_17", 1 );
    SetLocalInt( oUser , "myth_17", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "UniversalSave" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_18", 1 );
    SetLocalInt( oUser , "myth_18", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "SkillBonus" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_21", 1 );
    SetLocalInt( oUser , "myth_21", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "SpellCast" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_22", 1 );
    SetLocalInt( oUser , "myth_22", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "SR20" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_19", 1 );
    SetLocalInt( oUser , "myth_19", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "AB" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_2", 1 );
    SetLocalInt( oUser , "myth_2", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Damage" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_4", 1 );
    SetLocalInt( oUser , "myth_4", i2DA );
    }

    i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Onhit" , iMythalType ) );
    if( i2DA >= 1 )
    {
    SetLocalInt( oUser , "ds_check_8", 1 );
    SetLocalInt( oUser , "myth_8", i2DA );
    }

    }

    if( nItemType == BASE_ITEM_LARGEBOX )
    {

        GetMythalMaxPropertiesToCraft( oUser );
        sType = "this container";
        i2DA = StringToInt(Get2DAString( MYTHAL_2DA_FILE , "Rename" , iMythalType ) );
        if( i2DA >= 1 ){

            SetLocalInt( oUser , "ds_check_9", 1 );
            SetLocalInt( oUser , "myth_9", i2DA );

        }

    }

SetCustomToken(10101, GetMythalRegentType( oMythal ) );
SetCustomToken(10102, sType);

sType = "";
switch(iSkillToUse)
{
case SKILL_SPELLCRAFT:      sType="Spellcraft";break;
case SKILL_CRAFT_ARMOR:     sType="Craft Armor";break;
case SKILL_CRAFT_WEAPON:    sType="Craft Weapon";break;
default:break;
}

SetCustomToken(10103, sType);

SetLocalInt( oUser, "myth_craft", iSkillToUse);
SetLocalString( oUser, "myth_s_craft", sType);

SetLocalString( oUser , "ds_action" , "td_mythal" );

AssignCommand( oUser, ActionStartConversation( oForge, sConversation, TRUE, FALSE ) );
}

//------------------------------------------------------------------------------

// Verifies mythal infusion was successful.
int GetIsMythalInfusionSuccessful( object oPC, object oReagent, int nGoldRequired, int nDC, itemproperty ipItemProp ){

    // Variables.
    object oItem        = GetLocalObject( oPC, "myth_target" );

    int nMythalPower    = GetMythalType( oReagent );
    int nItemType       = GetBaseItemType( oItem );
    int nCraftPowerType = GetItemPropertyType( ipItemProp );
    int nItemCurrPowers = GetMythalItemPowerWorth( oItem );

    int nItemPowerCraft = GetMythalActualItemPowerWorth( ipItemProp, GetItemPropertyType( ipItemProp ), nItemType );

    int nGP             = GetGold( oPC );

    int nItemPowerOrig  = GetLocalInt( oItem, MYTHAL_ITEM_ORIG_POW_COUNT );
    int nItemPowerLimit = GetLocalInt( oPC, MYTHAL_POWER_LIMIT );
    if ( nItemType == BASE_ITEM_QUARTERSTAFF ||
         nItemType == BASE_ITEM_SHORTSPEAR   ||
         nItemType == BASE_ITEM_GREATAXE     ||
         nItemType == BASE_ITEM_GREATSWORD   ||
         nItemType == BASE_ITEM_HALBERD      ||
         nItemType == BASE_ITEM_HEAVYFLAIL   ||
         nItemType == BASE_ITEM_DIREMACE     ||
         nItemType == BASE_ITEM_DOUBLEAXE    ||
         nItemType == BASE_ITEM_SCYTHE       ||
         nItemType == BASE_ITEM_TWOBLADEDSWORD)
    {
        nItemPowerLimit += 1;
    }

    // Check for matching properties already on the item
    if ( GetItemHasIdenticalProperty( oItem, ipItemProp ) ){

        SendMessageToPC(
                        oPC,
                        "<cÌ  >- Mythal Forge - <cþþþ>Crafting Aborted</c> - <cþ  >"    +
                        " Property already exists on item.</c> -</c>" );

        // Candy.
        AssignCommand( oPC, PlaySound( "sff_spellfail" ) );

        return( FALSE );

    }

    // Scaleable DC.
    nDC = nDC + 2 * nItemCurrPowers;

    /* Based on the Item Type, toggle the appropriate skill to use. */

    // Default to Items [Use Spellcraft skill].
    int nRollType       = SKILL_SPELLCRAFT;
    string szRollType   = "<cþþþ>Spellcraft</c>";
    int nRollModifier   = GetSkillRank( SKILL_SPELLCRAFT, oPC );

    // Armor, Helmets and Shields.
    if(         nItemType == BASE_ITEM_ARMOR        ||
                nItemType == BASE_ITEM_HELMET       ||
                nItemType == BASE_ITEM_TOWERSHIELD  ||
                nItemType == BASE_ITEM_LARGESHIELD  ||
                nItemType == BASE_ITEM_SMALLSHIELD  ){
        nRollType       = SKILL_CRAFT_ARMOR;
        szRollType      = "<cþþþ>Craft Armor</c>";
        nRollModifier   = GetSkillRank( SKILL_CRAFT_ARMOR, oPC );
    }
    // Weaponry AND Ammo.
    else if(    IPGetIsMeleeWeapon( oItem )         ||
                IPGetIsRangedWeapon( oItem )        ||
                nItemType == BASE_ITEM_ARROW        ||
                nItemType == BASE_ITEM_BOLT         ||
                nItemType == BASE_ITEM_BULLET       ||
                nItemType == BASE_ITEM_SHURIKEN     ||
                nItemType == BASE_ITEM_DART         ||
                nItemType == BASE_ITEM_THROWINGAXE  ){
        nRollType       = SKILL_CRAFT_WEAPON;
        szRollType      = "<cþþþ>Craft Weapon</c>";
        nRollModifier   = GetSkillRank( SKILL_CRAFT_WEAPON, oPC );
    }


    // Check gold [ 10 000 GP minimum].
    if( nGP < nGoldRequired ){

        // Notify the player has insufficient gold.
        SendMessageToPC(
                        oPC,
                        "<cÌ&Ì>- Mythal Forge - <cþþþ>Crafting Aborted</c> - <cþ  >"    +
                        IntToString( nGoldRequired )                                    +
                        " gold pieces needed.</c> -</c>" );

        // Candy.
        AssignCommand( oPC, PlaySound( "sff_spellfail" ) );

        return( FALSE );

    }

    // Check Item Power Limit isn't breached (Things like Personalize Weapon are graced.)
    int nItemFinalPowers    = nItemCurrPowers + nItemPowerCraft;
    int nBreachedBy         = abs( nItemFinalPowers - nItemPowerLimit );

    if( nItemFinalPowers > nItemPowerLimit && nCraftPowerType != ITEM_PROPERTY_TRAP && nCraftPowerType != ITEM_PROPERTY_VISUALEFFECT ){

        // Notify the player doesn't have a mythal.
        SendMessageToPC(oPC, "<cÌ&Ì>- Mythal Forge - <cþþþ>Crafting Aborted</c> - <cþ  >You breached the Item's Power Limit by " + IntToString( nBreachedBy ) + " points. Craft a lower Power or remove a Power and try again.</c> -</c>" );

        // Candy.
        AssignCommand( oPC, PlaySound( "sff_spellfail" ) );

        return( FALSE );

    }


    // Check mythal still exists
    if( !GetIsObjectValid( oReagent ) ){

        // Notify the player doesn't have a mythal.
        SendMessageToPC(oPC, "<cÌ&Ì>- Mythal Forge - <cþþþ>Crafting Aborted</c> - <cþ  >You don't have a mythal reagent.</c> -</c>" );

        return( FALSE );

    }

    /* Check roll. */
    int nCraftD20       = d20( );

    int nSuccess = 0;
    string szSuccess = "<cþ  >*Failure*</c>";

    // Natural roll or equalled or exceeded required DC - Success.
    if( nCraftD20 == 20 || ( nCraftD20 + nRollModifier ) >= nDC ){
        // Toggle success.
        nSuccess = 1;
        szSuccess = "<c fþ>*Success*</c>";
    }

    // Notify player of crafting roll.
    SendMessageToPC(
                    oPC,
                    "<cÌ&Ì>- Mythal Forge - <cþþþ>Crafting</c> - "              +
                    szSuccess                                                   +
                    " [ "                                                       +
                    szRollType                                                  +
                    " ] [<cþþþ> D20 = "                                         +
                    IntToString( nCraftD20 )                                    +
                    " + modifier "                                              +
                    IntToString( nRollModifier )                                +
                    " = "                                                       +
                    IntToString( nCraftD20 + nRollModifier )                    +
                    " vs. DC "                                                  +
                    IntToString( nDC )                                          +
                    " </c>] -</c>" );

    // Success.
    if( nSuccess ){

        // Remove the reagent if its not too powerful.
        DestroyObject( oReagent );

        // Remove gold.
        TakeGoldFromCreature( nGoldRequired, oPC, TRUE );

        // Candy
        ApplyEffectToObject(
                            DURATION_TYPE_INSTANT,
                            EffectVisualEffect( VFX_FNF_MYSTICAL_EXPLOSION ),
                            oPC );

        // Store the original power value, if applicable.
        if( nItemPowerOrig == 0 )
            SetLocalInt( oItem, MYTHAL_ITEM_ORIG_POW_COUNT, nItemCurrPowers );

        // Unequip to prevent ILR interfering.
        AssignCommand( oPC, ActionUnequipItem( oItem ) );

        // Ensure character integrity
        ExportSingleCharacter( oPC );

        return( TRUE );

    }

    // Failure.
    else{

        // Remove the reagent if its not too powerful.
        //if( nMythalPower < 5 )
        //    DestroyObject( oReagent );

        // Remove gold.
        TakeGoldFromCreature( nGoldRequired, oPC, TRUE );

        // Candy
        ApplyEffectToObject(
                            DURATION_TYPE_INSTANT,
                            EffectVisualEffect( VFX_FNF_DISPEL_DISJUNCTION ),
                            oPC );

        // Ensure character integrity
        ExportSingleCharacter( oPC );

        return( FALSE );

    }

}
//------------------------------------------------------------------------------
// Gets the Number of Powers Worth of an Item.
int GetMythalItemPowerWorth( object oItem ){

    // Variables.
    int nItemType           = GetBaseItemType( oItem );

    int nItemPropCount      = 0;

    itemproperty ipItemProp = GetFirstItemProperty( oItem );
    int nItemPropType       = GetItemPropertyType( ipItemProp );


    // Cycle item's properties.
    while( GetIsItemPropertyValid( ipItemProp ) ){

        // Tally Power Total.
        nItemPropCount += GetMythalActualItemPowerWorth( ipItemProp, nItemPropType, nItemType );

        // Get next item property.
        ipItemProp          = GetNextItemProperty( oItem );
        nItemPropType       = GetItemPropertyType( ipItemProp );

    }

    return( nItemPropCount );

}
//------------------------------------------------------------------------------
// Gets the Actual Power Worth of an Item Power.
int GetMythalActualItemPowerWorth( itemproperty ipItemProp, int nItemPropType, int nItemType ){

    // Variables.
    int nPowerWorth             = 0;
    int nModifier               = 0;
    string szModifier           = "";

    int nItemPropDur            = GetItemPropertyDurationType( ipItemProp );

    /* Don't count the following power types in, as well as temporary powers:
            1. Temporary Duration.
            2. Light.
            3. Use Limitations.
            4. Visual Effects.
            5. Traps [This is used for things like Personalize Weapon].
            6. Malign powers.                                               */
    if( nItemPropDur  == DURATION_TYPE_TEMPORARY                            ||
        nItemPropType == ITEM_PROPERTY_LIGHT                                ||
        nItemPropType == ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP       ||
        nItemPropType == ITEM_PROPERTY_USE_LIMITATION_CLASS                 ||
        nItemPropType == ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE           ||
        nItemPropType == ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT    ||
        nItemPropType == ITEM_PROPERTY_USE_LIMITATION_TILESET               ||
        nItemPropType == ITEM_PROPERTY_VISUALEFFECT                         ||
        nItemPropType == ITEM_PROPERTY_TRAP                                 ||
        nItemPropType == ITEM_PROPERTY_DAMAGE_VULNERABILITY                 ||
        nItemPropType == ITEM_PROPERTY_DECREASED_ABILITY_SCORE              ||
        nItemPropType == ITEM_PROPERTY_DECREASED_AC                         ||
        nItemPropType == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER            ||
        nItemPropType == ITEM_PROPERTY_DECREASED_DAMAGE                     ||
        nItemPropType == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER       ||
        nItemPropType == ITEM_PROPERTY_DECREASED_SAVING_THROWS              ||
        nItemPropType == ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC     ||
        nItemPropType == ITEM_PROPERTY_QUALITY                              ||
        nItemPropType == ITEM_PROPERTY_MATERIAL                             ||
        nItemPropType == ITEM_PROPERTY_WEIGHT_INCREASE                      ||
        nItemPropType == ITEM_PROPERTY_DECREASED_SKILL_MODIFIER             )

        nPowerWorth = 0;

    /* 1 Power per Modifier:
         1. Ability Bonus.       */
    else if( nItemPropType == ITEM_PROPERTY_ABILITY_BONUS ){

        // Get the Modifier.
        nModifier = StringToInt( GetMythalItemPowerModifier( ipItemProp ) );
        if( nModifier < 1 )
            nModifier = 1;

        // Equate it to Number of Item Powers.
        nPowerWorth = nModifier;

    }

    // Specific Saving Throw Bonus (Fort., Reflex, Will):
    // +1 - +3 = 1; +4 = 2; 5+ = 3 Powers.
    else if( nItemPropType == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC ){

        // Get the Modifier.
        nModifier = StringToInt( GetMythalItemPowerModifier( ipItemProp ) );
        if( nModifier < 1 )
            nModifier = 1;

        // Equate it to Number of Item Powers.
        // +1 - +3, 1 Power.
        if( nModifier > 0 && nModifier <= 3 )
            nPowerWorth = 1;
        // +4, 2 Powers.
        else if( nModifier == 4 )
            nPowerWorth = 2;
        // 5+, 3 Powers.
        else
            nPowerWorth = 3;

    }


    // All AC is: +1 - +4 = 1; 5+ = 2 Powers.
    else if(    nItemPropType == ITEM_PROPERTY_AC_BONUS ){

        // Get the Modifier.
        nModifier = StringToInt( GetMythalItemPowerModifier( ipItemProp ) );
        if( nModifier < 1 )
            nModifier = 1;

        // Equate it to Number of Item Powers.
        // +1 - +4, 1 Power.
        if( nModifier > 0 && nModifier <= 4 )
            nPowerWorth = 1;
        // 5+ Powers.
        else
            nPowerWorth = 2;

    }

    // Damage Resistance: 15/- = 2; 20/- and above = 4 Powers.
    else if( nItemPropType == ITEM_PROPERTY_DAMAGE_RESISTANCE ){

        // Get the Modifier.
        szModifier = GetMythalItemPowerModifier( ipItemProp );
        if( szModifier == "" )
            szModifier = "Resist_5/-";

        // 5/-, 10/- = 1 Power.
        if( szModifier == "Resist_5/-" || szModifier == "Resist_10/-" )
            nPowerWorth = 1;
        // 15/- = 2 Powers.
        else if( szModifier == "Resist_15/-" )
            nPowerWorth = 2;
        // 20/- +  = 4 Powers.
        else
            nPowerWorth = 4;

    }

    // Attack Bonus and Enhancement: +1 to +4 = 1; 5+ = 4 Powers.
    //else if( nItemPropType == ITEM_PROPERTY_ENHANCEMENT_BONUS || nItemPropType == ITEM_PROPERTY_ATTACK_BONUS ){
    else if( nItemPropType == ITEM_PROPERTY_ENHANCEMENT_BONUS ){

        // Get the Modifier.
        nModifier = StringToInt( GetMythalItemPowerModifier( ipItemProp ) );
        if( nModifier < 1 )
            nModifier = 1;

        // +1 to +4 = 1 Power.
        if( nModifier > 0 && nModifier <= 4 )
            nPowerWorth = 1;
        // 5+ = 4 Powers.
        else
            nPowerWorth = 4;

    }

    // Permanent Freedom: 2 Powers.
    else if(    nItemPropType == ITEM_PROPERTY_FREEDOM_OF_MOVEMENT )
        nPowerWorth = 2;

    // Regeneration: 1 + 1 Per Modifier Powers.
    else if(    nItemPropType == ITEM_PROPERTY_REGENERATION ){

        // Get the Modifier.
        nModifier = StringToInt( GetMythalItemPowerModifier( ipItemProp ) );
        if( nModifier < 1 )
            nModifier = 1;

        // 1 + NP Powers.
        nPowerWorth = 1 + nModifier;

    }

    // Universal Saving Throw Bonus: +1 = 1; +2 = 2; +3 = 4;
    else if(    nItemPropType == ITEM_PROPERTY_SAVING_THROW_BONUS ){

        // Get the Modifier.
        nModifier = StringToInt( GetMythalItemPowerModifier( ipItemProp ) );
        if( nModifier < 1 )
            nModifier = 1;

        // Hack, to get the Type, no other way to do it.
        // Universal!
        if( GetItemPropertySubType( ipItemProp ) == 0 ){
            // +1 = 1 Power.
            if( nModifier == 1 )
                nPowerWorth = 1;
            // +2 = 2 Powers.
            else if( nModifier == 2)
                nPowerWorth = 2;
            // 3+ = 4 Powers.
            else
                nPowerWorth = 4;
        }

        // Non-Universal.
        else
            nPowerWorth = 1;

    }

    // Single powers.
    else
        nPowerWorth = 1;


    return( nPowerWorth );

}

//------------------------------------------------------------------------------
int GetItemHasIdenticalProperty( object oItem, itemproperty ipItemPropTest ){

    itemproperty ipItemProp = GetFirstItemProperty( oItem );

    int nReturnValue = FALSE;


    while( GetIsItemPropertyValid( ipItemProp ) ){
        nReturnValue = nReturnValue || CompareItemProperties( ipItemProp, ipItemPropTest );
        ipItemProp = GetNextItemProperty( oItem );
    }

    return nReturnValue;

}
//------------------------------------------------------------------------------
// This macro retrieves the modifier of an Item Power.
string GetMythalItemPowerModifier( itemproperty ipItemProp ){

    // Get the table entry data for the Item Power Type.
    int nTableNumber = GetItemPropertyCostTable( ipItemProp );

    // Get the specified table name.
    string szTableName = Get2DAString( BIOWARE_COST_TABLE, BIOWARE_COLUMN_NAME, nTableNumber );

    // Get the table entry index for the data for the Item Power Type.
    int nTableIndex = GetItemPropertyCostTableValue( ipItemProp );

    // Query the specific data using the table name and its index -> This is the modifier!
    string szModifier = Get2DAString( szTableName, BIOWARE_COLUMN_LABEL, nTableIndex );

    return( szModifier );

}
//------------------------------------------------------------------------------
int CompareItemProperties( itemproperty ipExisting, itemproperty ipItemPropTest ){

    int nReturnValue = TRUE;
    int nValue1, nValue2;

    nValue1 = GetItemPropertyCostTable( ipExisting );
    nValue2 = GetItemPropertyCostTable( ipItemPropTest );
    nReturnValue = nReturnValue && ( nValue1 == nValue2 );

    //WriteTimestampedLogEntry(   "ip Cost Table 1: " + IntToString( nValue1 ) +
    //                            " ip Cost Table 2: " + IntToString( nValue2 ) );

    nValue1 = GetItemPropertyCostTableValue( ipExisting );
    nValue2 = GetItemPropertyCostTableValue( ipItemPropTest );
    nReturnValue = nReturnValue && ( nValue1 == nValue2 );

    //WriteTimestampedLogEntry(   "ip Cost Table Value 1: " + IntToString( nValue1 ) +
    //                            " ip Cost Table Value 2: " + IntToString( nValue2 ) );

    nValue1 = GetItemPropertySubType( ipExisting );
    nValue2 = GetItemPropertySubType( ipItemPropTest );
    nReturnValue = nReturnValue && ( nValue1 == nValue2 );

    //WriteTimestampedLogEntry(   "ip Property Subtype 1: " + IntToString( nValue1 ) +
    //                            " ip Property Subtype 2: " + IntToString( nValue2 ) );

    nValue1 = GetItemPropertyType( ipExisting );
    nValue2 = GetItemPropertyType( ipItemPropTest );
    nReturnValue = nReturnValue && ( nValue1 == nValue2 );

    //WriteTimestampedLogEntry(   "ip Property Type 1: " + IntToString( nValue1 ) +
    //                            " ip Property Type 2: " + IntToString( nValue2 ) );

    //Hack, damage bonus aint supposed to stack
    if( GetItemPropertyType( ipExisting ) == ITEM_PROPERTY_DAMAGE_BONUS
    &&  GetItemPropertyType( ipItemPropTest ) == ITEM_PROPERTY_DAMAGE_BONUS)
    nReturnValue = TRUE;

    //Hack, spellslots is supposed to stack
    if( GetItemPropertyType( ipExisting ) == ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N )
        nReturnValue = FALSE;

    return nReturnValue;

}
//------------------------------------------------------------------------------
itemproperty GetItemPropertyFromNode( int iNode , object oPC )
{
itemproperty IP_Return;

    int iType1 = GetLocalInt( oPC, "myth_type");
    int iType2 = GetLocalInt( oPC, "myth_type_2");

    int i2DA   = GetLocalInt( oPC, "myth_"+IntToString( iNode ) );

    switch( iNode )
    {
    case 1:
    IP_Return = ItemPropertyAbilityBonus(iType1, i2DA );
    break;

    case 2:
    IP_Return = ItemPropertyAttackBonus( i2DA );
    break;

    case 3:
    IP_Return = ItemPropertyACBonus( i2DA );
    break;

    case 4:
    IP_Return = ItemPropertyDamageBonus( iType1 , i2DA );
    break;

    case 5:
    IP_Return = ItemPropertyEnhancementBonus( i2DA );
    break;

    case 6:
    IP_Return = ItemPropertyKeen();
    break;

    case 7:
    IP_Return = ItemPropertyMassiveCritical( i2DA );
    break;

    case 8:
    IP_Return = ItemPropertyOnHitProps( iType1, i2DA, iType2);
    break;

    case 9:
    /*RENAMING*/
    break;

    case 10:
    IP_Return = ItemPropertyVampiricRegeneration( i2DA );
    break;


    case 11:
    IP_Return = ItemPropertyVisualEffect( iType1 );
    break;


    case 12:
    IP_Return = ItemPropertyMaxRangeStrengthMod( i2DA );
    break;


    case 13:
    IP_Return = ItemPropertyUnlimitedAmmo( iType1 );
    break;

    case 14:
    IP_Return = ItemPropertyBonusLevelSpell( iType1, iType2 );
    break;

    case 15:
    IP_Return = ItemPropertyDamageReduction( iType1 , IP_CONST_DAMAGESOAK_5_HP );
    break;

    case 16:
    IP_Return = ItemPropertyDamageResistance( iType1, IP_CONST_DAMAGERESIST_5 );
    break;

    case 17:
    IP_Return = ItemPropertyBonusSavingThrow( iType1, i2DA );
    break;

    case 18:
    IP_Return = ItemPropertyBonusSavingThrowVsX( IP_CONST_SAVEVS_UNIVERSAL, i2DA );
    break;

    case 19:
    IP_Return = ItemPropertyBonusSpellResistance( IP_CONST_SPELLRESISTANCEBONUS_20 );
    break;

    case 20:
    IP_Return = ItemPropertyRegeneration( i2DA );
    break;

    case 21:
    IP_Return = ItemPropertySkillBonus( iType1, i2DA );
    break;

    case 22:
    IP_Return = ItemPropertyCastSpell( iType1, iType2 );
    break;

    default:break;
    }


return IP_Return;

}
//------------------------------------------------------------------------------

// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT1 item properties only.
int GetMythalMaxPropertiesToCraft( object oPC ){

    // Variables
    object oItem            = GetLocalObject( oPC, "myth_target" );

    int nItemPropCount      = GetMythalItemPowerWorth( oItem );

    // Store the Current Number of Powers.
    SetLocalInt( oPC, MYTHAL_CURRENT_NO_POWER, nItemPropCount );
    // Store the Power Limit for this Item.
    SetLocalInt( oPC, MYTHAL_POWER_LIMIT, MYTHAL_MAX_POWERS_CAT1 );

    // Resolve limit.
    return( nItemPropCount > -1 && nItemPropCount < MYTHAL_MAX_POWERS_CAT1 ? TRUE : FALSE );

}

//------------------------------------------------------------------------------

// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT2 item properties only.
int GetMythalMaxPropertiesToCraft2( object oPC ){

    // Variables
    object oItem            = GetLocalObject( oPC, "myth_target" );

    int nItemPropCount      = GetMythalItemPowerWorth( oItem );

    // Store the Current Number of Powers.
    SetLocalInt( oPC, MYTHAL_CURRENT_NO_POWER, nItemPropCount );
    // Store the Power Limit for this Item.
    SetLocalInt( oPC, MYTHAL_POWER_LIMIT, MYTHAL_MAX_POWERS_CAT2 );

    // Resolve limit.
    return( nItemPropCount > -1 && nItemPropCount < MYTHAL_MAX_POWERS_CAT2 ? TRUE : FALSE );

}

//------------------------------------------------------------------------------

// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT3 item properties only.
int GetMythalMaxPropertiesToCraft3( object oPC ){

    // Variables
    object oItem            = GetLocalObject( oPC, "myth_target" );

    int nItemPropCount      = GetMythalItemPowerWorth( oItem );

    // Store the Current Number of Powers.
    SetLocalInt( oPC, MYTHAL_CURRENT_NO_POWER, nItemPropCount );
    // Store the Power Limit for this Item.
    SetLocalInt( oPC, MYTHAL_POWER_LIMIT, MYTHAL_MAX_POWERS_CAT3 );

    // Resolve limit.
    return( nItemPropCount > -1 && nItemPropCount < MYTHAL_MAX_POWERS_CAT3 ? TRUE : FALSE );

}



//------------------------------------------------------------------------------

string GetMythalItemPropertyDescriptor( itemproperty ipItemProp ){

    /*// Variables.
    int nItemPowerType                  = GetItemPropertyType( ipItemProp );
    int nItemPowerSubType               = GetItemPropertySubType( ipItemProp );

    string szItemPowerSub2DA            = Get2DAString(
                                                        "itempropdef",
                                                        "SubTypeResRef",
                                                        nItemPowerType );

    string szItemPowerDescSub           = "";

    if ( ( szItemPowerSub2DA == "IRPP_SAVEELEMENT" ) ||
         ( szItemPowerSub2DA == "IRPP_SAVINGTHROW" ) )


           szItemPowerDescSub           = Get2DAString(
                                                        szItemPowerSub2DA,
                                                        "NameString",
                                                        nItemPowerSubType );

    else   szItemPowerDescSub           = Get2DAString(
                                                        szItemPowerSub2DA,
                                                        "Label",
                                                        nItemPowerSubType );


    string szItemPowerDesc              = Get2DAString(
                                                        "itemprops",
                                                        "Label",
                                                        nItemPowerType );

    string szItemPowerDescTrimmed       = "";

    string szChar                       = "";
    int nChar_pos                       = 0;
    int nItemDesc_length                = GetStringLength( szItemPowerDesc );
    int nModifier                       = 0;


    // Cycle the Item Power's Descriptor and replace underscores with spaces.
    for( nChar_pos = 0; nChar_pos < nItemDesc_length; nChar_pos++ ){

        // If this character is an underscore, replace it with a space.
        if( ( szChar = GetSubString( szItemPowerDesc, nChar_pos, 1 ) ) == "_" )
            szChar = " ";

        szItemPowerDescTrimmed += szChar;

    }

    // If the item property is a Spell slot for a casting class, this check
    // allows the unruly n to be removed and the correct spell level appended.
    nItemDesc_length = GetStringLength( szItemPowerDescTrimmed );

    if ( GetStringRight( szItemPowerDescTrimmed, 7 ) == "Level n" ){

        szItemPowerDescTrimmed  = GetStringLeft( szItemPowerDescTrimmed, nItemDesc_length - 1 );
        nModifier               = GetItemPropertyCostTableValue( ipItemProp );
        szItemPowerDescTrimmed  = szItemPowerDescTrimmed + IntToString( nModifier );
    }

    // Pass the Descripor back.
    return( szItemPowerDescTrimmed + " " + szItemPowerDescSub );*/

    return GetItemPropertyString( ipItemProp );

}
//------------------------------------------------------------------------------
int GetIsTwoHander( object oWeapon ){

    int nType = GetBaseItemType( oWeapon );

    switch ( nType ){
    case BASE_ITEM_DIREMACE:
    case BASE_ITEM_DOUBLEAXE:
    case BASE_ITEM_GREATAXE:
    case BASE_ITEM_GREATSWORD:
    case BASE_ITEM_HALBERD:
    case BASE_ITEM_HEAVYFLAIL:
    case BASE_ITEM_QUARTERSTAFF:
    case BASE_ITEM_SCYTHE:
    case BASE_ITEM_SHORTSPEAR:
//    case BASE_ITEM_TRIDENT: //Tridents aren't 2-handed anymore
    case BASE_ITEM_TWOBLADEDSWORD:
    return TRUE;

    default:return FALSE;
    }
    return FALSE;
}
//------------------------------------------------------------------------------
