//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_acq_item
//group: module events
//used as: OnAcquireItem
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)

// 2009-09-12   Disco       Added rental housing support
// 2009/09/20   disco       Added some new DM toys
// 2009/09/24   disco       Shadowflame item nerfs
// 2009/09/30   disco       Item counter
// 2010/01/02   disco       Changed variable names and added celebration unfucker
// 2010/02/20   disco       Added some exploit counters
// 2010/02/28   disco       Added caraigh ring fix
// 2010/10/03   Selmak      Divine Grave removal by Letoscript for Fallen paladins
// 2013/07/08   PoS         Disabled most of the code for DMs as it's not needed
// 2015/05/26   msheeler    Set some code to only function after player log in, memoed out plot potion fix,
//                          shadowflame item nerfs, hemp rope swaps
// 2015/09/27   msheeler    removed nwnx_fun
// 2016/06/10   msheeler    added code to deal with item property removal and exchanges (100% immunities, IE, Magic and Divine DR)
// 2016/06/12   msheeler    set all item property remove and exchanges to go live

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_rental"
// #include "nwnx_funcs" -- removed
#include "cs_inc_leto"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

// Reports the newly acquired loot item to all members in the PCs party.
void ReportLootToParty( object oOwner, object oItem );

//returns values
//-1 if the item is illegal (and deleted)
// 0 if the item has some purpose and the script can stop
// 1 if the item is legal and the script must continue
int CheckItem( object oOwner, object oItem, string sTag );

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main( ){


    // Variables
    object oModule             = OBJECT_SELF;
    object oPC                 = GetModuleItemAcquiredBy( );
    object oItem               = GetModuleItemAcquired( );
    object oAcqFrom            = GetModuleItemAcquiredFrom( );
    string sAcqFromTag         = GetTag( oAcqFrom );
    string sPCName             = GetName( oPC );
    string sAcqFromName        = GetName( oAcqFrom );
    string sTag                = GetTag( oItem );
    string sResRef             = GetResRef( oItem );
    string sName;
    int nImmunityType;
    int nOwnership             = GetLocalInt( oItem, "ds_os" ) + 1;
    int nLoggedIn              = GetLocalInt( oPC, "LoggedIn" );
    itemproperty iProp;
    itemproperty iPropAdd;

    if( GetIsDM( oPC ) ){

        WriteTimestampedLogEntry( GetPCPlayerName( oPC )+ " - mod_acq_item 62: DM has acquired an item!" );
        return;
    }

    // Merchant Cleanup System
    SetLocalInt( oItem, "cln", TRUE );

    //count items
    SetLocalInt( oPC, "items", GetLocalInt( oPC, "items" ) + 1 );

    //remove or change item properties
    if (GetIsPC (oPC))
    {
        iProp = GetFirstItemProperty ( oItem );
        while( GetIsItemPropertyValid( iProp ) ){
            switch ( GetItemPropertyType ( iProp )){
                case ITEM_PROPERTY_DAMAGE_RESISTANCE:
                    if ( GetItemPropertySubType( iProp ) == IP_CONST_DAMAGETYPE_MAGICAL ){
                        sName = GetName( oItem );
                        SendMessageToPC( oPC, "Item " + sName + " had MAGICAL DR. This property has been replaced with 1/day Lesser Spell Mantle." );
                        RemoveItemProperty( oItem, iProp );
                        iPropAdd = ItemPropertyCastSpell( IP_CONST_CASTSPELL_LESSER_SPELL_MANTLE_9, IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY );
                        AddItemProperty( DURATION_TYPE_PERMANENT, iPropAdd, oItem );
                    }
                    if ( GetItemPropertySubType( iProp ) == IP_CONST_DAMAGETYPE_DIVINE ){
                        sName = GetName( oItem );
                        SendMessageToPC( oPC, "Item" + sName + " had DIVINE DR. This property has been replaced with +5 Lore Skill." );
                        RemoveItemProperty ( oItem, iProp );
                        iPropAdd = ItemPropertySkillBonus( SKILL_LORE, 5 );
                        AddItemProperty( DURATION_TYPE_PERMANENT, iPropAdd, oItem );
                    }
                break;
                case ITEM_PROPERTY_IMPROVED_EVASION:
                    sName = GetName( oItem );
                    SendMessageToPC( oPC, "Item " + sName + " had the feat IMPROVED EVASION. This property has been replaced with the Evasion feat and a -2 reflex save." );
                    RemoveItemProperty( oItem, iProp );
                    iPropAdd = ItemPropertyBonusFeat( 226 );
                    AddItemProperty ( DURATION_TYPE_PERMANENT, iPropAdd, oItem );
                    iPropAdd = ItemPropertyReducedSavingThrow( IP_CONST_SAVEBASETYPE_REFLEX, 2);
                    AddItemProperty ( DURATION_TYPE_PERMANENT, iPropAdd, oItem );
                break;
                case ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE:
                    if ( GetItemPropertyCostTableValue( iProp ) == IP_CONST_DAMAGEIMMUNITY_100_PERCENT ){
                        sName = GetName( oItem );
                        SendMessageToPC( oPC, "Item " + sName + " had a damage immunity value of 100%. This property has been reduced to 50% immunity." );
                        nImmunityType = ( GetItemPropertySubType( iProp ));
                        RemoveItemProperty ( oItem, iProp );
                        iPropAdd = ItemPropertyDamageImmunity( nImmunityType, IP_CONST_DAMAGEIMMUNITY_50_PERCENT );
                        AddItemProperty ( DURATION_TYPE_PERMANENT, iPropAdd, oItem );
                    }
                    if ( GetItemPropertySubType( iProp ) == IP_CONST_DAMAGETYPE_DIVINE){
                        sName = GetName( oItem );
                        RemoveItemProperty ( oItem, iProp );
                        SendMessageToPC( oPC, "Item " + sName + " had damage immunity type DIVINE. This property has been removed." );
                    }
                break;
    //          case ITEM_PROPERTY_FREEDOM_OF_MOVEMENT:
    //              sName = GetName( oItem );
    //              SendMessageToPC( oPC, "Item " + sName + " has the FREEDOM OF MOVEMENT property. This property will be replaced with 1/day Freedom of Movement in the near future." );
    //          break;
                case ITEM_PROPERTY_HASTE:
                    sName = GetName( oItem );
                    SendMessageToPC( oPC, "Item " + sName + " had the HASTE property. This property has been removed." );
                    RemoveItemProperty( oItem, iProp );
                break;
            }
            iProp = GetNextItemProperty( oItem );
        }
    }
//remove items

    if ( GetTag( oItem ) == "dc_cus_potion7" ){
        DestroyObject( oItem );
    }
    if ( GetTag( oItem ) == "dc_cus_potion8" ){
        DestroyObject( oItem );
    }
    if ( GetTag( oItem ) == "dc_cus_potion9" ){
        DestroyObject( oItem );
    }
    if ( GetTag( oItem ) == "dc_cus_potion10" ){
        DestroyObject( oItem );
    }
    if ( GetTag( oItem ) == "dc_cus_potion11" ){
        DestroyObject( oItem );
    }
    if ( GetTag( oItem ) == "dc_cus_potion12" ){
        DestroyObject( oItem );
    }if ( GetTag( oItem ) == "dc_cus_potion13" ){
        DestroyObject( oItem );
    }
    if ( GetTag( oItem ) == "dc_cus_potion14" ){
        DestroyObject( oItem );
    }

    //anti pp
    SetPickpocketableFlag( oItem, FALSE );

    //this destroys any illegal stuff from the market stalls
    if ( sTag == "mkt_destroy" ){

        DestroyObject( oItem, 0.5 );
        return;
    }

    if ( GetIsPC( oPC ) ){

        if ( GetIsBannedItem( oPC, sTag ) ){
            log_to_exploits( oPC, "Destroyed illegal item: "+GetName( oItem ), GetResRef( oItem ) );
            DestroyObject( oItem );
            return;
        }
        if ( GetResRef( oItem ) == "dmfi_pc_dicebag" ){
            DestroyObject( oItem );
            return;
        }
        if ( GetItemHasItemProperty( oItem, ITEM_PROPERTY_HASTE ) && !GetIsDM( oPC ) ){
            log_to_exploits( oPC, "Perma Haste!", GetName( oItem ), GetBaseItemType( oItem ) );
            return;
        }

    }

    // keys for racial doors
    if ( sResRef == "ds_racial_key" ){
        SetLocalInt( oPC, GetLocalString( oItem, "door" ), 1 );
        return;
    }

    // cordor key for goody goody drow
    if ( sResRef == "ds_cordor_key" ){
        SetLocalInt( oPC, "rl_Cordor", 1 );
        return;
    }

    //rental key
    if ( sResRef == RNT_KEY_TAG ){

        SetLocalString( oPC, RNT_PCKEY, sTag );
        SendMessageToPC( oPC, "Debug: mod_acq_item: loading rental key on PC." );
        return;
    }

    if (( GetIsPC ( oPC ) == FALSE ) || ( GetIsPC ( oPC ) && ( nLoggedIn == 1 ))){

        //check special stuff
        if ( CheckItem( oPC, oItem, sTag ) < 1 ){
            return;
        }

        if ( GetIsPC( oPC ) ){

            // old journal
            if ( sTag == "amiajournal" ){

                SetLocalObject( oPC, "MyJournal", oItem );
                return;
            }

            //------------------------------------------------

            //used in the grove
            if ( sTag == "ds_grove" ){

                SetLocalObject( oPC, "ds_bark", oItem );
                return;
            }
            //used in the Forrstakkr
            if ( sTag == "tha_map" ){

                SetLocalInt( oPC, "tha_map", 1 );
                return;
            }
            // Report loot item to all party members.
            if(  sAcqFromTag == "LootCorpse" || sAcqFromTag == "ds_daloot" ){

                ReportLootToParty( oPC, oItem );
            }
        }

        // Temporary until our item scripts are patched up to conform to Bioware standards.
        if( sTag == "glowy_eyes1" ||
            sTag == "glowy_eyes2" ||
            sTag == "prop" ||
            sTag == "CultistList"  ||
            sTag == "car_activate"  ||
            sTag == "lightsensi"    ||
            sTag == "ds_druidstaff" ){

            // Forward onAcquired in all other cases [Temporarily to the Glowy Eyes only atm.]
            SetUserDefinedItemEventNumber( X2_ITEM_EVENT_ACQUIRE );
            ExecuteScriptAndReturnInt( "i_" + sTag, oModule );
            return;
        }

        //trace possession history
        if ( sAcqFromName == "" && nOwnership == 1 ){

            SetLocalInt( oItem, "ds_os", 1 );
            SetLocalString( oItem, "ds_os_1", "Possessed by "+sPCName );
        }
        else if (  sAcqFromName != "" ){

            SetLocalInt( oItem, "ds_os", nOwnership );
            SetLocalString( oItem, "ds_os_"+IntToString( nOwnership ), sAcqFromName+" > "+sPCName );
        }
     }
}

