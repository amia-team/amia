/*
    Custom Feat (Full Action OR Instant): Crossbow Sniper
        Prerequisites: Proficiency with chosen Crossbow, Weapon Focus with chosen Crossbow,
                             Base Attack Bonus +1.
        Benefit: Gain 1/2 your Dexterity modifier as bonus damage with a crossbow you have the
                     Weapon Focus feat for.

    Created: January 4th, 2015 - Glim
*/

#include "x2_inc_spellhook"
void CrossbowSniper( object oPC );

void main()
{
    CrossbowSniper( OBJECT_SELF );
}

void CrossbowSniper( object oPC )
{
    int nAbility = GetAbilityModifier( ABILITY_DEXTERITY, oPC );
    float fAbility = IntToFloat( nAbility );
          fAbility = fAbility * 0.5;
    int nMod = FloatToInt( fAbility );
    int nDamage;

    switch( nMod )
    {
        case 1:     nDamage = IP_CONST_DAMAGEBONUS_1;       break;
        case 2:     nDamage = IP_CONST_DAMAGEBONUS_2;       break;
        case 3:     nDamage = IP_CONST_DAMAGEBONUS_3;       break;
        case 4:     nDamage = IP_CONST_DAMAGEBONUS_4;       break;
        case 5:     nDamage = IP_CONST_DAMAGEBONUS_5;       break;
        case 6:     nDamage = IP_CONST_DAMAGEBONUS_6;       break;
        case 7:     nDamage = IP_CONST_DAMAGEBONUS_7;       break;
        case 8:     nDamage = IP_CONST_DAMAGEBONUS_8;       break;
        case 9:     nDamage = IP_CONST_DAMAGEBONUS_9;       break;
        case 10:    nDamage = IP_CONST_DAMAGEBONUS_10;      break;
        default:    nDamage = 0;                            break;
    }

    object oWep = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    int nType = GetBaseItemType( oWep );
    object oBolt = GetItemInSlot( INVENTORY_SLOT_BOLTS );

    if( nType == BASE_ITEM_LIGHTCROSSBOW && GetHasFeat( FEAT_WEAPON_FOCUS_LIGHT_CROSSBOW, oPC ) )
    {
        itemproperty ipMod = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_SLASHING, nDamage );
        IPSafeAddItemProperty( oBolt, ipMod, TurnsToSeconds( 480 ), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    }
    else if( nType == BASE_ITEM_HEAVYCROSSBOW && GetHasFeat( FEAT_WEAPON_FOCUS_HEAVY_CROSSBOW, oPC ) )
    {
        itemproperty ipMod = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_SLASHING, nDamage );
        IPSafeAddItemProperty( oBolt, ipMod, TurnsToSeconds( 480 ), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    }
//For later implimentation of Hand crossbows when they are added to the module
//    else if( nType == BASE_ITEM_HANDCROSSBOW && GetHasFeat( FEAT_WEAPON_FOCUS_HAND_CROSSBOW, oPC ) )
//    {
//        itemproperty ipMod = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_SLASHING, nDamage );
//        IPSafeAddItemProperty( oWep, ipMod, TurnsToSeconds( 480 ), X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
//    }
    else
    {
        SendMessageToPC( oPC, "This feat can only be used with a crossbow equipped." );
    }
}
