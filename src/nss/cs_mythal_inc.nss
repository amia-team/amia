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
    ----------------------------------------------------------------------------

*/

/* Includes. */
#include "x2_inc_itemprop"

/* Constants. */

// Global.
const int MYTHAL_MAX_POWERS_CAT1        = 3;
const int MYTHAL_MAX_POWERS_CAT2        = 4;
const int MYTHAL_MAX_POWERS_CAT3        = 2;

const string BIOWARE_COST_TABLE         = "iprp_costtable";
const string BIOWARE_COLUMN_NAME        = "Name";
const string BIOWARE_COLUMN_LABEL       = "Label";

// General.
const string MYTHAL_POWER_LIMIT         = "cs_mythal_power_limit";
const string MYTHAL_CURRENT_NO_POWER    = "cs_mythal_current_no_powers";
const string MYTHAL_REAGENT             = "cs_mythal_reagent";
const string MYTHAL_ITEM                = "cs_mythal_item";
const string MYTHAL_POWER               = "cs_mythal_power";
const string MYTHAL_FORGE               = "cs_plc_mforge";
const string MYTHAL_NEWNAME             = "cs_mythal_newname";
const string MYTHAL_CONVO               = "mythal";
const string MYTHAL_ITEM_POWER_TNO      = "cs_mythal_item_power_total_number";
const string MYTHAL_ITEM_POWER_CNO      = "cs_mythal_item_power_current_number";

const string MYTHAL_ITEM_ORIG_POW_COUNT = "cs_mythal_item_original_power_count";

// Switches.
const int MYTHAL_SHOW_MIGHTY_WARNING    = TRUE;

// Listening Pattern.
const int MYTHAL_DIALOG_PATTERN         = 114;

// Conversation Tokens.
const int MYTHAL_TOKEN_COST             = 9999;
const int MYTHAL_TOKEN_DC               = 9998;

const int MYTHAL_TOKEN_REAGENT          = 10000;
const int MYTHAL_TOKEN_ITEM             = 10001;
const int MYTHAL_TOKEN_MYTHAL_POWER     = 10002;

const int MYTHAL_TOKEN_ITEM_NEWNAME     = 10099;
const int MYTHAL_TOKEN_MYTHAL_ENHANCE   = 10098;
const int MYTHAL_TOKEN_MYTHAL_AB        = 10097;
const int MYTHAL_TOKEN_MYTHAL_VREGEN    = 10096;
const int MYTHAL_TOKEN_MYTHAL_MIGHTY    = 10095;
const int MYTHAL_TOKEN_MYTHAL_MCRITICAL = 10094;
const int MYTHAL_TOKEN_MYTHAL_ELED      = 10093;
const int MYTHAL_TOKEN_MYTHAL_SKILL     = 10092;
const int MYTHAL_TOKEN_MYTHAL_REGEN     = 10091;
const int MYTHAL_TOKEN_MYTHAL_AC        = 10090;
const int MYTHAL_TOKEN_MYTHAL_ABILITY   = 10089;
const int MYTHAL_TOKEN_MYTHAL_SAVING    = 10088;
const int MYTHAL_TOKEN_MYTHAL_POWERNO   = 10087;
const int MYTHAL_TOKEN_MYTHAL_DMGREDUC  = 10086;

// Crafting DCs.
const int MYTHAL_DC_PERSONALIZE         = 20;
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

const int MYTHAL_DC_UAMMO_COLD_ARROWS   = 30;
const int MYTHAL_DC_UAMMO_FIRE_ARROWS   = 30;
const int MYTHAL_DC_UAMMO_ZAP_ARROWS    = 30;
const int MYTHAL_DC_UAMMO_ENC5_ARROWS   = 30;

const int MYTHAL_DC_MIGHTY_1            = 8;
const int MYTHAL_DC_MIGHTY_2            = 14;
const int MYTHAL_DC_MIGHTY_3            = 20;
const int MYTHAL_DC_MIGHTY_4            = 26;
const int MYTHAL_DC_MIGHTY_5            = 32;

