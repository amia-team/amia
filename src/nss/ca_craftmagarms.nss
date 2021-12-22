// Custom Feat:  Craft Magical Arms
//
// This script takes the options from the conversation and i_craftmagarms script
// and crafts them onto the weapon, taking the gold.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 05/09/2012 Mathias          Initial Release.
//
#include "NW_I0_PLOT"
#include "x2_inc_itemprop"

void CraftMagicArms( object oPC, object oWeapon, int nEnchant, int nKeen, int nDmgBonus, int nDmgType, int nCost ) {

    // Variables.
    itemproperty    ipLoop  = GetFirstItemProperty( oWeapon );
    effect          eVFX    = EffectVisualEffect( VFX_FNF_ELECTRIC_EXPLOSION );

    // Check to make sure PC has enough gold.
    if( !HasGold( nCost, oPC ) ) {

        SendMessageToPC( oPC, "Insufficient gold to complete crafting this weapon." );
        return;

    // Otherwise, take the gold from the PC.
    } else {

        TakeGoldFromCreature( nCost, oPC, TRUE );
    }

    // Cycle through item properties and remove damage bonus if it's already there.
    while ( GetIsItemPropertyValid( ipLoop ) ) {

        //If ipLoop is a true seeing property, remove it
        if ( GetItemPropertyType( ipLoop ) == ITEM_PROPERTY_DAMAGE_BONUS ) {

            RemoveItemProperty( oWeapon, ipLoop );
        }
        ipLoop=GetNextItemProperty( oWeapon );
    }

    // Craft the new properties onto the weapon.
    IPSetWeaponEnhancementBonus( oWeapon, nEnchant );
    IPSafeAddItemProperty( oWeapon, ItemPropertyDamageBonus( nDmgType, nDmgBonus ) );
    if ( nKeen ) { IPSafeAddItemProperty( oWeapon, ItemPropertyKeen( ) ); }

    // Trigger the VFX.
    ApplyEffectToObject( DURATION_TYPE_INSTANT, eVFX, oPC );
}

void main( ) {
    object  oPC         = OBJECT_SELF;
    int     iNode       = GetLocalInt( oPC, "ds_node" );
    int     nEnchant    = GetLocalInt( oPC, "cma_enchant_level" );
    int     nDmgBonus   = GetLocalInt( oPC, "cma_damage_bonus" );
    int     nKeen       = GetLocalInt( oPC, "cma_keen" );
    int     nCost       = GetLocalInt( oPC, "cma_cost" );
    object  oWeapon     = GetLocalObject( oPC, "cma_weapon" );
    int     nDmgType;

    // Find which form was chosen from the conversation.
    switch( iNode ) {
        case 1:
            nDmgType  = IP_CONST_DAMAGETYPE_ACID;
        break;

        case 2:
            nDmgType  = IP_CONST_DAMAGETYPE_COLD;
        break;

        case 3:
            nDmgType  = IP_CONST_DAMAGETYPE_ELECTRICAL;
        break;

        case 4:
            nDmgType  = IP_CONST_DAMAGETYPE_FIRE;
        break;

        case 5:
            nDmgType  = IP_CONST_DAMAGETYPE_SONIC;
        break;

    }

    // Clean up local variables
    DeleteLocalInt( oPC, "ds_node" );
    DeleteLocalInt( oPC, "cma_enchant_level" );
    DeleteLocalInt( oPC, "cma_damage_bonus" );
    DeleteLocalInt( oPC, "cma_keen" );
    DeleteLocalInt( oPC, "cma_cost" );
    DeleteLocalObject( oPC, "cma_weapon" );

    // Call the main function.
    CraftMagicArms( oPC, oWeapon, nEnchant, nKeen, nDmgBonus, nDmgType, nCost );
}


