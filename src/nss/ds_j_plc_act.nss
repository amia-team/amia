//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_plc_act
//group:   Jobs & crafting
//used as: convo action script
//date:    december 2008
//author:  disco


//-------------------------------------------------------------------------------
// changelog
//-------------------------------------------------------------------------------
// 08 March 2011 - Selmak added prototypes and comments to file
//               - Selmak added options for leather armour, studded leather
//                 armour and hide armour to leatherworker's bench
//                 (in struct Multioptions GetMultiOptions)
// 18 June  2011 - Selmak recompiled with new include to add support for cloned
//                 job system placeables.
// 15 Aug   2012 - Glim fixed the rug output for a Weaver's Loom and for Job Rank
//                 rolling for burying a corpse with Undertaker or untrained.

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_j_lib"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//returns base group
// 1 = armour
// 2 = ammo
// 3 = ranged
// 4 = melee
// 5 = jewelry
// FALSE = none of the above
int ds_j_GetBaseItemGroup( object oItem );

//adds specific properties depending on material used
object ds_j_AddMetalProperty( object oPC, object oItem, int nMaterial, int nResult, int nDebug );

//puts quality and material properties on item
object ds_j_AddMaterialProperties2( object oPC, object oItem, int nMaterial1, int nRank, int nResult, int nMaterial2=0, int nDebug=0 );

object ds_j_GetComponentByID( object oSource, int nID  );

//this is the basic resource routine.
//it takes oComponent, checks if it needs another component
//if everything is OK it produces the next resource
void ds_j_ProcessResource( object oPC, object oSource, object oComponent );


void ds_j_ProcessInventory( object oPC, object oInventory );

//returns two resrefs as a struct, depending on which job is being used and which node is active
struct Multioptions GetMultiOptions( int nJob, int nNode );

//this is used when you can make multiple items out of certain resources
//mind that the resource from input1 determines the material IP of the result
void ds_j_ProcessMultiOption( object oPC, object oPLC, int nJob, int nNode, int nDebug=0 );

//this is used when you can make multiple items out of certain resources
//mind that the resource from input1 determines the material IP of the result
void ds_j_CreateJewelry( object oPC, object oPLC, int nJob, int nNode );

void ds_j_GraveDigger( object oPC, object oPLC, int nJob );

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------


//returns base group
// 1 = armour
// 2 = ammo
// 3 = ranged
// 4 = melee
// 5 = jewelry
// FALSE = none of the above
int ds_j_GetBaseItemGroup( object oItem ){

    int nBaseItem = GetBaseItemType( oItem );

    if ( nBaseItem == BASE_ITEM_ARMOR ||
         nBaseItem == BASE_ITEM_GLOVES ||
         nBaseItem == BASE_ITEM_HELMET ||
         nBaseItem == BASE_ITEM_LARGESHIELD ||
         nBaseItem == BASE_ITEM_SMALLSHIELD ||
         nBaseItem == BASE_ITEM_TOWERSHIELD ||
         nBaseItem == BASE_ITEM_BELT ||
         nBaseItem == BASE_ITEM_BOOTS ||
         nBaseItem == BASE_ITEM_BRACER ){

        return 1;
    }
    else if ( nBaseItem == BASE_ITEM_ARROW ||
              nBaseItem == BASE_ITEM_BOLT ||
              nBaseItem == BASE_ITEM_BULLET ||
              nBaseItem == BASE_ITEM_DART ||
              nBaseItem == BASE_ITEM_SHURIKEN ||
              nBaseItem == BASE_ITEM_THROWINGAXE ){

        return 2;
    }
    else if ( nBaseItem == BASE_ITEM_HEAVYCROSSBOW ||
              nBaseItem == BASE_ITEM_LIGHTCROSSBOW ||
              nBaseItem == BASE_ITEM_LONGBOW ||
              nBaseItem == BASE_ITEM_SHORTBOW ||
              nBaseItem == BASE_ITEM_SLING ){

        return 3;
    }
    else if ( nBaseItem == BASE_ITEM_BASTARDSWORD ||
              nBaseItem == BASE_ITEM_BATTLEAXE ||
              nBaseItem == BASE_ITEM_CLUB ||
              nBaseItem == BASE_ITEM_DAGGER ||
              nBaseItem == BASE_ITEM_DIREMACE ||
              nBaseItem == BASE_ITEM_DOUBLEAXE ||
              nBaseItem == BASE_ITEM_DWARVENWARAXE ||
              nBaseItem == BASE_ITEM_GREATAXE ||
              nBaseItem == BASE_ITEM_GREATSWORD ||
              nBaseItem == BASE_ITEM_HALBERD ||
              nBaseItem == BASE_ITEM_HANDAXE ||
              nBaseItem == BASE_ITEM_HEAVYFLAIL ||
              nBaseItem == BASE_ITEM_KAMA ||
              nBaseItem == BASE_ITEM_KATANA ||
              nBaseItem == BASE_ITEM_KUKRI ||
              nBaseItem == BASE_ITEM_LIGHTFLAIL ||
              nBaseItem == BASE_ITEM_LIGHTHAMMER ||
              nBaseItem == BASE_ITEM_LIGHTMACE ||
              nBaseItem == BASE_ITEM_LONGSWORD ||
              nBaseItem == BASE_ITEM_MAGICSTAFF ||
              nBaseItem == BASE_ITEM_MORNINGSTAR ||
              nBaseItem == BASE_ITEM_QUARTERSTAFF ||
              nBaseItem == BASE_ITEM_RAPIER ||
              nBaseItem == BASE_ITEM_SCIMITAR ||
              nBaseItem == BASE_ITEM_SCYTHE ||
              nBaseItem == BASE_ITEM_SHORTSWORD ||
              nBaseItem == BASE_ITEM_SHORTSPEAR ||
              nBaseItem == BASE_ITEM_SICKLE ||
              nBaseItem == BASE_ITEM_TRIDENT ||
              nBaseItem == BASE_ITEM_TWOBLADEDSWORD ||
              nBaseItem == BASE_ITEM_WARHAMMER ||
              nBaseItem == BASE_ITEM_WHIP ){

        return 4;
    }
    else if ( nBaseItem == BASE_ITEM_AMULET ||
              nBaseItem == BASE_ITEM_RING ){

        return 5;
    }

    return FALSE;
}

