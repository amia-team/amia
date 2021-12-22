//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_j_spawn
//group:   Jobs & crafting
//used as: OnSpawn event of an NPC
//date:    december 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_actions"
#include "inc_ds_j_lib"



void ds_j_InitialiseMerchant( object oMerchant ){

    //collect current stash
    string sQuery;
    string sCategory    = GetLocalString( oMerchant, DS_J_CATEGORY );
    string sResource;
    string sName;
    string sDescription;
    int nAvailability;
    int nStock;
    int i;
    int nCount;
    int nPrice;
    int nIsSeller;

    if ( sCategory != "" ){

        SetName( oMerchant, CLR_ORANGE+sCategory+" "+DS_J_MERCHANT+CLR_END );

        if ( sCategory == "Alchemy" ||
             //sCategory == "Artifacts" ||
             sCategory == "Building Materials" ||
             sCategory == "Gem" ||
             sCategory == "Herb" ||
             sCategory == "Ingredients" ||
             sCategory == "Metal" ||
             sCategory == "Textile" ){

             nIsSeller = 1;

             SetLocalInt( oMerchant, DS_J_SELLER, 1 );
        }

        sQuery = "SELECT id, name, price, resref, icon FROM ds_j_resources WHERE category = '"+sCategory+"' AND alt_id=0 ORDER BY name";

        SQLExecDirect( sQuery );

        while ( SQLFetch( ) == SQL_SUCCESS ){

            ++nCount;

            sResource       = SQLGetData( 1 );
            sName           = SQLDecodeSpecialChars( SQLGetData( 2 ) );
            nPrice          = StringToInt( SQLGetData( 3 ) );

            if ( nPrice > 0 ){

                nPrice          = ds_j_GetResourcePrice( StringToInt( sResource ) );

                SetLocalInt( oMerchant, DS_J_BUY + sResource, 1 );

                if ( nIsSeller ){

                    SetLocalInt( oMerchant, DS_J_ID+IntToString( nCount ), StringToInt( sResource ) );
                    SetLocalString( oMerchant, DS_J_ID+IntToString( nCount ), SQLGetData( 4 ) );
                    SetLocalInt( oMerchant, DS_J_ICON+IntToString( nCount ), StringToInt( SQLGetData( 5 ) ) );
                }

                sDescription += "\n * "+sName + ": " + IntToString( nPrice )+" GP";
            }
            else {

                //SetLocalInt( oMerchant, SQLGetData( 4 ), 1 );
                SetLocalInt( oMerchant, DS_J_BUY + sResource, 1 );

                sDescription += "\n * "+sName + ": evaluate for price.";

                nCount = -1;
            }
        }

        SetLocalInt( oMerchant, DS_J_DONE, nCount );

        SetDescription( oMerchant, CLR_ORANGE+"Prices: "+CLR_END+sDescription );

        WriteTimestampedLogEntry( GetName( oMerchant )+";"+GetName(GetArea(oMerchant)));
    }
}

