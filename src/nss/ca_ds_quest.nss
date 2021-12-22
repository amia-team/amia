//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ca_ds_quest
//group:   quests
//used as: generic quest actions for ds_checks
//date:    nov 09 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_records"


//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
int CreateWeapon( object oPC, object oNPC, int nIsGood );
int CreateArmour( object oPC, object oNPC, int nIsGood );
//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = OBJECT_SELF;
    object oNPC     = GetLocalObject( oPC, "ds_target" );
    int nNode       = GetLocalInt( oPC, "ds_node" );
    string sQuest   = GetLocalString( oNPC, "ds_quest" );



    //exceptions

    if ( nNode == 1 && sQuest == "ds_quest_7" ){

        ds_quest( oPC, "ds_quest_8", 6 );
    }

    if ( nNode == 3 && sQuest == "ds_quest_7" ){

        CreateWeapon( oPC, oNPC, 0 );

        ds_quest( oPC, sQuest, 5 );
        return;
    }

    if ( nNode == 4 && sQuest == "ds_quest_7" ){

        CreateArmour( oPC, oNPC, 0 );

        ds_quest( oPC, sQuest, 5 );
        return;
    }

    if ( nNode == 1 && sQuest == "ds_quest_8" ){

        ds_quest( oPC, "ds_quest_7", 6 );
    }

    if ( nNode == 3 && sQuest == "ds_quest_8" ){

        CreateWeapon( oPC, oNPC, 1 );

        ds_quest( oPC, sQuest, 5 );
        return;
    }

    if ( nNode == 4 && sQuest == "ds_quest_8" ){

        CreateArmour( oPC, oNPC, 1 );

        ds_quest( oPC, sQuest, 5 );
        return;
    }


    //actions 1-10 are used to change the status of the quest
    if ( nNode > 0 &&  nNode < 11 ){

        string sTake = GetLocalString( oNPC, "ds_take_" + IntToString( nNode ) );

        if ( sTake == "" || ( sTake != "" && ds_take_item( oPC, sTake )  ) ){

            int nXP = GetLocalInt( oNPC, "ds_xp_" + IntToString( nNode ) );

            if ( nXP > 0 ){

                GiveCorrectedXP( oPC, nXP, "Quest", 0 );
            }

            int nGold = GetLocalInt( oNPC, "ds_gp_" + IntToString( nNode ) );

            if ( nGold > 0 ){

                GiveGoldToCreature( oPC, nGold );
                UpdateModuleVariable( "QuestGold", nGold );
            }

            string sGive = GetLocalString( oNPC, "ds_give_" + IntToString( nNode ) );

            if ( sGive != "" ){

                ds_create_item( sGive, oPC );
            }

            ds_quest( oPC, sQuest, nNode );
        }
        else{

            SetLocalInt( oPC, "ds_check_" + IntToString( 10 + nNode ), 1 );
            SendMessageToPC( oPC, "You need a certain item to proceed with this quest!" );
        }
    }
}



//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