//adds specific properties depending on material used
object ds_j_AddMetalProperty( object oPC, object oItem, int nMaterial, int nResult, int nDebug ){

    int nType = ds_j_GetBaseItemGroup( oItem );
    int nRes;
    itemproperty ipProp;
    int nColour;

    if ( nMaterial == 1 ){

        //adamantine
        switch ( nType ) {

            case 1: ipProp = ItemPropertyACBonusVsRace( IP_CONST_RACIALTYPE_CONSTRUCT, nResult ); nRes = 1; break;
            case 2: ipProp = ItemPropertyDamageBonusVsRace( IP_CONST_RACIALTYPE_CONSTRUCT, IP_CONST_DAMAGETYPE_PIERCING, nResult ); nRes = 1; break;
            case 4: ipProp = ItemPropertyAttackBonusVsRace( IP_CONST_RACIALTYPE_CONSTRUCT, nResult ); nRes = 1; break;
        }

        nColour = 167;
    }
    else if ( nMaterial == 5 ){

        //cold iron
        switch ( nType ) {

            case 1: ipProp = ItemPropertyACBonusVsRace( IP_CONST_RACIALTYPE_FEY, nResult ); nRes = 1; break;
            case 2: ipProp = ItemPropertyDamageBonusVsRace( IP_CONST_RACIALTYPE_FEY, IP_CONST_DAMAGETYPE_PIERCING, nResult ); nRes = 1; break;
            case 4: ipProp = ItemPropertyAttackBonusVsRace( IP_CONST_RACIALTYPE_FEY, nResult ); nRes = 1; break;
        }

        nColour = 74;
    }
    else if ( nMaterial == 7 ){

        //darksteel
        switch ( nType ) {

            case 1: ipProp = ItemPropertyACBonusVsRace( IP_CONST_RACIALTYPE_ELF, nResult ); nRes = 1; break;
            case 2: ipProp = ItemPropertyDamageBonusVsRace( IP_CONST_RACIALTYPE_ELF, IP_CONST_DAMAGETYPE_PIERCING, nResult ); nRes = 1; break;
            case 4: ipProp = ItemPropertyAttackBonusVsRace( IP_CONST_RACIALTYPE_ELF, nResult ); nRes = 1; break;
        }

        nColour = 6;
    }
    else if ( nMaterial == 11 ){

        //mithral
        switch ( nType ) {

            case 1: ipProp = ItemPropertyWeightReduction( 2 + nResult ); nRes = 1; break;
            case 4: ipProp = ItemPropertyWeightReduction( 2 + nResult ); nRes = 1; break;
        }

        nColour = 164;
    }
    else if ( nMaterial == 13 ){

        //silver
        switch ( nType ) {

            case 1: ipProp = ItemPropertyACBonusVsRace( RACIAL_TYPE_SHAPECHANGER, nResult ); nRes = 1; break;
            case 2: ipProp = ItemPropertyDamageBonusVsRace( RACIAL_TYPE_SHAPECHANGER, IP_CONST_DAMAGETYPE_PIERCING, nResult ); nRes = 1; break;
            case 4: ipProp = ItemPropertyAttackBonusVsRace( RACIAL_TYPE_SHAPECHANGER, nResult ); nRes = 1; break;
        }
    }
    else if ( nMaterial == 44 ){

        //training weapons
        switch ( nType ) {

            case 4: ipProp = ItemPropertyNoDamage( ); nRes = 1; break;
        }
    }
    else if ( nResult == 2 && ( nMaterial == 3 || nMaterial == 9 || nMaterial == 15 ) ){

        //bonus on bronze, iron, steel
        switch ( nType ) {

            case 1: ipProp = ItemPropertyACBonus( 1 ); nRes = 1; break;
            case 2: ipProp = ItemPropertyDamageBonus( IP_CONST_DAMAGETYPE_PIERCING, 1 ); nRes = 1; break;
            case 4: ipProp = ItemPropertyAttackBonus( 1 ); nRes = 1; break;
        }

        if ( nMaterial == 3 ){

            nColour = 14;
        }
        else if ( nMaterial == 9 ){

            nColour = 1;
        }
        else if ( nMaterial == 15 ){

            nColour = 4;
        }
    }
    else if ( nMaterial == 38 ){

        //ironwood
        switch ( nType ) {

            case 1: ipProp = ItemPropertyACBonus( 1 ); nRes = 1; break;
            case 3: ipProp = ItemPropertyAttackBonus( 1 ); nRes = 1; break;
            case 4: ipProp = ItemPropertyAttackBonus( 1 ); nRes = 1; break;
        }

        nColour = 117;
    }
    else if ( nMaterial == 39 ){

        //duskwood
        switch ( nType ) {

            case 3: ipProp = ItemPropertyWeightReduction( 2 + nResult ); nRes = 1; break;
        }
    }
    else if ( nMaterial == 40 ){

        //darkwood
        switch ( nType ) {

            case 3: ipProp = ItemPropertyExtraRangeDamageType( nResult ); nRes = 1; break;
        }
    }
    else if ( nResult == 2 && ( nMaterial == 41 || nMaterial == 42 ) ){

        //bonus for ash and yew
        switch ( nType ) {

            case 3: ipProp = ItemPropertyAttackBonus( 1 ); nRes = 1; break;
        }
    }