void ds_j_CustomiseTarget( object oNPC ){

    int nJob = GetLocalInt( oNPC, DS_J_JOB );
    int nDie = d8();
    int nModel;
    int nResource;

    if ( nJob == 50 ){

        string sName;
        object oPC = GetLocalObject( oNPC, DS_J_USER );

        switch ( GetLocalInt( oPC, DS_J_CRITTER ) ) {

            case 0:     nModel = 15; nResource = 0; sName = "Bear"; break;    //wyvernhide
            case 1:     nModel = 458; nResource = 218; sName = "Wyvern"; break;    //wyvernhide
            case 2:     nModel = APPEARANCE_TYPE_GOLEM_IRON; nResource = 219; sName = "Iron Golem"; break; //bone
            case 3:     nModel = APPEARANCE_TYPE_BASILISK; nResource = 220; sName = "Basilisk"; break;
            case 4:     nModel = 33; nResource = 221; sName = "Angered Satyr"; break;
            case 5:     nModel = APPEARANCE_TYPE_UMBERHULK; nResource = 222; sName = "Umber Hulk"; break;
            case 6:     nModel = APPEARANCE_TYPE_ETTERCAP; nResource = 223; sName = "Ettercap"; break;
            case 7:     nModel = APPEARANCE_TYPE_BEETLE_FIRE; nResource = 224; sName = "Fire Beetle"; break;
            case 8:     nModel = APPEARANCE_TYPE_GARGOYLE; nResource = 225; sName = "Gargoyle"; break;
        }

        SetCreatureAppearanceType( oNPC, nModel );

        SetLocalInt( oNPC, DS_J_RESOURCE, nResource );

        DeleteLocalInt( oPC, DS_J_CRITTER );

        SetName( oNPC, CLR_ORANGE + sName + CLR_END );
    }
    else if ( GetResRef( oNPC ) == "ds_j_critter" ){

        switch ( nDie ) {

            case 1:     nModel = APPEARANCE_TYPE_OGRE; break;
            case 2:     nModel = APPEARANCE_TYPE_SAHUAGIN; break;
            case 3:     nModel = APPEARANCE_TYPE_BUGBEAR_CHIEFTAIN_B; break;
            case 4:     nModel = APPEARANCE_TYPE_DOG_SHADOW_MASTIF; break;
            case 5:     nModel = APPEARANCE_TYPE_ETTIN; break;
            case 6:     nModel = APPEARANCE_TYPE_GIANT_MOUNTAIN; break;
            case 7:     nModel = APPEARANCE_TYPE_GORGON; break;
            case 8:     nModel = APPEARANCE_TYPE_GREY_RENDER; break;
        }

        SetCreatureAppearanceType( oNPC, nModel );
    }
    else if ( GetResRef( oNPC ) == "ds_j_undead" ){

        switch ( nDie ) {

            case 1:     nModel = APPEARANCE_TYPE_BODAK; nResource = 226; break;
            case 2:     nModel = APPEARANCE_TYPE_SKELETON_CHIEFTAIN; nResource = 227; break;
            case 3:     nModel = APPEARANCE_TYPE_GHOUL_LORD; break;
            case 4:     nModel = APPEARANCE_TYPE_SHADOW; break;
            case 5:     nModel = APPEARANCE_TYPE_SKELETON_MAGE; nResource = 227; break;
            case 6:     nModel = APPEARANCE_TYPE_SPECTRE; break;
            case 7:     nModel = APPEARANCE_TYPE_WIGHT; break;
            case 8:     nModel = APPEARANCE_TYPE_ZOMBIE_TYRANT_FOG; break;
        }

        SetLocalInt( oNPC, DS_J_RESOURCE, nResource );

        SetCreatureAppearanceType( oNPC, nModel );
    }
    else{

        //customise target
        if ( nDie < 3 ){

            //no sword + shield
            AssignCommand( oNPC, ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_LEFTHAND, oNPC ) ) );
            AssignCommand( oNPC, ActionUnequipItem( GetItemInSlot( INVENTORY_SLOT_RIGHTHAND, oNPC ) ) );
        }

        if ( d4() == 1 ){

            //helmet
            AssignCommand( oNPC, ActionEquipItem( GetItemPossessedBy( oNPC, "nw_arhe002" ), INVENTORY_SLOT_LEFTHAND ) );
        }
        else{

            //head+colour
            SetCreatureBodyPart( CREATURE_PART_HEAD, d10() );
            SetColor( oNPC, COLOR_CHANNEL_SKIN, d10() );
            SetColor( oNPC, COLOR_CHANNEL_HAIR, d20() );
        }

        int nDie = d6();

        //other suit
        if ( nDie == 1 ){

            AssignCommand( oNPC, ActionEquipItem( GetItemPossessedBy( oNPC, "X@_CLOTH008" ), INVENTORY_SLOT_CHEST ) );
        }
        else if ( nDie == 2 ){

            AssignCommand( oNPC, ActionEquipItem( GetItemPossessedBy( oNPC, "NW_CLOTH004" ), INVENTORY_SLOT_CHEST ) );
        }
        else if ( nDie == 3 ){

            AssignCommand( oNPC, ActionEquipItem( GetItemPossessedBy( oNPC, "NW_MAARCL007" ), INVENTORY_SLOT_CHEST ) );
        }
        else if ( nDie == 4 ){

            AssignCommand( oNPC, ActionEquipItem( GetItemPossessedBy( oNPC, "NW_MAARCL045" ), INVENTORY_SLOT_CHEST ) );
        }
    }
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oNPC     = OBJECT_SELF;
    string sTag     = GetTag( oNPC );
    float fDelay    = 2.0 + ( ( 5 + Random( 95 ) ) / 10.0 );

    if ( sTag == "ds_j_merchant" ){

        if ( GetLocalInt( oNPC, DS_J_JOB ) > 0 ){

            //initialise trainer
            DelayCommand( ( fDelay ), ds_j_InitialiseTrainer( oNPC ) );

            fDelay += 1.0;
        }

        //initialise merchant
        DelayCommand( fDelay, ds_j_InitialiseMerchant( oNPC ) );

    }
    else if ( sTag == DS_J_NPC || sTag == DS_J_CRITTER || sTag == DS_J_UNDEAD ){

        DelayCommand( 1.0, ds_j_CustomiseTarget( oNPC ) );
        DelayCommand( 300.0, ExecuteScript( "ds_j_cleanup", oNPC ) );
    }
    else{

        //initialise trainer
        DelayCommand( fDelay, ds_j_InitialiseTrainer( oNPC ) );
    }
}