const int MYTHAL_DC_VFX_ACID            = 24;
const int MYTHAL_DC_VFX_COLD            = 24;
const int MYTHAL_DC_VFX_FIRE            = 24;
const int MYTHAL_DC_VFX_HOLY            = 24;
const int MYTHAL_DC_VFX_LIGHTNING       = 24;
const int MYTHAL_DC_VFX_SONIC           = 24;
const int MYTHAL_DC_VFX_UNHOLY          = 24;

const int MYTHAL_DC_MCRITICAL_1         = 8;
const int MYTHAL_DC_MCRITICAL_2         = 16;
const int MYTHAL_DC_MCRITICAL_3         = 24;
const int MYTHAL_DC_MCRITICAL_4         = 32;

const int MYTHAL_DC_ELED_ACID_1D        = 10;
const int MYTHAL_DC_ELED_ACID_1D4       = 20;
const int MYTHAL_DC_ELED_ACID_1D6       = 30;

const int MYTHAL_DC_ELED_COLD_1D        = 10;
const int MYTHAL_DC_ELED_COLD_1D4       = 20;
const int MYTHAL_DC_ELED_COLD_1D6       = 30;

const int MYTHAL_DC_ELED_FIRE_1D        = 10;
const int MYTHAL_DC_ELED_FIRE_1D4       = 20;
const int MYTHAL_DC_ELED_FIRE_1D6       = 30;

const int MYTHAL_DC_ELED_LIGHTNING_1D   = 10;
const int MYTHAL_DC_ELED_LIGHTNING_1D4  = 20;
const int MYTHAL_DC_ELED_LIGHTNING_1D6  = 30;

const int MYTHAL_DC_ELED_NEGATIVE_1D    = 10;
const int MYTHAL_DC_ELED_NEGATIVE_1D4   = 20;
const int MYTHAL_DC_ELED_NEGATIVE_1D6   = 30;

const int MYTHAL_DC_ELED_SONIC_1D       = 10;
const int MYTHAL_DC_ELED_SONIC_1D4      = 20;
const int MYTHAL_DC_ELED_SONIC_1D6      = 30;

const int MYTHAL_DC_OHIT_DRAIN_STR      = 24;
const int MYTHAL_DC_OHIT_DRAIN_DEX      = 24;
const int MYTHAL_DC_OHIT_DRAIN_CON      = 24;
const int MYTHAL_DC_OHIT_DRAIN_INT      = 24;
const int MYTHAL_DC_OHIT_DRAIN_WIS      = 24;
const int MYTHAL_DC_OHIT_DRAIN_CHA      = 24;

const int MYTHAL_DC_OHIT_BLINDNESS      = 24;
const int MYTHAL_DC_OHIT_CONFUSION      = 24;
const int MYTHAL_DC_OHIT_DAZE           = 24;
const int MYTHAL_DC_OHIT_DEAFNESS       = 24;

const int MYTHAL_DC_OHIT_DIS_MAGGOTS    = 24;
const int MYTHAL_DC_OHIT_DIS_CACKLES    = 24;
const int MYTHAL_DC_OHIT_DIS_BLISTERS   = 24;
const int MYTHAL_DC_OHIT_DIS_MFIRE      = 24;
const int MYTHAL_DC_OHIT_DIS_SHAKES     = 24;
const int MYTHAL_DC_OHIT_DIS_VMAD       = 24;

const int MYTHAL_DC_OHIT_DOOM           = 24;
const int MYTHAL_DC_OHIT_FEAR           = 24;
const int MYTHAL_DC_OHIT_HOLD           = 24;
const int MYTHAL_DC_OHIT_SILENCE        = 24;
const int MYTHAL_DC_OHIT_SLOW           = 24;
const int MYTHAL_DC_OHIT_STUN           = 24;

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

const int MYTHAL_DC_SAVING_4            = 30;
const int MYTHAL_DC_SAVING_5            = 35;

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
const int MYTHAL_COST_PERSONALIZE       = 5000;
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