    if ( nRes == 1 ){

        IPSafeAddItemProperty( oItem, ipProp );
    }

    if ( GetBaseItemType( oItem ) == BASE_ITEM_ARMOR || GetBaseItemType( oItem ) == BASE_ITEM_HELMET ){

        oItem = ds_j_CopyReplaceItem( oItem, ITEM_APPR_TYPE_ARMOR_COLOR, 4, nColour );
        oItem = ds_j_CopyReplaceItem( oItem, ITEM_APPR_TYPE_ARMOR_COLOR, 5, nColour+1 );
    }

    if ( nDebug ){

        SendMessageToPC( oPC, CLR_BLUE+"[debug] > nRes: "+IntToString( nRes ) );
        SendMessageToPC( oPC, CLR_BLUE+"[debug] > nColour: "+IntToString( nColour ) );
        SendMessageToPC( oPC, CLR_BLUE+"[debug] > nType: "+IntToString( nType ) );
    }


    return oItem;
}


//puts quality and material properties on item
object ds_j_AddMaterialProperties2( object oPC, object oItem, int nMaterial1, int nRank, int nResult, int nMaterial2=0, int nDebug=0 ){

    if ( nDebug ){

        SendMessageToPC( oPC, CLR_BLUE+"[debug] sItem: "+GetName( oItem ) );
        SendMessageToPC( oPC, CLR_BLUE+"[debug] nMaterial1: "+IntToString( nMaterial1 ) );
    }

    if ( nMaterial1 > 0 ){

        itemproperty ipMaterial1 = ItemPropertyMaterial( nMaterial1 );
        IPSafeAddItemProperty( oItem, ipMaterial1 );

        oItem = ds_j_AddMetalProperty( oPC, oItem, nMaterial1, nResult, nDebug );
    }


    if ( nDebug ){
        SendMessageToPC( oPC, CLR_BLUE+"[debug] nMaterial2: "+IntToString( nMaterial2 ) );
    }

    if ( nMaterial2 > 0 ){

        itemproperty ipMaterial2 = ItemPropertyMaterial( nMaterial2 );
        IPSafeAddItemProperty( oItem, ipMaterial2, 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );

        oItem = ds_j_AddMetalProperty( oPC, oItem, nMaterial2, nResult, nDebug );
    }


    if ( nDebug ){

        SendMessageToPC( oPC, CLR_BLUE+"[debug] nQuality: "+IntToString( 5 + nRank + nResult ) );
        SendMessageToPC( oPC, CLR_BLUE+"[debug] Area: "+GetResRef( GetArea( oPC ) ) );
    }

    itemproperty ipQuality  = ItemPropertyQuality( 5 + nRank + nResult );
    IPSafeAddItemProperty( oItem, ipQuality );

    SetDescription( oItem, GetDescription( oItem ) + CLR_ORANGE+"\n\nThis item was created by "+GetName( oPC ) +"."+CLR_END );

    return oItem;
}



object ds_j_GetComponentByID( object oSource, int nID  ){

    string sTag = DS_J_RESOURCE_PREFIX + IntToString( nID );

    return GetItemPossessedBy( oSource, sTag );
}