// Reports the newly acquired loot item to all members in the PCs party.
void ReportLootToParty( object oPC, object oItem ){

    string sMessage = GetName( oPC ) + " has picked up "
                        + GetItemBaseTypeName(oItem) + " from a corpse.";

    object oArea   = GetArea( oPC );
    object oMember = GetFirstFactionMember( oPC );

    while ( GetIsPC(oMember) ) {

        if ( GetArea(oMember) == oArea && oMember != oPC ){

            SendMessageToPC( oMember, sMessage );
        }

        oMember = GetNextFactionMember( oPC );
    }

    return;
}

int CheckItem( object oPC, object oItem, string sTag ){

    //paladin fall item
    if ( sTag == "dg_fall" ){

        //This sets the Paladin to a fallen state.
        SetLocalInt( oPC, "Fallen", 1 );

        if ( GetLevelByClass( CLASS_TYPE_PALADIN, oPC ) ){

            if ( GetHasFeat( FEAT_DIVINE_GRACE, oPC ) ){
                //NWNXFuncs_RemoveFeat( oPC, FEAT_DIVINE_GRACE );
                //SendMessageToPC( oPC, "Your Divine Grace feat has been removed because your character is Fallen." );

                string szModification = "replace 'Feat', "+IntToString(FEAT_DIVINE_GRACE)+", DeleteParent;";
                //freeze player
                effect eFreeze = EffectCutsceneImmobilize();
                ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eFreeze, oPC, 5.0 );
                SendMessageToPC( oPC, "Your paladin is Fallen.  You will be booted in 5 seconds so that Divine Grace can be removed.");
                DelayCommand( 3.0, ExportSingleCharacter( oPC ) );

            }

        }
        DelayCommand( 3.0, SendMessageToAllDMs( GetName( oPC )+" has been naughty and is Fallen!" ) );
        return 0;
    }
    if ( sTag == "BossRing" ){

        SetLocalInt( oPC, "is_boss", 1 );
        return 0;
    }
    return 1;
}