int CreateWeapon( object oPC, object oNPC, int nIsGood ){

    object oItem = GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oPC );
    object oWeapon;

    itemproperty ipVFX;
    itemproperty ipEnhancement1;
    itemproperty ipEnhancement2;
    itemproperty ipEnhancement3;
    itemproperty ipEnhancement4;
    itemproperty ipDamageType;
    itemproperty ipKeen;

    if ( GetIsObjectValid( oItem ) == FALSE ){

        oItem = GetItemInSlot( INVENTORY_SLOT_ARMS, oPC );
    }

    if ( IPGetIsMeleeWeapon( oItem ) && GetBaseItemType( oItem ) != BASE_ITEM_GLOVES ){

        ipKeen            = ItemPropertyKeen();

        if ( nIsGood == 1 ){

            ipVFX           = ItemPropertyVisualEffect( ITEM_VISUAL_HOLY );
            ipEnhancement1  = ItemPropertyEnhancementBonus( 3 );
            ipEnhancement2  = ItemPropertyEnhancementBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, 4 );
            ipEnhancement3  = ItemPropertyEnhancementBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, 4 );
            ipEnhancement4  = ItemPropertyEnhancementBonusVsSAlign( IP_CONST_ALIGNMENT_CE, 5 );
            ipDamageType    = ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_CE, 8, IP_CONST_DAMAGEBONUS_1d4 );
        }
        else{

            ipVFX           = ItemPropertyVisualEffect( ITEM_VISUAL_EVIL );
            ipEnhancement1  = ItemPropertyEnhancementBonus( 3 );
            ipEnhancement2  = ItemPropertyEnhancementBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, 4 );
            ipEnhancement3  = ItemPropertyEnhancementBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, 4 );
            ipEnhancement4  = ItemPropertyEnhancementBonusVsSAlign( IP_CONST_ALIGNMENT_LG, 5 );
            ipDamageType    = ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_LG, 8, IP_CONST_DAMAGEBONUS_1d4 );
        }
    }
    else if ( GetBaseItemType( oItem ) == BASE_ITEM_GLOVES ){

        ipDamageType = ItemPropertyDamageBonus( 8, IP_CONST_DAMAGEBONUS_3 );
        ipKeen       = ItemPropertyRegeneration( 1 );

        if ( nIsGood == 1 ){

            ipVFX           = ItemPropertyLight( IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_WHITE );
            ipEnhancement1  = ItemPropertyAttackBonus( 3 );
            ipEnhancement2  = ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, 8, IP_CONST_DAMAGEBONUS_4 );
            ipEnhancement3  = ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, 8, IP_CONST_DAMAGEBONUS_4 );
            ipEnhancement4  = ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_CE, 8, IP_CONST_DAMAGEBONUS_5 );
        }
        else{

            ipVFX           = ItemPropertyLight( IP_CONST_LIGHTBRIGHTNESS_NORMAL, IP_CONST_LIGHTCOLOR_PURPLE );
            ipEnhancement1  = ItemPropertyAttackBonus( 3 );
            ipEnhancement2  = ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, 8, IP_CONST_DAMAGEBONUS_4 );
            ipEnhancement3  = ItemPropertyDamageBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, 8, IP_CONST_DAMAGEBONUS_4 );
            ipEnhancement4  = ItemPropertyDamageBonusVsSAlign( IP_CONST_ALIGNMENT_LG, 8, IP_CONST_DAMAGEBONUS_5 );
        }
    }
    else if ( IPGetIsRangedWeapon( oItem ) ){

        ipDamageType = ItemPropertyUnlimitedAmmo( IP_CONST_UNLIMITEDAMMO_PLUS4 );
        ipKeen = ItemPropertyMassiveCritical( IP_CONST_DAMAGEBONUS_1d8 );

        if ( nIsGood == 1 ){

            ipVFX           = ItemPropertyVisualEffect( ITEM_VISUAL_HOLY );
            ipEnhancement1  = ItemPropertyAttackBonus( 3 );
            ipEnhancement2  = ItemPropertyAttackBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, 4 );
            ipEnhancement3  = ItemPropertyAttackBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, 4 );
            ipEnhancement4  = ItemPropertyAttackBonusVsSAlign( IP_CONST_ALIGNMENT_CE, 5 );
        }
        else{

            ipVFX           = ItemPropertyVisualEffect( ITEM_VISUAL_EVIL );
            ipEnhancement1  = ItemPropertyAttackBonus( 3 );
            ipEnhancement2  = ItemPropertyAttackBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, 4 );
            ipEnhancement3  = ItemPropertyAttackBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, 4 );
            ipEnhancement4  = ItemPropertyAttackBonusVsSAlign( IP_CONST_ALIGNMENT_LG, 5 );
        }
    }
    else{

        SendMessageToPC( oPC, "Sorry, no suitable weapon could not be found." );
        return FALSE;
    }

    //copy the weapon
    oWeapon   = CopyObject( oItem, GetLocation( oNPC ), oNPC, "ds_divine_spark" );

    //clean up the new weapon
    IPRemoveAllItemProperties( oWeapon, DURATION_TYPE_PERMANENT );
    IPRemoveAllItemProperties( oWeapon, DURATION_TYPE_TEMPORARY );
    IPRemoveAllItemProperties( oWeapon, DURATION_TYPE_INSTANT );

    //add new stuff
    IPSafeAddItemProperty( oWeapon, ipKeen );
    IPSafeAddItemProperty( oWeapon, ipEnhancement1 );
    IPSafeAddItemProperty( oWeapon, ipEnhancement2 );
    IPSafeAddItemProperty( oWeapon, ipEnhancement3 );
    IPSafeAddItemProperty( oWeapon, ipEnhancement4 );
    IPSafeAddItemProperty( oWeapon, ipDamageType );
    IPSafeAddItemProperty( oWeapon, ipVFX );

    SetName( oWeapon, "Divine Spark" );
    SetPlotFlag( oWeapon, TRUE );

    DelayCommand( 1.0, AssignCommand( oNPC, ActionGiveItem( oWeapon, oPC ) ) );

    return TRUE;
}