//this is the basic resource routine.
//it takes oComponent, checks if it needs another component
//if everything is OK it produces the next resource
void ds_j_ProcessResource( object oPC, object oSource, object oComponent ){

    //get resource id from the tag
    int nResource1 = ds_j_GetResourceID( oPC, oComponent );

    if ( !nResource1 ){

        //some error
        return;
    }

    object oComponent2;
    string sInput1;
    string sInput2;
    int nResource2;
    int nTargetResource;
    int nTargetIndex;
    int i;
    int nCount = GetLocalInt( oSource, DS_J_DONE );
    int nComponents;

    for ( i=1; i<=nCount; ++i ){

        sInput1 = DS_J_INPUT1 + "_" + IntToString( i );

        if ( GetLocalInt( oSource, sInput1 ) == nResource1 ){

            sInput2 = DS_J_INPUT2 + "_" + IntToString( i );

            nResource2 = GetLocalInt( oSource, sInput2 );

            if ( nResource2 > 0 ){

                oComponent2 = ds_j_GetComponentByID( oSource, nResource2  );

                if ( GetIsObjectValid( oComponent2 ) ){

                    nTargetResource = GetLocalInt( oSource, DS_J_ID + "_" + IntToString( i ) );
                    nTargetIndex    = i;
                    nComponents     = 2;
                    break;
                }
            }
            else{

                nTargetResource = GetLocalInt( oSource, DS_J_ID + "_" + IntToString( i ) );
                nTargetIndex    = i;
                nComponents     = 1;
                break;
            }
        }
    }

    if ( nComponents <= 0 ){

        return;
    }

    string sSuffix = "_" + IntToString( nTargetIndex );

    string sResRef = GetLocalString( oSource, DS_J_RESREF+sSuffix );

    if ( sResRef != "" ){


        //check if the find is succesful and deal with XP
        int nJob      = GetLocalInt( oSource, DS_J_JOB+sSuffix );
        int nResult   = ds_j_StandardRoll( oPC, nJob );
        int nRank     = ds_j_GiveStandardXP( oPC, nJob, nResult );

        //cleaning up
        DestroyObject( oComponent );

        if ( nComponents == 2 ){

            DestroyObject( oComponent2 );
        }

        //
        if ( nResult <= 0 ){

            SendMessageToPC( oPC, CLR_ORANGE+DS_J_FAILURE );
        }
        else {

            //string sName   = CLR_ORANGE+ds_j_GetResourceName( nTargetResource )+CLR_END;
            int nMaterial  = GetLocalInt( oSource, DS_J_MATERIAL_PREFIX+sSuffix );
            int nIcon      = GetLocalInt( oSource, DS_J_ICON+sSuffix );
            //string sTag    = DS_J_RESOURCE_PREFIX + IntToString( nTargetResource );
            object oItem   = ds_j_CreateItemOnPC( oPC, sResRef, nTargetResource, "", "", nIcon );

            ds_j_AddMaterialProperties( oPC, oItem, nMaterial, nRank, nResult );

            int nType = GetLocalInt( oSource, DS_J_TYPE+sSuffix );

            if ( nType > 0 ){

                //used for activated items' price and food/drink HP
                SetLocalInt( oItem, DS_J_TYPE, nType );
            }
        }
    }
    else{

        SendMessageToPC( oPC, "["+CLR_RED+"Error: Can't find proper resref in database."+CLR_END+"]" );
    }
}

void ds_j_ProcessInventory( object oPC, object oInventory ){

    object oItem = GetFirstItemInInventory( oInventory );
    float fDelay = 0.3;

    while ( GetIsObjectValid( oItem ) == TRUE ){

        DelayCommand( fDelay, ds_j_ProcessResource( oPC, oInventory, oItem ) );

        fDelay += 0.3;

        oItem = GetNextItemInInventory( oInventory );
    }
}

//returns two resrefs as a struct, depending on which job is being used and which node is active
struct Multioptions GetMultiOptions( int nJob, int nNode ){

    struct Multioptions s_return;

    string sResRef;
    string sTemplate;