const int MYTHAL_COST_UAMMO_COLD_ARROWS = 35000;
const int MYTHAL_COST_UAMMO_FIRE_ARROWS = 35000;
const int MYTHAL_COST_UAMMO_ZAP_ARROWS  = 35000;
const int MYTHAL_COST_UAMMO_ENC5_ARROWS = 35000;

const int MYTHAL_COST_MIGHTY_1          = 500;
const int MYTHAL_COST_MIGHTY_2          = 2000;
const int MYTHAL_COST_MIGHTY_3          = 5000;
const int MYTHAL_COST_MIGHTY_4          = 15000;
const int MYTHAL_COST_MIGHTY_5          = 35000;

const int MYTHAL_COST_VFX_ACID          = 15000;
const int MYTHAL_COST_VFX_COLD          = 15000;
const int MYTHAL_COST_VFX_FIRE          = 15000;
const int MYTHAL_COST_VFX_HOLY          = 15000;
const int MYTHAL_COST_VFX_LIGHTNING     = 15000;
const int MYTHAL_COST_VFX_SONIC         = 15000;
const int MYTHAL_COST_VFX_UNHOLY        = 15000;

const int MYTHAL_COST_MCRITICAL_1       = 500;
const int MYTHAL_COST_MCRITICAL_2       = 2000;
const int MYTHAL_COST_MCRITICAL_3       = 10000;
const int MYTHAL_COST_MCRITICAL_4       = 20000;

const int MYTHAL_COST_ELED_ACID_1D      = 500;
const int MYTHAL_COST_ELED_ACID_1D4     = 5000;
const int MYTHAL_COST_ELED_ACID_1D6     = 20000;

const int MYTHAL_COST_ELED_COLD_1D      = 500;
const int MYTHAL_COST_ELED_COLD_1D4     = 5000;
const int MYTHAL_COST_ELED_COLD_1D6     = 20000;

const int MYTHAL_COST_ELED_FIRE_1D      = 500;
const int MYTHAL_COST_ELED_FIRE_1D4     = 5000;
const int MYTHAL_COST_ELED_FIRE_1D6     = 20000;

const int MYTHAL_COST_ELED_ZAP_1D       = 500;
const int MYTHAL_COST_ELED_ZAP_1D4      = 5000;
const int MYTHAL_COST_ELED_ZAP_1D6      = 20000;

const int MYTHAL_COST_ELED_NEGATIVE_1D  = 500;
const int MYTHAL_COST_ELED_NEGATIVE_1D4 = 5000;
const int MYTHAL_COST_ELED_NEGATIVE_1D6 = 20000;

const int MYTHAL_COST_ELED_SONIC_1D     = 500;
const int MYTHAL_COST_ELED_SONIC_1D4    = 5000;
const int MYTHAL_COST_ELED_SONIC_1D6    = 20000;

const int MYTHAL_COST_OHIT_DRAIN_STR    = 10000;
const int MYTHAL_COST_OHIT_DRAIN_DEX    = 10000;
const int MYTHAL_COST_OHIT_DRAIN_CON    = 10000;
const int MYTHAL_COST_OHIT_DRAIN_INT    = 10000;
const int MYTHAL_COST_OHIT_DRAIN_WIS    = 10000;
const int MYTHAL_COST_OHIT_DRAIN_CHA    = 10000;

const int MYTHAL_COST_OHIT_BLINDNESS    = 10000;
const int MYTHAL_COST_OHIT_CONFUSION    = 10000;
const int MYTHAL_COST_OHIT_DAZE         = 10000;
const int MYTHAL_COST_OHIT_DEAFNESS     = 10000;

const int MYTHAL_COST_OHIT_DIS_MAGGOTS  = 10000;
const int MYTHAL_COST_OHIT_DIS_CACKLES  = 10000;
const int MYTHAL_COST_OHIT_DIS_BLISTERS = 10000;
const int MYTHAL_COST_OHIT_DIS_MFIRE    = 10000;
const int MYTHAL_COST_OHIT_DIS_SHAKES   = 10000;
const int MYTHAL_COST_OHIT_DIS_VMAD     = 10000;