int CreateArmour( object oPC, object oNPC, int nIsGood ){

    object oItem = GetItemInSlot( INVENTORY_SLOT_CHEST, oPC );

    if ( GetIsObjectValid( oItem ) ){

        object oArmour   = CopyObject( oItem, GetLocation( oNPC ), oNPC, "ds_divine_spark" );

        //clean up the new weapon
        IPRemoveAllItemProperties( oArmour, DURATION_TYPE_PERMANENT );
        IPRemoveAllItemProperties( oArmour, DURATION_TYPE_TEMPORARY );
        IPRemoveAllItemProperties( oArmour, DURATION_TYPE_INSTANT );

        itemproperty ipLight;
        itemproperty ipEnhancement1;
        itemproperty ipEnhancement2;
        itemproperty ipEnhancement3;
        itemproperty ipEnhancement4;
        itemproperty ipDamageType;
        itemproperty ipRegen            = ItemPropertyRegeneration( 2 );

        if ( nIsGood == 1 ){

            ipLight         = ItemPropertyLight( IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_WHITE );
            ipEnhancement1  = ItemPropertyACBonus( 3 );
            ipEnhancement2  = ItemPropertyACBonusVsAlign( IP_CONST_ALIGNMENTGROUP_EVIL, 4 );
            ipEnhancement3  = ItemPropertyACBonusVsAlign( IP_CONST_ALIGNMENTGROUP_CHAOTIC, 4 );
            ipEnhancement4  = ItemPropertyACBonusVsSAlign( IP_CONST_ALIGNMENT_CE, 5 );
            ipDamageType    = ItemPropertyDamageResistance( IP_CONST_DAMAGETYPE_NEGATIVE, IP_CONST_DAMAGERESIST_10 );
        }
        else{

            ipLight         = ItemPropertyLight( IP_CONST_LIGHTBRIGHTNESS_BRIGHT, IP_CONST_LIGHTCOLOR_PURPLE );
            ipEnhancement1  = ItemPropertyACBonus( 3 );
            ipEnhancement2  = ItemPropertyACBonusVsAlign( IP_CONST_ALIGNMENTGROUP_GOOD, 4 );
            ipEnhancement3  = ItemPropertyACBonusVsAlign( IP_CONST_ALIGNMENTGROUP_LAWFUL, 4 );
            ipEnhancement4  = ItemPropertyACBonusVsSAlign( IP_CONST_ALIGNMENT_LG, 5 );
            ipDamageType    = ItemPropertyDamageResistance( IP_CONST_DAMAGETYPE_POSITIVE, IP_CONST_DAMAGERESIST_10 );
        }

        //add new stuff
        IPSafeAddItemProperty( oArmour, ipRegen );
        IPSafeAddItemProperty( oArmour, ipEnhancement1 );
        IPSafeAddItemProperty( oArmour, ipEnhancement2 );
        IPSafeAddItemProperty( oArmour, ipEnhancement3 );
        IPSafeAddItemProperty( oArmour, ipEnhancement4 );
        IPSafeAddItemProperty( oArmour, ipDamageType );
        IPSafeAddItemProperty( oArmour, ipLight );

        SetName( oArmour, "Divine Spark" );
        SetPlotFlag( oArmour, TRUE );

        AssignCommand( oNPC, ActionGiveItem( oArmour, oPC ) );

        return TRUE;
    }
    else{

        SendMessageToPC( oPC, "Sorry, no suitable armour could not be found." );
        return FALSE;
    }
}