    if ( nJob == 7 ){

        sTemplate = "ds_j_t_leather";

        switch ( nNode ){

            case 01:     sResRef = "ds_j_backpack";    break;
            case 02:     sResRef = "ds_j_quiver";      break;
            case 03:     sResRef = "ds_j_scabbard";    break;
            case 04:     sResRef = "ds_j_scabbard_a";  break;
            case 05:     sResRef = "ds_j_scabbard_b";  break;
            case 06:     sResRef = "ds_j_gauntlet";    break;
            case 07:     sResRef = "ds_j_bandagebox";  break;
            case 08:     sResRef = "ds_j_c_19";     sTemplate = "ds_j_t_armour";  break; // Leather Armour  AC 2
            case 09:     sResRef = "ds_j_c_17";     sTemplate = "ds_j_t_armour";  break; // Studded Armour  AC 3
            case 10:     sResRef = "ds_j_c_20";     sTemplate = "ds_j_t_armour";  break; // Hide Armour     AC 4
        }
    }
    else if ( nJob == 15 ){

        sTemplate = "ds_j_t_carpet";

        switch ( nNode ){

            case 02:     sResRef = "ds_furniture_18";    break;
            case 03:     sResRef = "ds_furniture_17";    break;
            case 04:     sResRef = "ds_furniture_19";    break;
            case 05:     sResRef = "ds_furniture_20";    break;
            case 06:     sResRef = "ds_furniture_21";    break;
        }
    }
    else if ( nJob == 53 ){

        sTemplate = "ds_j_t_armour";

        switch ( nNode ){

            case 01:     sResRef = "nw_aarcl012";    break; //Chain Shirt  AC 4
            case 02:     sResRef = "nw_aarcl010";    break; //Breastplate  AC 5
            case 03:     sResRef = "nw_aarcl011";    break; //Banded Mail  AC 6
            case 04:     sResRef = "nw_aarcl006";    break; //Half Plate   AC 7
            case 05:     sResRef = "ds_j_c_16";      break; //Plate Armour AC 8
            case 06:     sResRef = "nw_ashsw001";    break;
            case 07:     sResRef = "nw_ashlw001";    break;
            case 08:     sResRef = "ds_j_tshield";   break;
            case 09:     sResRef = "ds_j_helmet";    break;
            case 10:     sResRef = "ds_j_bracers";   break;
        }
    }
    else if ( nJob == 54 ){

        sTemplate = "ds_j_t_melee";

        switch ( nNode ){

            case 01:     sResRef = "ds_j_c_3";    break;
            case 02:     sResRef = "ds_j_c_2";    break;
            case 03:     sResRef = "ds_j_c_28";    break;
            case 04:     sResRef = "ds_j_c_22";    break;
            case 05:     sResRef = "nw_wdbma001";    break;
            case 06:     sResRef = "nw_wdbax001";    break;
            case 07:     sResRef = "x2_wdwraxe001";  break;
            case 08:     sResRef = "ds_j_c_18";    break;
            case 09:     sResRef = "ds_j_c_13";    break;
            case 10:     sResRef = "ds_j_c_10";    break;
            case 11:     sResRef = "nw_waxhn001";    break;
            case 12:     sResRef = "ds_j_c_35";    break;
            case 13:     sResRef = "nw_wspka001";    break;
            case 14:     sResRef = "nw_wswka001";    break;
            case 15:     sResRef = "nw_wspku001";    break;
            case 16:     sResRef = "nw_wblfl001";    break;
            case 17:     sResRef = "nw_wblhl001";   break;
            case 18:     sResRef = "ds_j_c_9";    break;
            case 19:     sResRef = "ds_j_c_1";    break;
            case 20:     sResRef = "ds_j_staff";     break;
            case 21:     sResRef = "ds_j_c_47";    break;
            case 22:     sResRef = "ds_j_c_50";    break;
            case 23:     sResRef = "ds_j_c_51";    break;
            case 24:     sResRef = "ds_j_c_53";    break;
            case 25:     sResRef = "ds_j_c_55";    break;
            case 26:     sResRef = "ds_j_c_58";    break;
            case 27:     sResRef = "ds_j_c_0";    break;
            case 28:     sResRef = "nw_wspsc001";    break;
            case 29:     sResRef = "ds_j_c_95";    break;
            case 30:     sResRef = "nw_wdbsw001";    break;
            case 31:     sResRef = "ds_j_c_5";    break;
            case 32:     sResRef = "ds_j_c_111";   break;
            case 33:     sResRef = "nw_wthdt001";    break;
            case 34:     sResRef = "nw_wthsh001";    break;
            case 35:     sResRef = "nw_wthax001";    break;
        }
    }
    else if ( nJob == 55 ){

        sTemplate = "ds_j_t_ammo";

        switch ( nNode ){
            case 01:     sResRef = "nw_wambu001";    break;
            case 02:     sResRef = "nw_wamar001";    break;
            case 03:     sResRef = "nw_wambo001";    break;
        }
    }
    else if ( nJob == 56 ){

        sTemplate = "ds_j_t_clothing";

        switch ( nNode ){

            case 01:     sResRef = "ds_j_hooded";    break;
            case 02:     sResRef = "ds_j_masked";    break;
            case 03:     sResRef = "ds_j_cloak";     break;
            case 04:     sResRef = "ds_j_dress";     break;
            case 05:     sResRef = "ds_j_gloves";    break;
            case 06:     sResRef = "nw_aarcl009";    break;
            case 07:     sResRef = "ds_j_robe";      break;
            case 08:     sResRef = "ds_j_suit";      break;
            case 09:     sResRef = "ds_j_tunic";     break;
            case 10:     sResRef = "ds_j_gempouch";  break;
        }
    }
    else if ( nJob == 57 ){

        sTemplate = "ds_j_t_bow";

        switch ( nNode ){

            case 01:     sResRef = "nw_wbwsl001";  sTemplate = "ds_j_t_sling";  break;
            case 02:     sResRef = "nw_wbwsh001";    break;
            case 03:     sResRef = "nw_wbwln001";    break;
            case 04:     sResRef = "nw_wbwxl001";    break;
            case 05:     sResRef = "nw_wbwxh001";    break;
        }
    }

    s_return.sTemplate = sTemplate;
    s_return.sResRef   = sResRef;

    return s_return;
}