const int MYTHAL_COST_OHIT_DOOM         = 10000;
const int MYTHAL_COST_OHIT_FEAR         = 10000;
const int MYTHAL_COST_OHIT_HOLD         = 10000;
const int MYTHAL_COST_OHIT_SILENCE      = 10000;
const int MYTHAL_COST_OHIT_SLOW         = 10000;
const int MYTHAL_COST_OHIT_STUN         = 10000;

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

const int MYTHAL_COST_SAVING_4          = 10000;
const int MYTHAL_COST_SAVING_5          = 15000;

const int MYTHAL_COST_CSPELL_1          = 3000;
const int MYTHAL_COST_CSPELL_2          = 6000;
const int MYTHAL_COST_CSPELL_3          = 12000;

const int MYTHAL_COST_DR_1              = 4000;
const int MYTHAL_COST_DR_2              = 6000;
const int MYTHAL_COST_DR_3              = 9000;
const int MYTHAL_COST_DR_4              = 13000;
const int MYTHAL_COST_DR_5              = 25000;

const int MYTHAL_COST_DMGRES            = 17000;


/* Prototypes */

// Verifies mythal infusion was successful.
int GetIsMythalInfusionSuccessful( object oPC, object oReagent, int nGoldRequired, int nDC, itemproperty ipItemProp );

// Sets the conversation dialog Cost and DC variables.
void SetMythalDialogCostAndDC( object oItem, int nGPCost, int nDCCost );

// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT1 item properties only.
int GetMythalMaxPropertiesToCraft( object oMythalForge );

// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT2 item properties only.
int GetMythalMaxPropertiesToCraft2( object oMythalForge );

// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT3 item properties only.
int GetMythalMaxPropertiesToCraft3( object oMythalForge );

// Gets the Item Property Descriptor for an Item Property.
string GetMythalItemPropertyDescriptor( itemproperty ipItemProp );

// Gets the Number of Powers Worth of an Item.
int GetMythalItemPowerWorth( object oItem );

// Gets the Actual Power Worth of an Item Power.
int GetMythalActualItemPowerWorth( itemproperty ipItemProp, int nItemPropType, int nItemType );



