// Custom Feat:  Craft Magical Arms
//
// This initial script checks to be sure the object targetted is a job system
// weapon, determines the powers to add to the weapon's material base, then
// starts the conversation to determine elemental damage type.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/09/2012 Mathias          Initial Release.
// 08/09/2020 Maverick00053    Made a new spell verison
// 02/22/2024 Maverick00053    Added in a catch for Craft Wondrous Items Stuff
#include "amia_include"
#include "x2_inc_switches"
#include "inc_td_itemprop"

void ActivateItem( ) {

    // Variables.
    object          oPC             = OBJECT_SELF;
    object          oTarget         = GetSpellTargetObject();
    itemproperty    ipPower         = GetFirstItemProperty( oTarget );
    int             nMaterialFound  = 0;
    string          sMaterial;
    int             nType;
    int             nCount          = 0;
    int             nEnchant;
    int             nDmgBonus;
    int             nKeen;
    int             nCost;
    string          sKeenString;

    // Craft Wondrous Items Catch
    if(GetTag(oTarget)=="cmarequired")
    {
     AssignCommand( oPC, ActionStartConversation( oPC, "c_cmacraft_convo", TRUE, FALSE ) );
     SetLocalObject(oPC,"craftingObject",oTarget);
     return;
    }

    // Check if target object is valid and has item properties
    if( ( !GetIsObjectValid( oTarget ) ) ||
        ( !GetIsItemPropertyValid( ipPower ) ) ||
        ( !IPGetIsMeleeWeapon( oTarget ) ) ) {

        SendMessageToPC( oPC, "This is not a valid object for this feat." );
        return;
    }

    // Cycle through the item's properties.
    while( GetIsItemPropertyValid( ipPower ) ) {

        nType           = GetItemPropertyType( ipPower );

        // When a material is found, record it.
        if( nType == 85 ) {

            nMaterialFound  = 1;
            sMaterial       = GetItemPropertyString( ipPower );
        }

        ipPower = GetNextItemProperty( oTarget );
    }

    // Exit if no material was found.
    if( nMaterialFound == 0 ) {

        SendMessageToPC( oPC, "The material of this weapon could not be determined." );
        return;

    // Otherwise, determine the values based on material.
    } else {

        if          ( ( sMaterial == "Material: Steel" ) || ( sMaterial == "Material: Iron" ) ) {

            nEnchant    = 1;
            nKeen       = 0;
            nDmgBonus   = IP_CONST_DAMAGEBONUS_1d6;
            nCost       = 8000;

        } else if   ( ( sMaterial == "Material: Bronze" ) || ( sMaterial == "Material: Silver" ) ) {

            nEnchant    = 2;
            nKeen       = 0;
            nDmgBonus   = IP_CONST_DAMAGEBONUS_1d6;
            nCost       = 12000;

        } else if   ( ( sMaterial == "Material: Darksteel" ) || ( sMaterial == "Material: Cold Iron" ) || ( sMaterial == "Material: Ironwood" ) ) {

            nEnchant    = 3;
            nKeen       = 1;
            nDmgBonus   = IP_CONST_DAMAGEBONUS_1d6;
            nCost       = 25000;

        } else if   ( ( sMaterial == "Material: Adamantine" ) || ( sMaterial == "Material: Mithral" ) ) {

            nEnchant    = 3;
            nKeen       = 1;
            nDmgBonus   = IP_CONST_DAMAGEBONUS_1d8;
            nCost       = 45000;
        }
    }

    // Notify the PC about the level of enchantment.
    if( nKeen ) { sKeenString = ", Keen"; }
    SendMessageToPC( oPC, sMaterial + " allows +" + IntToString( nEnchant) + sKeenString + ", and 1d" + IntToString( nDmgBonus ) + " elemental damage for a cost of " + IntToString( nCost ) );

    // Store the information on the PC.
    SetLocalInt( oPC, "cma_enchant_level", nEnchant );
    SetLocalInt( oPC, "cma_damage_bonus", nDmgBonus );
    SetLocalInt( oPC, "cma_keen", nKeen );
    SetLocalInt( oPC, "cma_cost", nCost );
    SetLocalObject( oPC, "cma_weapon", oTarget );

    // Start the conversation.
    SetLocalString( oPC, "ds_action", "ca_craftmagarms");
    AssignCommand( oPC, ActionStartConversation( oPC, "c_craftmagarms", TRUE, FALSE ) );
}

void main( )
{
    int nEvent = GetUserDefinedItemEventNumber( );

    switch ( nEvent ) {

        case X2_ITEM_EVENT_ACTIVATE:
            ActivateItem( );
            break;
    }
}