//this is used when you can make multiple items out of certain resources
//mind that the resource from input1 determines the material IP of the result
void ds_j_ProcessMultiOption( object oPC, object oPLC, int nJob, int nNode, int nDebug=0 ){

    object oComponent1      = GetFirstItemInInventory( oPLC );

    if ( !GetIsObjectValid( oComponent1 ) ){

        SendMessageToPC( oPC, CLR_RED+"There is no item in this object!" );
        return;
    }

    int nResource1         = StringToInt( GetSubString( GetTag( oComponent1 ), 9, 15 ) );

    if ( !nResource1 ){

        //some error
        SendMessageToPC( oPC, "["+CLR_RED+GetName( oComponent1 )+" is not processed by this object."+CLR_END+"]" );
        return;
    }

    struct Multioptions s_Options = GetMultiOptions( nJob, nNode );
    object oComponent2      = GetNextItemInInventory( oPLC );
    int nResource2          = StringToInt( GetSubString( GetTag( oComponent2 ), 9, 15 ) );
    int nInput1             = 0;
    int nInput2             = 0;
    int nTargetResource     = 0;
    int nCount              = GetLocalInt( oPLC, DS_J_DONE );
    int nComponents;
    int nMaterial1;
    int nMaterial2;
    int i;
    int nType;
    string sTemplate;
    string sSuffix;

    for ( i=1; i<=nCount; ++i ){

        sSuffix         = "_" + IntToString( i );

        nInput1         = GetLocalInt( oPLC, DS_J_INPUT1 + sSuffix );
        nInput2         = GetLocalInt( oPLC, DS_J_INPUT2 + sSuffix );
        sTemplate       = GetLocalString( oPLC, DS_J_RESREF + sSuffix );
        nTargetResource = GetLocalInt( oPLC, DS_J_ID + sSuffix );
        nType           = GetLocalInt( oPLC, DS_J_TYPE + sSuffix );

        if ( sTemplate == s_Options.sTemplate ){

            if ( nInput1 == nResource1 ){

                if ( ( nInput2 > 0 && nInput2 == nResource2 ) ){

                    nMaterial1  = ds_j_GetMaterialFromItem( oComponent1 );
                    nMaterial2  = ds_j_GetMaterialFromItem( oComponent2 );
                    nComponents = 2;

                    break;
                }
                else if ( nInput2 == 0 ){

                    nMaterial1  = ds_j_GetMaterialFromItem( oComponent1 );
                    nComponents = 1;
                    break;
                }
            }
            else if ( nInput2 == nResource1 ){

                if ( nInput1 == nResource2 ){

                    nMaterial1  = ds_j_GetMaterialFromItem( oComponent2 );
                    nMaterial2  = ds_j_GetMaterialFromItem( oComponent1 );
                    nComponents = 2;
                    break;
                }
            }
        }
    }

    if ( nDebug ){

        SendMessageToPC( oPC, "Please send the blue lines to Dev Disco if you don't get properties on your item." );
        SendMessageToPC( oPC, CLR_BLUE+"[debug] sComponent1: "+GetTag( oComponent1 ) );
        SendMessageToPC( oPC, CLR_BLUE+"[debug] sComponent2: "+GetTag( oComponent2 ) );
        SendMessageToPC( oPC, CLR_BLUE+"[debug] nJob: "+IntToString( nJob ) );
    }



    //jeweler hack
    if ( nJob == 58 && nNode > 2 && nComponents > 0 ){

        //if component 1 is a metal
        if ( GetResRef( oComponent1 ) == "ds_j_medium" ){

            nMaterial1  = ds_j_GetMaterialFromItem( oComponent1 );
            nMaterial2  = ds_j_GetMaterialFromItem( oComponent2 );

        }
        else if ( GetResRef( oComponent2 ) == "ds_j_medium" ){

            nMaterial1  = ds_j_GetMaterialFromItem( oComponent2 );
            nMaterial2  = ds_j_GetMaterialFromItem( oComponent1 );
        }

        if ( nMaterial2 >= 52 && nMaterial2 <=77 ){

            nComponents = 2;
        }
        else{

            SendMessageToPC( oPC, CLR_RED+"There is no suitable (combination of) resource(s) in this object." );
            return;
        }
    }
    else if ( nComponents <= 0 ){

        SendMessageToPC( oPC, CLR_RED+"There is no suitable (combination of) resource(s) in this object." );
        return;
    }

    //int nJob            = GetLocalInt( oPLC, DS_J_JOB );

    if ( s_Options.sResRef != "" ){

        //cleaning up
        DestroyObject( oComponent1 );

        if ( nComponents == 2 ){

            DestroyObject( oComponent2 );
        }

        //check if the find is succesful and deal with XP
        int nResult   = ds_j_StandardRoll( oPC, nJob );
        int nRank     = ds_j_GiveStandardXP( oPC, nJob, nResult );

        if ( nResult <= 0 ){

            SendMessageToPC( oPC, CLR_ORANGE+DS_J_FAILURE );
        }
        else {

            string sMaterial    = ds_j_GetMaterialName( nMaterial1 );
            string sTag         = DS_J_RESOURCE_PREFIX + IntToString( nTargetResource );
            object oItem        = CreateItemOnObject( s_Options.sResRef, oPC, 50, sTag );
            string sName;
            int    nLength      = GetStringLength( sMaterial );
            string sResName     = GetName( oItem );

            //Checks to see if the resource name is already used at the start of the item name
            if ( sMaterial == GetSubString( sResName, 0, nLength ) ){

                    sName       = CLR_ORANGE + sResName + CLR_END;
            }
            else {

                    sName       = CLR_ORANGE + sMaterial + " " + sResName + CLR_END;
            }

            if ( nType > 0 ){

                //used for activated items' price and food/drink HP
                SetLocalInt( oItem, DS_J_TYPE, nType );
            }

            if ( nDebug ){

                SendMessageToPC( oPC, "Please send debug lines to Dev Disco if you don't get properties on your armour." );
                SendMessageToPC( oPC, CLR_BLUE+"[debug] nRank: "+IntToString( nRank ) );
                SendMessageToPC( oPC, CLR_BLUE+"[debug] nResult: "+IntToString( nResult ) );
                SendMessageToPC( oPC, CLR_BLUE+"[debug] sItem: "+GetTag( oItem ) );
            }

            oItem = ds_j_AddMaterialProperties2( oPC, oItem, nMaterial1, nRank, nResult, nMaterial2, nDebug );

            SetName( oItem, sName );
        }
    }
    else{

        SendMessageToPC( oPC, "["+CLR_RED+"Error: Can't find proper resref in table."+CLR_END+"]" );
    }
}

