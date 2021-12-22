//-------------------------------------------------------------------------------
// Created By: Terra_777
// Filename: inc_td_shifter
//-------------------------------------------------------------------------------

//void main(){}

//-------------------------------------------------------------------------------
//Constants
//-------------------------------------------------------------------------------

//Includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "inc_td_itemprop"
#include "nwnx_effects"

//-------------------------------------------------------------------------------
//Prototypes
//-------------------------------------------------------------------------------

//Merges oPC's old weapon according to the shifter rules
void ShifterMerge( object oPC, object oOldWeapon, object oArmor, object oRing1, object oRing2, object oBoots, object oSheild, object oAmulet, object oCloak, object oHands, object oBelt, object oHelm, int nPolymorph );

//Returns druid + shifter level if oPC is shifted, otherwise it returns the casterlevel
//if nIfoPCIsntShifterUseThisInstead == 0 it'll use GetLegacyCasterLevel
int GetNewCasterLevel( object oPC, int nIfoPCIsntShifterUseThisInstead = 0 );

//Yeah.
int GetShifterDC( object oPC, int nIfoPCIsntShifterUseThisInstead );

//This effect "hooks" the ac modification to eReturn and should not be used in a EffectLinkEffcts
effect EffectGearToAC( effect eReturn, object oPC );

//Gives an ac effect
effect EffectShifterProgressionACEffect( object oPC, effect eEffect );

//Changes an effect to have the shifter skin as effect creator and the appropiate (shifter + druid) CL
effect EffectShifterEffect( effect eEffect, object oPC);

//-------------------------------------------------------------------------------
//Function definitons
//-------------------------------------------------------------------------------