// Verifies mythal infusion was successful.
int GetIsMythalInfusionSuccessful( object oPC, object oReagent, int nGoldRequired, int nDC, itemproperty ipItemProp ){

    // Variables.
    object oItem        = GetLocalObject( oPC, MYTHAL_ITEM );
    int nMythalPower    = GetLocalInt( oPC, MYTHAL_POWER );

    int nItemType       = GetBaseItemType( oItem );

    int nCraftPowerType = GetItemPropertyType( ipItemProp );
    int nItemCurrPowers = GetMythalItemPowerWorth( oItem );
    int nItemPowerLimit = GetLocalInt( oPC, MYTHAL_POWER_LIMIT );
    int nItemPowerCraft = GetMythalActualItemPowerWorth( ipItemProp, GetItemPropertyType( ipItemProp ), nItemType );

    int nItemPowerOrig  = GetLocalInt( oItem, MYTHAL_ITEM_ORIG_POW_COUNT );

    int nGP             = GetGold( oPC );

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


// Sets the conversation dialog Cost and DC variables.
void SetMythalDialogCostAndDC( object oItem, int nGPCost, int nDCCost ){

    // Scale-able DC.
    int nModifier = 2 * GetMythalItemPowerWorth( oItem );

    // Set the dialog cost.
    SetCustomToken( MYTHAL_TOKEN_COST, IntToString( nGPCost ) );

    // Set the dialog DC.
    SetCustomToken( MYTHAL_TOKEN_DC, IntToString( nDCCost + nModifier ) );

    return;

}


// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT1 item properties only.
int GetMythalMaxPropertiesToCraft( object oMythalForge ){

    // Variables
    object oPC              = GetPCSpeaker( );
    object oItem            = GetLocalObject( oPC, MYTHAL_ITEM );

    int nItemPropCount      = GetMythalItemPowerWorth( oItem );

    // Store the Current Number of Powers.
    SetLocalInt( oPC, MYTHAL_CURRENT_NO_POWER, nItemPropCount );
    // Store the Power Limit for this Item.
    SetLocalInt( oPC, MYTHAL_POWER_LIMIT, MYTHAL_MAX_POWERS_CAT1 );

    // Resolve limit.
    return( nItemPropCount > -1 && nItemPropCount < MYTHAL_MAX_POWERS_CAT1 ? TRUE : FALSE );

}


// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT2 item properties only.
int GetMythalMaxPropertiesToCraft2( object oMythalForge ){

    // Variables
    object oPC              = GetPCSpeaker( );
    object oItem            = GetLocalObject( oPC, MYTHAL_ITEM );

    int nItemPropCount      = GetMythalItemPowerWorth( oItem );

    // Store the Current Number of Powers.
    SetLocalInt( oPC, MYTHAL_CURRENT_NO_POWER, nItemPropCount );
    // Store the Power Limit for this Item.
    SetLocalInt( oPC, MYTHAL_POWER_LIMIT, MYTHAL_MAX_POWERS_CAT2 );

    // Resolve limit.
    return( nItemPropCount > -1 && nItemPropCount < MYTHAL_MAX_POWERS_CAT2 ? TRUE : FALSE );

}


// Enables the Mythal menu options that require 0 to MYTHAL_MAX_POWERS_CAT3 item properties only.
int GetMythalMaxPropertiesToCraft3( object oMythalForge ){

    // Variables
    object oPC              = GetPCSpeaker( );
    object oItem            = GetLocalObject( oPC, MYTHAL_ITEM );

    int nItemPropCount      = GetMythalItemPowerWorth( oItem );

    // Store the Current Number of Powers.
    SetLocalInt( oPC, MYTHAL_CURRENT_NO_POWER, nItemPropCount );
    // Store the Power Limit for this Item.
    SetLocalInt( oPC, MYTHAL_POWER_LIMIT, MYTHAL_MAX_POWERS_CAT3 );

    // Resolve limit.
    return( nItemPropCount > -1 && nItemPropCount < MYTHAL_MAX_POWERS_CAT3 ? TRUE : FALSE );

}


// Gets the Item Property Descriptor for an Item Property.
string GetMythalItemPropertyDescriptor( itemproperty ipItemProp ){

    // Variables.
    int nItemPowerType                  = GetItemPropertyType( ipItemProp );
    int nItemPowerSubType               = GetItemPropertySubType( ipItemProp );

    string szItemPowerSub2DA            = Get2DAString(
                                                        "itempropdef",
                                                        "SubTypeResRef",
                                                        nItemPowerType );

    string szItemPowerDescSub           = Get2DAString(
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


    // Cycle the Item Power's Descriptor and replace underscores with spaces.
    for( nChar_pos = 0; nChar_pos < nItemDesc_length; nChar_pos++ ){

        // If this character is an underscore, replace it with a space.
        if( ( szChar = GetSubString( szItemPowerDesc, nChar_pos, 1 ) ) == "_" )
            szChar = " ";

        szItemPowerDescTrimmed += szChar;

    }

    // Pass the Descripor back.
    return( szItemPowerDescTrimmed + " " + szItemPowerDescSub );

}

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

    // 1. All AC types except Dodge are: +1 - +3 = 1; +4 = 2; 5+ = 3 Powers.
    // 2. Specific Saving Throw Bonus (Fort., Reflex, Will): as above.
    else if(  ( nItemPropType == ITEM_PROPERTY_AC_BONUS                         &&
                nItemType != BASE_ITEM_BOOTS )                                  ||
                nItemPropType == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC      ){

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


    // Dodge AC is: +1 - +4 = 1; 5+ = 2 Powers.
    else if(    nItemPropType == ITEM_PROPERTY_AC_BONUS                         &&
                nItemType == BASE_ITEM_BOOTS                                    ){

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
        if( nItemPropType - 40 == 0 ){
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