//this is used when you can make multiple items out of certain resources
//mind that the resource from input1 determines the material IP of the result
void ds_j_CreateJewelry( object oPC, object oPLC, int nJob, int nNode ){

    object oComponent1      = GetFirstItemInInventory( oPLC );

    if ( !GetIsObjectValid( oComponent1 ) ){

        SendMessageToPC( oPC, CLR_RED+"There is no item in this object!" );
        return;
    }

    int nResource1         = StringToInt( GetSubString( GetTag( oComponent1 ), 9, 15 ) );

    if ( !nResource1 ){

        //some error
        SendMessageToPC( oPC, "["+CLR_RED+GetName( oComponent1 )+" is not processed by this object."+CLR_END+"]" );
        return;
    }

    object oComponent2      = GetNextItemInInventory( oPLC );
    int nResource2          = StringToInt( GetSubString( GetTag( oComponent2 ), 9, 15 ) );
    int nInput1             = 0;
    int nTargetResource     = 0;
    int nCount              = GetLocalInt( oPLC, DS_J_DONE );
    int nComponents;
    int nMaterial1;
    int nMaterial2;
    int i;
    int nIcon;
    string sSuffix;
    string sName;
    string sResRef;


    //if component 1 is a metal
    if ( GetResRef( oComponent1 ) == "ds_j_medium" ){

        nResource1  = StringToInt( GetSubString( GetTag( oComponent1 ), 9, 15 ) );
        nResource2  = StringToInt( GetSubString( GetTag( oComponent2 ), 9, 15 ) );
        nMaterial1  = ds_j_GetMaterialFromItem( oComponent1 );
        nMaterial2  = ds_j_GetMaterialFromItem( oComponent2 );

    }
    else if ( GetResRef( oComponent2 ) == "ds_j_medium" ){

        nResource1  = StringToInt( GetSubString( GetTag( oComponent2 ), 9, 15 ) );
        nResource2  = StringToInt( GetSubString( GetTag( oComponent1 ), 9, 15 ) );
        nMaterial1  = ds_j_GetMaterialFromItem( oComponent2 );
        nMaterial2  = ds_j_GetMaterialFromItem( oComponent1 );
    }

    for ( i=1; i<=nCount; ++i ){

        sSuffix         = "_" + IntToString( i );
        nInput1         = GetLocalInt( oPLC, DS_J_INPUT1 + sSuffix );
        nTargetResource = GetLocalInt( oPLC, DS_J_ID + sSuffix );

        if ( nInput1 == nResource1 ){

            nComponents = 1;
            break;
        }
    }

    if ( nComponents == 1 ){

        if ( nMaterial2 >= 52 && nMaterial2 <=77 ){

            nComponents = 2;
        }
    }
    else{

        SendMessageToPC( oPC, CLR_RED+"There is no suitable (combination of) resource(s) in this object." );
        return;
    }

    switch ( nNode ){

        case 01:     sResRef = "ds_j_ring"; nIcon = 25; sName = "Signet Ring"; break;
        case 02:     sResRef = "ds_j_ring"; nIcon = 10; sName = "Ornamental Ring";  break;
        case 03:     sResRef = "ds_j_ring"; nIcon = 12; sName = "Carved Ring";    break;
        case 04:     sResRef = "ds_j_ring"; nIcon = 34; sName = "Ring with Leaves";  break;
        case 05:     sResRef = "ds_j_ring"; nIcon = 1; sName = "Wedding Ring";    break;
        case 06:     sResRef = "ds_j_ring"; nIcon = 36; sName = "Tacky Ring";  break;
        case 07:     sResRef = "ds_j_amulet"; nIcon = 13; sName = "Necklace";    break;
        case 08:     sResRef = "ds_j_amulet"; nIcon = 17; sName = "Necklace";  break;
        case 09:     sResRef = "ds_j_amulet"; nIcon = 9; sName = "Necklace";    break;
        case 10:     sResRef = "ds_j_amulet"; nIcon = 24; sName = "Tribal Amulet";  break;
        case 11:     sResRef = "ds_j_amulet"; nIcon = 26; sName = "Skull Amulet";    break;
    }


    //cleaning up
    DestroyObject( oComponent1 );

    if ( nComponents == 2 ){

        DestroyObject( oComponent2 );
    }

    //check if the find is succesful and deal with XP
    int nResult   = ds_j_StandardRoll( oPC, nJob );
    int nRank     = ds_j_GiveStandardXP( oPC, nJob, nResult );

    if ( nResult <= 0 ){

        SendMessageToPC( oPC, CLR_ORANGE+DS_J_FAILURE );
    }
    else {

        string sMaterial1    = ds_j_GetMaterialName( nMaterial1 );
        string sMaterial2    = ds_j_GetMaterialName( nMaterial2 );
        //string sTag          = DS_J_RESOURCE_PREFIX + IntToString( nTargetResource );

        if ( sMaterial2 != "" ){

            sName   = sMaterial1 + " and " + sMaterial2 + " " + sName;
        }
        else{

            sName   = sMaterial1 + " " + sName;
        }

        object oItem        = ds_j_CreateItemOnPC( oPC, sResRef, nTargetResource, sName, "", nIcon );

        ds_j_AddMaterialProperties( oPC, oItem, nMaterial1, nRank, nResult, nMaterial2 );

        SetName( oItem, sName );
    }
}