effect EffectShifterProgressionACEffect( object oPC, effect eEffect ){

    int nShifterLevels = GetLevelByClass( CLASS_TYPE_SHIFTER ,oPC );

    SendMessageToPC( oPC, "<c þ >Bonus AC:" );

    int nWisdom = GetAbilityModifier( ABILITY_WISDOM, oPC );
    int nMonkLevel = GetLevelByClass( CLASS_TYPE_MONK, oPC );
    if( GetHasFeat( 260, oPC ) && nWisdom > 0 ){

        if( nWisdom > nMonkLevel ) {
            nWisdom = nMonkLevel;
        }
        SendMessageToPC( oPC, "<c þ >Monk AC: -"+IntToString( nWisdom ) );
        eEffect = EffectLinkEffects( EffectACDecrease( nWisdom, AC_SHIELD_ENCHANTMENT_BONUS ), eEffect );
    }
    if( nShifterLevels >= 17 ){
        SendMessageToPC( oPC, "<c þ >Natural: "+IntToString( 5 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 5, AC_NATURAL_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 13 ){
        SendMessageToPC( oPC, "<c þ >Natural: "+IntToString( 4 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 4, AC_NATURAL_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 9 ){
        SendMessageToPC( oPC, "<c þ >Natural: "+IntToString( 3 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 3, AC_NATURAL_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 5 ){
        SendMessageToPC( oPC, "<c þ >Natural: "+IntToString( 2 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 2, AC_NATURAL_BONUS ), eEffect );
    }
    else{
        SendMessageToPC( oPC, "<c þ >Natural: "+IntToString( 1 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 1, AC_NATURAL_BONUS ), eEffect );
    }

    if( nShifterLevels >= 18 ){
        SendMessageToPC( oPC, "<c þ >Deflection: "+IntToString( 5 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 5, AC_DEFLECTION_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 14 ){
        SendMessageToPC( oPC, "<c þ >Deflection: "+IntToString( 4 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 4, AC_DEFLECTION_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 10 ){
        SendMessageToPC( oPC, "<c þ >Deflection: "+IntToString( 3 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 3, AC_DEFLECTION_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 6 ){
        SendMessageToPC( oPC, "<c þ >Deflection: "+IntToString( 2 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 2, AC_DEFLECTION_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 2 ){
        SendMessageToPC( oPC, "<c þ >Deflection: "+IntToString( 1 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 1, AC_DEFLECTION_BONUS ), eEffect );
    }

    if( nShifterLevels >= 19 ){
        SendMessageToPC( oPC, "<c þ >Dodge: "+IntToString( 5 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 5, AC_DODGE_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 15 ){
        SendMessageToPC( oPC, "<c þ >Dodge: "+IntToString( 4 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 4, AC_DODGE_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 11 ){
        SendMessageToPC( oPC, "<c þ >Dodge: "+IntToString( 3 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 3, AC_DODGE_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 7 ){
        SendMessageToPC( oPC, "<c þ >Dodge: "+IntToString( 2 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 2, AC_DODGE_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 3 ){
        SendMessageToPC( oPC, "<c þ >Dodge: "+IntToString( 1 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 1, AC_DODGE_BONUS ), eEffect );
    }

    if( nShifterLevels >= 20 ){
        SendMessageToPC( oPC, "<c þ >Armor: "+IntToString( 5 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 5, AC_ARMOUR_ENCHANTMENT_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 16 ){
        SendMessageToPC( oPC, "<c þ >Armor: "+IntToString( 4 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 4, AC_ARMOUR_ENCHANTMENT_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 12 ){
        SendMessageToPC( oPC, "<c þ >Armor: "+IntToString( 3 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 3, AC_ARMOUR_ENCHANTMENT_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 8 ){
        SendMessageToPC( oPC, "<c þ >Armor: "+IntToString( 2 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 2, AC_ARMOUR_ENCHANTMENT_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 4 ){
        SendMessageToPC( oPC, "<c þ >Armor: "+IntToString( 1 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 1, AC_ARMOUR_ENCHANTMENT_BONUS ), eEffect );
    }

    if( nShifterLevels >= 15 ){
        SendMessageToPC( oPC, "<c þ >Shield: "+IntToString( 8 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 8, AC_SHIELD_ENCHANTMENT_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 12 ){
        SendMessageToPC( oPC, "<c þ >Shield: "+IntToString( 7 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 7, AC_SHIELD_ENCHANTMENT_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 9 ){
        SendMessageToPC( oPC, "<c þ >Shield: "+IntToString( 6 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 6, AC_SHIELD_ENCHANTMENT_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 6 ){
        SendMessageToPC( oPC, "<c þ >Shield: "+IntToString( 5 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 5, AC_SHIELD_ENCHANTMENT_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 3 ){
        SendMessageToPC( oPC, "<c þ >Shield: "+IntToString( 4 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 4, AC_SHIELD_ENCHANTMENT_BONUS ), eEffect );
    }
    else if( nShifterLevels >= 1 ){
        SendMessageToPC( oPC, "<c þ >Shield: "+IntToString( 3 ) );
        eEffect = EffectLinkEffects( EffectACIncrease( 3, AC_SHIELD_ENCHANTMENT_BONUS ), eEffect );
    }

    return eEffect;
}

effect EffectGearToAC( effect eReturn, object oPC ){

    int nDeflection     = 0;
    int nNatural        = 0;
    int nArmor          = 0;
    int nSheild         = 0;
    int nDodge          = 0;

    int nBaseSheild     = 0;
    int nBaseArmor      = 0;

    int nMonkAC         = GetHasFeat( 260, oPC );
    int nWisdom         = GetAbilityModifier( ABILITY_WISDOM, oPC );
    int nMonkLevel      = GetLevelByClass( CLASS_TYPE_MONK, oPC );

    int nACType         = -1;
    int nACValue        = -1;

    itemproperty IP     = ItemPropertyInvalid( );

    object  oItem;
    int     nSlot;

    for( nSlot = 0; nSlot < NUM_INVENTORY_SLOTS; nSlot++ ){

        oItem = GetItemInSlot( nSlot, oPC );
        if( GetIsObjectValid( oItem ) ){

            nACType = StringToInt( Get2DAString( "baseitems", "AC_Enchant", GetBaseItemType( oItem ) ) );

            if( nSlot == INVENTORY_SLOT_LEFTHAND ){

                switch( GetBaseItemType( oItem ) ){

                    case BASE_ITEM_SMALLSHIELD: nBaseSheild = 1;break;
                    case BASE_ITEM_LARGESHIELD: nBaseSheild = 2;break;
                    case BASE_ITEM_TOWERSHIELD: nBaseSheild = 3;break;
                    default:nACType = 4;break;
                }
            }
            else if( nSlot == INVENTORY_SLOT_CHEST ){

                nBaseArmor  = StringToInt( Get2DAString( "parts_chest", "ACBONUS", GetItemAppearance( oItem, ITEM_APPR_TYPE_ARMOR_MODEL, ITEM_APPR_ARMOR_MODEL_TORSO ) ) );
            }

            IP = GetFirstItemProperty( oItem );
            while( GetIsItemPropertyValid( IP ) ){

                if( GetItemPropertyType( IP ) == ITEM_PROPERTY_AC_BONUS ){

                    nACValue    = GetItemPropertyCostTableValue( IP );

                    if( nACType == 0 && nACValue > nDodge )
                        nDodge = nACValue;
                    else if( nACType == 1 && nACValue > nNatural )
                        nNatural = nACValue;
                    else if( nACType == 2 && nACValue > nArmor )
                        nArmor = nACValue;
                    else if( nACType == 3 && nACValue > nSheild )
                        nSheild = nACValue;
                    else if( nACType == 4 && nACValue > nDeflection )
                        nDeflection = nACValue;

                }

                IP = GetNextItemProperty( oItem );
            }
        }
    }

    nDeflection += nBaseArmor;
    nNatural    += nArmor;
    nSheild     += nBaseSheild;

    SendMessageToPC( oPC, "<c þ >AC Merge: " );

    if( nWisdom > nMonkLevel ) {
        nWisdom = nMonkLevel;
    }

    if( nMonkAC && nWisdom > 0 ){
        eReturn = EffectLinkEffects( EffectACDecrease( nWisdom, AC_SHIELD_ENCHANTMENT_BONUS ), eReturn );
        SendMessageToPC( oPC, "<c þ >Monk AC penalty: "+IntToString( nWisdom ) );
    }

    if( nDeflection > 0 ){

        eReturn = EffectLinkEffects( EffectACIncrease( nDeflection, AC_DEFLECTION_BONUS ), eReturn );
        SendMessageToPC( oPC, "<c þ >Deflection: "+IntToString( nDeflection ) );
    }

    if( nNatural > 0 ){

        eReturn = EffectLinkEffects( EffectACIncrease( nNatural, AC_NATURAL_BONUS ), eReturn );
        SendMessageToPC( oPC, "<c þ >Natural: "+IntToString( nNatural ) );
    }

    if( nDodge > 0 ){

        eReturn = EffectLinkEffects( EffectACIncrease( nDodge, AC_DODGE_BONUS ), eReturn );
        SendMessageToPC( oPC, "<c þ >Dodge: "+IntToString( nDodge ) );
    }

    if( nSheild > 0 ){

        eReturn = EffectLinkEffects( EffectACIncrease( nSheild, AC_SHIELD_ENCHANTMENT_BONUS ), eReturn );
        SendMessageToPC( oPC, "<c þ >Shield: "+IntToString( nSheild ) );
    }


    /*SendMessageToPC( oPC, "<c þ >Deflection: "+IntToString( nDeflection ) );
    SendMessageToPC( oPC, "<c þ >Dodge: "+IntToString( nDodge ) );
    SendMessageToPC( oPC, "<c þ >Sheild: "+IntToString( nSheild + nBaseSheild ) );
    SendMessageToPC( oPC, "<c þ >Armor: "+IntToString( nBaseArmor + nArmor ) );*/

    return eReturn;
}

int GetShifterDC( object oPC, int nIfoPCIsntShifterUseThisInstead ){

    if( GetIsPolymorphed( oPC ) && GetLevelByClass( CLASS_TYPE_SHIFTER, oPC ) > 0 ) {
        int nReturn = 10 + ( GetLevelByClass( CLASS_TYPE_SHIFTER, oPC ) / 2 ) + GetAbilityModifier( ABILITY_WISDOM, oPC );
        if( nReturn > 35 )
            nReturn = 35;
        return nReturn;
    }
    return nIfoPCIsntShifterUseThisInstead;
}

int GetNewCasterLevel( object oPC, int nIfoPCIsntShifterUseThisInstead = 0  ){

    if( GetIsPolymorphed( oPC ) && GetLevelByClass( CLASS_TYPE_SHIFTER, oPC ) > 0 )
        return GetLevelByClass( CLASS_TYPE_DRUID ,oPC ) + GetLevelByClass( CLASS_TYPE_SHIFTER ,oPC );
    else if( nIfoPCIsntShifterUseThisInstead > 0 )
        return nIfoPCIsntShifterUseThisInstead;
    return GetCasterLevel( oPC );
}

void ShifterMerge( object oPC, object oOldWeapon, object oArmor, object oRing1, object oRing2, object oBoots, object oSheild, object oAmulet, object oCloak, object oHands, object oBelt, object oHelm, int nPolymorph ){

    object oWeaponNew   = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    object oRClaw       = GetItemInSlot( INVENTORY_SLOT_CWEAPON_R, oPC );
    object oLClaw       = GetItemInSlot( INVENTORY_SLOT_CWEAPON_L, oPC );
    object oBite        = GetItemInSlot( INVENTORY_SLOT_CWEAPON_B, oPC );
    object oArmorNew    = GetItemInSlot( INVENTORY_SLOT_CARMOUR, oPC );

    if( oOldWeapon == oWeaponNew )
        return;

    RemoveItemPropertyByType( oWeaponNew, ITEM_PROPERTY_VISUALEFFECT );

    if( GetIsObjectValid( oWeaponNew ) && GetIsObjectValid( oOldWeapon ) ){

        SendMessageToPC( oPC, "<c þ >Merging "+GetName( oOldWeapon )+" with "+GetName( oWeaponNew )+"!" );
        SetIdentified( oWeaponNew, TRUE );
        MergeItemProperties( oPC, oOldWeapon, oWeaponNew );
    }
    else if( ( GetIsObjectValid( oRClaw ) || GetIsObjectValid( oBite ) || GetIsObjectValid( oLClaw ) ) && GetIsObjectValid( oOldWeapon ) ){

        if( GetIsObjectValid( oRClaw ) ){
            SendMessageToPC( oPC, "<c þ >Merging "+GetName( oOldWeapon )+" with right claw!" );
            MergeItemProperties( oPC, oOldWeapon, oRClaw );
        }
        if( GetIsObjectValid( oBite ) ){
            SendMessageToPC( oPC, "<c þ >Merging "+GetName( oOldWeapon )+" with bite!" );
            MergeItemProperties( oPC, oOldWeapon, oBite );
        }
        if( GetIsObjectValid( oLClaw ) ){
            SendMessageToPC( oPC, "<c þ >Merging "+GetName( oOldWeapon )+" with left claw!" );
            MergeItemProperties( oPC, oOldWeapon, oLClaw );
        }

    }

    if( StringToInt( Get2DAString( "polymorph", "MergeA", nPolymorph ) ) ){


        if( GetIsObjectValid( oArmorNew ) ){

            SetIdentified( oArmorNew, TRUE );

            if( GetIsObjectValid( oArmor ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oArmor )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oArmor, oArmorNew );
            }

            if( GetIsObjectValid( oSheild ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oSheild )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oSheild, oArmorNew );
            }

            if( GetIsObjectValid( oHelm ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oHelm )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oHelm, oArmorNew );
            }
        }
    }

    if( StringToInt( Get2DAString( "polymorph", "MergeI", nPolymorph ) ) ){
        if( GetIsObjectValid( oArmorNew ) ){

            SetIdentified( oArmorNew, TRUE );

            if( GetIsObjectValid( oRing1 ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oRing1 )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oRing1, oArmorNew );
            }

            if( GetIsObjectValid( oRing2 ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oRing2 )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oRing2, oArmorNew );
            }

            if( GetIsObjectValid( oAmulet ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oAmulet )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oAmulet, oArmorNew );
            }

            if( GetIsObjectValid( oCloak ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oCloak )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oCloak, oArmorNew );
            }

            if( GetIsObjectValid( oBoots ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oBoots )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oBoots, oArmorNew );
            }

            if( GetIsObjectValid( oBelt ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oBelt )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oBelt, oArmorNew );
            }

            if( GetIsObjectValid( oHands ) ){
                SendMessageToPC( oPC, "<c þ >Merging "+GetName( oHands )+" with "+GetInventorySlotName( INVENTORY_SLOT_CARMOUR )+"!" );
                MergeItemProperties( oPC, oHands, oArmorNew );
            }
        }
    }
}

effect EffectShifterEffect( effect eEffect, object oPC)
{
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, OBJECT_SELF);
    int iCL = GetLevelByClass(CLASS_TYPE_DRUID, oPC) + GetLevelByClass(CLASS_TYPE_SHIFTER, oPC);
    if(iCL==0) iCL = -1; //Shouldn't be like this, but for now we don't want to mess with non-shifters
    effect eReturn = SetEffectCreator( eEffect, oSkin);
    eReturn = SetEffectCasterLevel( eReturn, iCL);
    return eReturn;
}