void ds_j_GraveDigger( object oPC, object oPLC, int nJob ){

    //gravedigger
    if ( GetLocalInt( oPLC, DS_J_DONE ) ){

        SendMessageToPC( oPC, CLR_RED + "This grave is in use!" + CLR_END );
    }
    else {

        object oCorpse = GetItemPossessedBy( oPLC, "ds_j_res_279" );

        //check if the burial is succesful and deal with XP
        int nResult   = ds_j_StandardRoll( oPC, nJob );

        if ( nResult <= 0 ){

            SendMessageToPC( oPC, CLR_ORANGE+DS_J_FAILURE );
            DestroyObject( oCorpse );
            DeleteLocalInt( oPC, DS_J_CORPSES );
        }
        else {

            if ( GetIsObjectValid( oCorpse ) ){

                SetName( oPLC, GetName( oCorpse ) );

                AssignCommand( oPC, SpeakString( CLR_ORANGE + "*buries " + GetName( oCorpse ) + "*" + CLR_END ) );

                DestroyObject( oCorpse );

                SetLocalInt( oPLC, DS_J_DONE, 1 );

                DeleteLocalInt( oPC, DS_J_CORPSES );

                GiveGoldToCreature( oPC, 1000 );
            }
        }
    }
}

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC       = OBJECT_SELF;
    object oPLC      = GetLocalObject( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    string sTag      = GetTag( oPLC );
    string sResRef   = GetResRef( oPLC );


    if ( sTag == "ds_j_leatherbench" ){

        //leatherworker
        ds_j_ProcessMultiOption( oPC, oPLC, 7, nNode );
    }
    else if ( sTag == "ds_j_armouranvil" ){

        //armour smith
        ds_j_ProcessMultiOption( oPC, oPLC, 53, nNode, TRUE );
    }
    else if ( sTag == "ds_j_weaponanvil" ){

        //weapon smith
        ds_j_ProcessMultiOption( oPC, oPLC, 54, nNode, TRUE );
    }
    else if ( sTag == "ds_j_tailorbench" ){

        //tailor
        ds_j_ProcessMultiOption( oPC, oPLC, 56, nNode );
    }
    else if ( sTag == "ds_j_bowyersbench" ){

        //bowyer
        ds_j_ProcessMultiOption( oPC, oPLC, 57, nNode, TRUE );
    }
    else if ( sTag == "ds_j_jeweler" ){

        //jeweler
        ds_j_CreateJewelry( oPC, oPLC, 58, nNode );
    }
    else if ( sTag != DS_J_CHEST && sResRef == DS_J_CHEST ){

        if ( nNode == 1 ){

            ds_j_BuyInventory( oPC, oPLC, OBJECT_INVALID, 0, 60 );
        }
        else{

            ds_j_BuyInventory( oPC, oPLC, OBJECT_INVALID, 1, 60 );
        }
    }
    else if ( sTag == "ds_j_headstone" ){

        ds_j_GraveDigger( oPC, oPLC, 68 );
    }
    else if ( nNode == 1 ){

        ds_j_ProcessInventory( oPC, oPLC );
    }
    else if ( sTag == "ds_j_loom" ){

        //weaver: carpets
        ds_j_ProcessMultiOption( oPC, oPLC, 15, nNode );
    }
    else if ( sTag == "ds_j_fletcherbench" ){

        //fletcher
        ds_j_ProcessMultiOption( oPC, oPLC, 55, nNode );
    }


}
