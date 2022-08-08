//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: i_ds_j_activate
//group:
//used as: item activation script
//date:
//author:


//-------------------------------------------------------------------------------
// changelog
//-------------------------------------------------------------------------------
// 08 March 2011 - Selmak amended ds_j_candle node in void main so that candles
//                 spawn in with their scribed description.
//               - Selmak amended cmbtdummy001 node in void ds_j_Furniture so
//                 combat dummies spawn in with their scribed name and description
// 18 July 2012  - Glim added the Wand Case to the job system
//               - Glim amended the Scroll Case to work with Blank Scrolls too
// 20 July 2012  - Glim removal of Enchanted Wands functionality for
//               - the wand cases due to charge issues
// 14 Aug  2012  - Glim added Flawless, Perfect and Divine options for Mythal Tube
// 7 July 2020   - Maverick00053 added a Trap case by popular demand

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"
#include "inc_ds_j_lib"
#include "X0_I0_SPELLS"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------
void ds_j_DrinkPotion( object oPC, object oItem );

//sets Alchemist's Essence Trap
void ds_j_SetEssenceTrap( object oPC, location lTarget, string sTag );

//spawns/removes an item with a tag based on the PCs name and an item prefix
void ds_j_SpawnItem( object oPC, object oItem, string sResRef, string sTagPrefix, location lTarget, string sName="", string sDescription="" );

void ds_j_Furniture( object oPC, object oTarget, location lTarget );

void ds_j_DoGrenadeDamage( object oTarget, effect ePrimary, effect eSecundary );

void ds_j_DoGrenade( object oTarget, effect ePrimary, effect eSecundary );

void ds_j_SetBackPack( object oPC, int nBackpack );

void ds_j_InitCloak( object oPC, object oItem, string sResRef );

void ds_j_StoreGem( object oPC, object oPouch, object oTarget );

void ds_j_CreateGem( object oPC, object oPouch );

void ds_j_GemPouch( object oPC, object oPouch, object oTarget );

void ds_j_StoreBandage( object oPC, object oBox, object oTarget );

void ds_j_CreateBandage( object oPC, object oBox );

void ds_j_BandageBox( object oPC, object oBox, object oTarget );

void ds_j_StoreMythal( object oPC, object oBox, object oTarget );

void ds_j_CreateMythal( object oPC, object oBox );

void ds_j_MythalBox( object oPC, object oBox, object oTarget );

void ds_j_StoreScroll( object oPC, object oPouch, object oTarget );

void ds_j_CreateScroll( object oPC, object oPouch );

void ds_j_ScrollBox( object oPC, object oPouch, object oTarget );

void ds_j_StoreWand( object oPC, object oBox, object oTarget );

void ds_j_CreateWand( object oPC, object oBox );

void ds_j_WandCase( object oPC, object oBox, object oTarget );

void ds_j_StoreTrap( object oPC, object oBox, object oTarget );

void ds_j_CreateTrap( object oPC, object oBox );

void ds_j_WandTrap( object oPC, object oBox, object oTarget );


void ds_j_Spawner( object oPC, object oItem, object oTarget, location lTarget );


void ds_j_Map( object oPC, object oMap ){

    //the module and area resref are coded into the tag
    string sTag     = GetTag( oMap );
    string sModule  = GetSubString( sTag, 9, 1 );
    string sResref  = GetSubString( sTag, 11, 100 );
    string sAccount = SQLEncodeSpecialChars( GetPCPlayerName( oPC ) );

    //make sure the area can be seen in the area list
    SQLExecDirect( "INSERT INTO player_areas VALUES ( '"+sAccount+"', '"+sResref+"', "+sModule+" )" );
}





void ds_j_CreateServant( object oPC, string sResRef ){

    object oNPC = CreateObject( OBJECT_TYPE_CREATURE, sResRef, GetLocation( oPC ), TRUE );

    SetLocalObject( oNPC, DS_J_USER, oPC );

    SetName( oNPC, GetName( oPC ) + "'s Servant" );
}




void ds_j_DrinkPotion( object oPC, object oItem ){

    int nResource = ds_j_GetResourceID( oPC, oItem );
    effect eEffect;

    //add quality modifier
    //Average = 6, btw
    int nQuality = ds_j_GetQualityFromItem( oItem );

    if ( nResource == 215 ){

        eEffect = EffectDamageImmunityIncrease( DAMAGE_TYPE_ELECTRICAL, 5 * ( nQuality - 4 ) );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPC, TurnsToSeconds( nQuality ) );
    }
    else if ( nResource == 216 ){

        eEffect = EffectDamageImmunityIncrease( DAMAGE_TYPE_ACID, 5 * ( nQuality - 4 ) );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPC, TurnsToSeconds( nQuality ) );
    }
    else if ( nResource == 217 ){

        eEffect = EffectDamageImmunityIncrease( DAMAGE_TYPE_FIRE, 5 * ( nQuality - 4 ) );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPC, TurnsToSeconds( nQuality ) );
    }
    else if ( nResource == 395 ){

        eEffect = EffectDamageImmunityIncrease( DAMAGE_TYPE_COLD, 5 * ( nQuality - 4 ) );

        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eEffect, oPC, TurnsToSeconds( nQuality ) );
    }
}


//sets Alchemist's Essence Trap
void ds_j_SetEssenceTrap( object oPC, location lTarget, string sTag ){

    object oTrap = CreateTrapAtLocation( TRAP_BASE_TYPE_MINOR_TANGLE, lTarget, 2.0, sTag, STANDARD_FACTION_DEFENDER, "", "ds_j_trap" );

    SetLocalObject( oTrap, DS_J_USER, oPC );

    SetTrapDetectDC( oTrap, 0 );
    SetTrapDetectedBy( oTrap, oPC );
    SetTrapDisarmable( oTrap, FALSE );
    SetTrapRecoverable( oTrap, FALSE );

    SetName( oTrap, "Essence Trap" );
}


//spawns/removes an item with a tag based on the PCs name and an item prefix
void ds_j_SpawnItem( object oPC, object oItem, string sResRef, string sTagPrefix, location lTarget, string sName="", string sDescription="" ){

    //create a tage for each object that consists of the PC name and the item
    //string sTag       = sTagPrefix + GetPCPublicCDKey( oPC );
    string sTag       = GetLocalString( oItem, "tag" );

    if ( sTag == "" ){

        //create and store new tag
        sTag = GetPCPublicCDKey( oPC ) + "_" + IntToString( GetCurrentSecond( ) );
        SetLocalString( oItem, "tag", sTag );
    }

    object oPlaceable = GetObjectByTag( sTag );

    if ( oPlaceable == OBJECT_INVALID ){

        object oNearestPC   = GetNearestCreature( CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, oPC );
        location lNearestPC = GetLocation( oNearestPC );
        location lPC        = GetLocation( oPC );

        //if a PC tries to place the item at his own feet
        if ( GetDistanceBetweenLocations( lTarget, lPC ) < 1.5 ){

            SendMessageToPC( oPC, CLR_RED+"You should not place this item on your own feet, my friend." );
        }
        //if a PC tries to place the item at another PC's feet
        else if ( GetDistanceBetweenLocations( lTarget, lNearestPC ) < 1.5 && oNearestPC != OBJECT_INVALID ){

            SendMessageToPC( oPC, CLR_RED+"You should not place this item on another person's feet, my friend." );
        }
        //create object
        else{

            object oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lTarget, FALSE, sTag );
            SetPlotFlag( oPLC, FALSE );

            SendMessageToPC( oPC, CLR_ORANGE+"Placed your prop. Use this item again to remove it." );

            if ( sName != "" ){

                SetName( oPLC, sName );
            }
            else{

                SetName( oPLC, GetName( oPC )+"'s "+GetName( oPLC ) );
            }

            if ( sDescription != "" ){

                SetDescription( oPLC, sDescription );
            }
        }
    }
    else{

        //no removal if somebody uses the chair/cushion
        if( GetIsPC( GetSittingCreature( oPlaceable ) ) ){

            SendMessageToPC( oPC, CLR_RED+"You cannot remove your "+GetName(oPlaceable)+". Somebody is sitting on it.");
        }
        //remove object
        else{

            SendMessageToPC( oPC, CLR_ORANGE+"You removed your "+GetName(oPlaceable)+"." );
            DestroyObject( oPlaceable );
        }
    }
}

void ds_j_Furniture( object oPC, object oTarget, location lTarget ){

    object oItem      = GetItemActivated();
    string sItemName  = GetName( oItem );
    int nResource     = ds_j_GetResourceID( oPC, oItem );

    if ( GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE ){

        SendMessageToPC( oPC, CLR_RED+"You cannot pile that on top of eachother, my friend." );
        return;
    }

    if ( GetObjectType( oTarget ) == OBJECT_TYPE_CREATURE ){

        SendMessageToPC( oPC, CLR_RED+"BEHAVE!" );
        return;
    }

    //check for spawntriggers
    if ( GetNearestObjectByTag( "ds_plc_blocker", oPC ) != OBJECT_INVALID ){

        SendMessageToPC( oPC, CLR_RED+"Oi, this is not a picnic area!" );
        return;
    }

    if ( nResource == 268 ){

        ds_j_SpawnItem( oPC, oItem, "chairuse004", "jp1_", lTarget );
    }
    else if ( nResource == 269 ){

        //drow table!
        ds_j_SpawnItem( oPC, oItem, "x2_plc_tabledrow", "jp2_", lTarget );
    }
    else if ( nResource == 270 ){

        //drow altar
        ds_j_SpawnItem( oPC, oItem, "x2_plc_drowaltar", "jp3_", lTarget );
    }
    else if ( nResource == 271 ){

        ds_j_SpawnItem( oPC, oItem, "tha_chair", "jp4_", lTarget );
    }
    else if ( nResource == 272 ){

        ds_j_SpawnItem( oPC, oItem, "tha_stool", "jp5_", lTarget );
    }
    else if ( nResource == 273 ){

        ds_j_SpawnItem( oPC, oItem, "bench001", "jp6_", lTarget );
    }
    else if ( nResource == 274 ){

        ds_j_SpawnItem( oPC, oItem, "plc_table", "jp7_", lTarget );
    }
    else if ( nResource == 275 ){

        //couch
        ds_j_SpawnItem( oPC, oItem, "bench002", "jp8_", lTarget );
    }
    else if ( nResource == 276 ){

        ds_j_SpawnItem( oPC, oItem, "plc_bed", "jp9_", lTarget );
    }
    else if ( nResource == 277 ){

        //throne
        ds_j_SpawnItem( oPC, oItem, "custom_plc_022", "jp10_", lTarget );
    }
    else if ( nResource == 278 ){

        ds_j_SpawnItem( oPC, oItem, "x2_plc_mirror", "jp11_", lTarget );
    }
    else if ( nResource == 481 ){

        ds_j_SpawnItem( oPC, oItem, "cmbtdummy001", "jp20_", lTarget, sItemName, GetDescription( oItem ) );
    }
    else if ( GetResRef( oItem ) == "ds_j_painting" ){

        ds_j_SpawnItem( oPC, oItem, "ds_j_easel", "jp14_", lTarget, sItemName, GetDescription( oItem ) );
    }
    else if ( GetResRef( oItem ) == "ds_furniture_20" ){

        ds_j_SpawnItem( oPC, oItem, "plc_throwrug", "jp15_", lTarget, sItemName );
    }
    else if ( GetResRef( oItem ) == "ds_furniture_17" ){

        ds_j_SpawnItem( oPC, oItem, "x0_ruglarge", "jp16_", lTarget, sItemName );
    }
    else if ( GetResRef( oItem ) == "ds_furniture_19" ){

        ds_j_SpawnItem( oPC, oItem, "x0_roundrugorien", "jp17_", lTarget, sItemName );
    }
    else if ( GetResRef( oItem ) == "ds_furniture_20" ){

        ds_j_SpawnItem( oPC, oItem, "x0_rugoriental2", "jp18_", lTarget, sItemName );
    }
    else if ( GetResRef( oItem ) == "ds_furniture_21" ){

        ds_j_SpawnItem( oPC, oItem, "x0_rugoriental", "jp19_", lTarget, sItemName );
    }
}

void ds_j_DoGrenadeDamage( object oTarget, effect ePrimary, effect eSecundary ){

    object oPC        = OBJECT_SELF;
    location lTarget  = GetLocation( oTarget );
    effect eVis       = EffectVisualEffect( VFX_COM_BLOOD_CRT_GREEN );

    // * Splash damage always happens as well now
    effect eExplode = EffectVisualEffect( 193 );

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget );

    object oSplashTarget = GetFirstObjectInShape( SHAPE_SPHERE, 5.0, lTarget, TRUE );

    //Cycle through the targets within the spell shape until an invalid object is captured.
    while ( GetIsObjectValid( oSplashTarget ) ){

        //if ( GetIsReactionTypeHostile( oSplashTarget, oPC ) ) {

            float fDelay = GetDistanceBetweenLocations( lTarget, GetLocation( oSplashTarget ) ) / 20;

            SignalEvent( oSplashTarget, EventSpellCastAt( OBJECT_SELF, 467 ) );

            if ( ReflexSave( oSplashTarget, 25 ) == 0 ){

                DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePrimary, oSplashTarget, RoundsToSeconds( d6() ) ) );
                DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSecundary, oSplashTarget, RoundsToSeconds( d6() ) ) );
                DelayCommand( fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSplashTarget ) );
            }

        //}

       //Select the next target within the spell shape.
       oSplashTarget = GetNextObjectInShape( SHAPE_SPHERE, 5.0, lTarget, TRUE );
    }
}

void ds_j_DoGrenade( object oTarget, effect ePrimary, effect eSecundary ){

    if ( GetIsObjectValid( oTarget ) != TRUE ){

        oTarget = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_j_target", GetItemActivatedTargetLocation() );

        DestroyObject( oTarget, 3.0 );
    }

    float fDist       = GetDistanceBetween( OBJECT_SELF, oTarget );
    float fDelay      = fDist / ( 3.0 * log( fDist ) + 2.0 );
    effect eThrow     = EffectVisualEffect( 359 );

    ApplyEffectToObject( DURATION_TYPE_INSTANT, eThrow, oTarget );

    DelayCommand( fDelay, ds_j_DoGrenadeDamage( oTarget, ePrimary, eSecundary ) );
}


void ds_j_SetBackPack( object oPC, int nBackpack ){

    int nCurrent  = GetCreatureWingType( oPC );
    int nVariant  = nBackpack + 1;

    if (( nCurrent > 0 && nCurrent < 79 )|| ( nCurrent > 90 && nCurrent < 112 )){

        SendMessageToPC( oPC, "You can't use this item if you have wings." );
        return;
    }

    if ( nCurrent == nBackpack && nCurrent  < 112 ){

        SetCreatureWingType( nVariant, oPC );
    }
    else if (( nCurrent == nVariant ) || ( nCurrent > 112 && nCurrent < 121 )) {

        SetCreatureWingType( 0, oPC );
    }
    else {

        SetCreatureWingType( nBackpack, oPC );
    }
}

void ds_j_InitCloak( object oPC, object oItem, string sResRef ){

    int nCurrent = GetCreatureBodyPart( CREATURE_PART_HEAD, oPC );
    int    nAlt;

    // Test if tool has been activated
    if ( !GetLocalInt( oItem, "done" ) ) {

        if ( GetIsPolymorphed( oPC ) ){

            SendMessageToPC( oPC, "You are polymorphed!" );
            return;
        }

        // Test Male(1)/Female(2) (M=True). also check skin
        int nSkin = GetAppearanceType( oPC );

        if ( nSkin == 5 || nSkin > 6 ){

            SendMessageToPC( oPC, "You can't use this item on your race!" );
            return;
        }

        // Assign new base head using current head
        SetLocalInt( oItem, "basehead", nCurrent );

        int nSex  = GetGender( oPC );

        if ( sResRef == "ds_j_hooded" ){

            if  ( nSex == 0 ) {

                // Use skin to choose appropriate head via Switch
                switch ( nSkin )  {

                    case 0: nAlt = 18; break;
                    case 1: nAlt = 24; break;
                    case 2: nAlt = 14; break;
                    case 3: nAlt = 11; break;
                    case 4: nAlt = 2; break;
                    case 6: nAlt = 2; break;
                    default: /* No change; race does not have cowled head */ break;
                }
            }
            else {

                switch ( nSkin ) {

                    case 0: nAlt = 14; break;
                    case 1: nAlt = 33; break;
                    case 2: nAlt = 5; break;
                    case 3: nAlt = 9; break;
                    case 4: nAlt = 12; break;
                    case 6: nAlt = 12; break;
                    default: break; /* No change; race does not have cowled head */
                }
            }
        }
        else{

            if  ( nSex == 0 ) {

                // Use skin to choose appropriate head via Switch
                switch ( nSkin )  {

                    case 1: nAlt = 15; break;
                    case 2: nAlt = 17; break;
                    case 3: nAlt = 09; break;
                    case 4: nAlt = 41; break;
                    case 6: nAlt = 41; break;
                    default: /* No change; race does not have cowled head */ break;
                }
            }
            else {

                switch ( nSkin ) {

                    case 1: nAlt = 14; break;
                    case 3: nAlt = 10; break;
                    case 4: nAlt = 105; break;
                    case 6: nAlt = 105; break;
                    default: break; /* No change; race does not have cowled head */
                }
            }
        }

        if ( nAlt ){

            SetLocalInt( oItem, "althead", nAlt );

            SetLocalInt( oItem, "done", 1 );

            IPRemoveMatchingItemProperties( oItem, ITEM_PROPERTY_CAST_SPELL, DURATION_TYPE_PERMANENT );

            SetItemCursedFlag( oItem, TRUE );

            ExportSingleCharacter( oPC );
        }
        else{

            SendMessageToPC( oPC, "There's no valid alternative head for this race." );
        }
    }
}

void ds_j_StoreGem( object oPC, object oPouch, object oTarget ){

    string sResRef = GetDescription( oPouch, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );
    int nCharges   = StringToInt( GetSubString( GetDescription( oPouch ), 16, 6 ) );
    string sName   = GetName( oTarget );

    if ( GetStringLeft( sResRef, 9 ) != "nw_it_gem" ){

        SetDescription( oPouch, sTarget, FALSE );

        sResRef = sTarget;

        string sPouch = "";

        if ( sName == "Ruby" ){

            sPouch = "Pouch filled with Rubies";
        }
        else if ( sName == "Topaz" ){

            sPouch = "Pouch filled with Topazes";
        }
        else{

            sPouch = "Pouch filled with "+sName+"s";
        }

        SendMessageToPC( oPC, CLR_ORANGE+"Dedicating your gem pouch to "+sName+"." );

        SetName( oPouch, CLR_ORANGE+sPouch+CLR_END );
    }

    if ( sTarget != sResRef ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store "+sName+" in this pouch." );

        return;
    }

    SendMessageToPC( oPC, CLR_ORANGE+"Storing a (stack of) "+sName+"." );

    SetDescription( oPouch, "Number of gems: "+IntToString( nCharges + GetNumStackedItems( oTarget ) ) );

    DestroyObject( oTarget, 1.0 );
}

void ds_j_CreateGem( object oPC, object oPouch ){

    string sResRef = GetDescription( oPouch, FALSE, FALSE );
    int nCharges   = StringToInt( GetSubString( GetDescription( oPouch ), 16, 6 ) );

    if ( GetStringLeft( sResRef, 9 ) == "nw_it_gem" ){

        if ( nCharges > 1 ){

            SetDescription( oPouch, "Number of gems: "+IntToString( nCharges - 1 ) );
        }
        else if ( nCharges == 1 ){

            SetDescription( oPouch, "This pouch is empty." );

            SetName( oPouch, CLR_ORANGE+"Gem Pouch"+CLR_END );

            SetDescription( oPouch, "-", FALSE );
        }
        else{

            SendMessageToPC( oPC, CLR_RED+"You cannot create a gem from this bag because it is empty." );

            return;
        }

        SendMessageToPC( oPC, CLR_ORANGE+"Creating a gem..." );

        CreateItemOnObject( sResRef, oPC );
    }
    else{

        SendMessageToPC( oPC, CLR_RED+"You cannot create a gem from this bag because it has not been dedicated to a type of gem." );
    }
}

void ds_j_GemPouch( object oPC, object oPouch, object oTarget ){

    string sResRef = GetDescription( oPouch, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );

    if ( GetStringLeft( sTarget, 9 ) == "nw_it_gem" && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        ds_j_StoreGem( oPC, oPouch, oTarget );
    }
    else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        if ( sResRef == "" ){

            SendMessageToPC( oPC, CLR_RED+"You need to dedicate this pouch to a gem type before you can use it on a container." );

            return;
        }

        object oInContainer = GetFirstItemInInventory( oTarget );

        while ( GetIsObjectValid( oInContainer ) == TRUE ){

            if ( GetStringLeft( GetResRef( oInContainer ), 9 ) == "nw_it_gem" ){

                ds_j_StoreGem( oPC, oPouch, oInContainer );
            }

            oInContainer = GetNextItemInInventory( oTarget );
        }
    }
    else if ( oTarget == oPC ){

        ds_j_CreateGem( oPC, oPouch );
    }
    else{

        //invalid target
        SendMessageToPC( oPC, CLR_RED+"This is not a valid target for this widget. You can use it on yourself, gems, or storage containers." );
    }
}

void ds_j_StoreBandage( object oPC, object oBox, object oTarget ){

    string sResRef = GetDescription( oBox, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );
    int nCharges   = StringToInt( GetSubString( GetDescription( oBox ), 20, 6 ) );
    string sName   = GetName( oTarget );

    if ( FindSubString( sResRef, "it_medkit" ) == -1 ){

        SetDescription( oBox, sTarget, FALSE );

        sResRef = sTarget;

        string sbox = sName+" Bag";

        SendMessageToPC( oPC, CLR_ORANGE+"Dedicating your bandage bag to "+sName+"." );

        SetName( oBox, CLR_ORANGE+sbox+CLR_END );
    }

    if ( sTarget != sResRef ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store "+sName+" in this bag." );

        return;
    }

    int nNewCharges = nCharges + GetNumStackedItems( oTarget );

    if ( nNewCharges > 100 ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store more than 100 bandages in this bag." );

        return;
    }

    if ( ( nCharges < 80 && nNewCharges >= 80 ) ||
         ( nCharges < 60 && nNewCharges >= 60 ) ||
         ( nCharges < 40 && nNewCharges >= 40 ) ||
         ( nCharges < 20 && nNewCharges >= 20 ) ){

        itemproperty ipWeight;

        if ( GetResRef( oBox ) == "ds_j_bandagebag" ){

            //magical bag gets 50% weight decrease
            ipWeight = ItemPropertyWeightIncrease( IP_CONST_WEIGHTINCREASE_5_LBS );
        }
        else{

            ipWeight = ItemPropertyWeightIncrease( IP_CONST_WEIGHTINCREASE_10_LBS );
        }

        IPSafeAddItemProperty( oBox, ipWeight, 0.0f, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
    }

    SendMessageToPC( oPC, CLR_ORANGE+"Storing a (stack of) bandages." );

    SetDescription( oBox, "Number of bandages: "+IntToString( nNewCharges ) );

    DestroyObject( oTarget, 1.0 );
}

void ds_j_CreateBandage( object oPC, object oBox ){

    string sResRef = GetDescription( oBox, FALSE, FALSE );
    int nCharges   = StringToInt( GetSubString( GetDescription( oBox ), 20, 6 ) );
    int nNewCharges;
    int nBatch     = 1;

    if ( FindSubString( sResRef, "it_medkit" ) > -1 ){

        if ( nCharges > 6 ){

            nBatch      = 5;
            nNewCharges = nCharges - nBatch;
        }
        else if ( nCharges > 1 ){

            nNewCharges = nCharges - nBatch;
        }
        else if ( nCharges == 1 ){

            SetDescription( oBox, "This bag is empty." );

            SetName( oBox, CLR_ORANGE+"Bandage bag"+CLR_END );

            SetDescription( oBox, "-", FALSE );
        }
        else{

            SendMessageToPC( oPC, CLR_RED+"You cannot create a bandage from this bag because it is empty." );

            return;
        }

        SetDescription( oBox, "Number of bandages: "+IntToString( nNewCharges ) );

        if ( ( nCharges >= 80 && nNewCharges < 80 ) ||
             ( nCharges >= 60 && nNewCharges < 60 ) ||
             ( nCharges >= 40 && nNewCharges < 40 ) ||
             ( nCharges >= 20 && nNewCharges < 20 ) ){

            itemproperty ipLoop = GetFirstItemProperty( oBox );

            //Loop for as long as the ipLoop variable is valid
            while ( GetIsItemPropertyValid( ipLoop ) ){

                //If ipLoop is a true seeing property, remove it
                if ( GetItemPropertyType( ipLoop ) == ITEM_PROPERTY_WEIGHT_INCREASE ){

                    RemoveItemProperty( oBox, ipLoop );

                    break;
                }

                //Next itemproperty on the list...
                ipLoop = GetNextItemProperty( oBox );
            }
        }

        SendMessageToPC( oPC, CLR_ORANGE+"Creating "+IntToString( nBatch )+" bandage(s)..." );

        CreateItemOnObject( sResRef, oPC, nBatch );
    }
    else{

        SendMessageToPC( oPC, CLR_RED+"You cannot create a bandage from this bag because it has not been dedicated to a type of bandage." );
    }
}

void ds_j_BandageBox( object oPC, object oBox, object oTarget ){

    string sResRef = GetDescription( oBox, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );

    if ( FindSubString( sTarget, "it_medkit" ) > -1 && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        ds_j_StoreBandage( oPC, oBox, oTarget );
    }
    else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        if ( sResRef == "" ){

            SendMessageToPC( oPC, CLR_RED+"You need to dedicate this bag to a bandage type before you can use it on a container." );

            return;
        }

        object oInContainer = GetFirstItemInInventory( oTarget );

        while ( GetIsObjectValid( oInContainer ) == TRUE ){

            if ( FindSubString( GetResRef( oInContainer ), "it_medkit" ) > -1  ){

                ds_j_StoreBandage( oPC, oBox, oInContainer );
            }

            oInContainer = GetNextItemInInventory( oTarget );
        }
    }
    else if ( oTarget == oPC ){

        ds_j_CreateBandage( oPC, oBox );
    }
    else{

        //invalid target
        SendMessageToPC( oPC, CLR_RED+"This is not a valid target for this widget. You can use it on yourself, healing kits, or storage containers." );
    }
}

void ds_j_StoreMythal( object oPC, object oBox, object oTarget ){

    string sResRef = GetDescription( oBox, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );
    int nCharges   = StringToInt( GetSubString( GetDescription( oBox ), 19, 6 ) );
    string sName   = GetName( oTarget );

    if ( FindSubString( sResRef, "mythal" ) == -1 ){

        SetDescription( oBox, sTarget, FALSE );

        sResRef = sTarget;

        string sbox = sName+" Tube";

        SendMessageToPC( oPC, CLR_ORANGE+"Dedicating your mythal tube to "+sName+"." );

        SetName( oBox, CLR_ORANGE+sbox+CLR_END );
    }

    if ( sTarget != sResRef ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store "+sName+" in this tube." );

        return;
    }

    int nNewCharges = nCharges + GetNumStackedItems( oTarget );

    if ( nNewCharges > 50 ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store more than 50 mythals in this tube." );

        return;
    }

    if ( ( nCharges < 40 && nNewCharges >= 40 ) ||
         ( nCharges < 30 && nNewCharges >= 30 ) ||
         ( nCharges < 20 && nNewCharges >= 20 ) ||
         ( nCharges < 10 && nNewCharges >= 10 ) ){

        itemproperty ipWeight;

        if ( sTarget == "mythal1" ){

            ipWeight = ItemPropertyWeightIncrease( IP_CONST_WEIGHTINCREASE_5_LBS );
        }
        else if ( sTarget == "mythal2" ){

            ipWeight = ItemPropertyWeightIncrease( IP_CONST_WEIGHTINCREASE_5_LBS );
        }
        else if ( sTarget == "mythal3" ) {

            ipWeight = ItemPropertyWeightIncrease( IP_CONST_WEIGHTINCREASE_10_LBS );
        }
        else if ( sTarget == "mythal4" ) {

            ipWeight = ItemPropertyWeightIncrease( IP_CONST_WEIGHTINCREASE_15_LBS );
        }
        else if ( sTarget == "mythal5" ) {

            ipWeight = ItemPropertyWeightIncrease( IP_CONST_WEIGHTINCREASE_30_LBS );
        }
        else if ( sTarget == "mythal6" ) {

            ipWeight = ItemPropertyWeightIncrease( IP_CONST_WEIGHTINCREASE_50_LBS );
        }
        else {

            ipWeight = ItemPropertyWeightIncrease( IP_CONST_WEIGHTINCREASE_100_LBS );
        }

        IPSafeAddItemProperty( oBox, ipWeight, 0.0f, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING );
    }

    SendMessageToPC( oPC, CLR_ORANGE+"Storing mythal." );

    SetDescription( oBox, "Number of mythals: "+IntToString( nNewCharges ) );

    DestroyObject( oTarget, 1.0 );
}

void ds_j_CreateMythal( object oPC, object oBox ){

    string sResRef = GetDescription( oBox, FALSE, FALSE );
    int nCharges   = StringToInt( GetSubString( GetDescription( oBox ), 19, 6 ) );
    int nNewCharges;

    if ( FindSubString( sResRef, "mythal" ) > -1 ){

        if ( nCharges > 1 ){

            nNewCharges = nCharges - 1;
        }
        else if ( nCharges == 1 ){

            SetDescription( oBox, "This tube is empty." );

            SetName( oBox, CLR_ORANGE+"Mythal Tube"+CLR_END );

            SetDescription( oBox, "-", FALSE );
        }
        else{

            SendMessageToPC( oPC, CLR_RED+"You cannot create a mythal from this tube because it is empty." );

            return;
        }

        SetDescription( oBox, "Number of mythals: "+IntToString( nNewCharges ) );

        if ( ( nCharges >= 40 && nNewCharges < 40 ) ||
             ( nCharges >= 30 && nNewCharges < 30 ) ||
             ( nCharges >= 20 && nNewCharges < 20 ) ||
             ( nCharges >= 10 && nNewCharges < 10 ) ){

            itemproperty ipLoop = GetFirstItemProperty( oBox );

            //Loop for as long as the ipLoop variable is valid
            while ( GetIsItemPropertyValid( ipLoop ) ){

                //If ipLoop is a true seeing property, remove it
                if ( GetItemPropertyType( ipLoop ) == ITEM_PROPERTY_WEIGHT_INCREASE ){

                    RemoveItemProperty( oBox, ipLoop );

                    break;
                }

                //Next itemproperty on the list...
                ipLoop = GetNextItemProperty( oBox );
            }
        }

        SendMessageToPC( oPC, CLR_ORANGE+"Creating a mythal..." );

        CreateItemOnObject( sResRef, oPC );
    }
    else{

        SendMessageToPC( oPC, CLR_RED+"You cannot create a mythal from this tube because it has not been dedicated to a type of mythal." );
    }
}

void ds_j_MythalBox( object oPC, object oBox, object oTarget ){

    string sResRef = GetDescription( oBox, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );

    if ( ( sTarget == "mythal1" || sTarget == "mythal2" || sTarget == "mythal3" || sTarget == "mythal4" || sTarget == "mythal5" || sTarget == "mythal6" || sTarget == "mythal7" )
        && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        ds_j_StoreMythal( oPC, oBox, oTarget );
    }
    else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        if ( sResRef == "" ){

            SendMessageToPC( oPC, CLR_RED+"You need to dedicate this tube to a mythal type before you can use it on a container." );

            return;
        }

        object oInContainer = GetFirstItemInInventory( oTarget );

        while ( GetIsObjectValid( oInContainer ) == TRUE ){

            sTarget = GetResRef( oInContainer );

            if ( sTarget == "mythal1" || sTarget == "mythal2" || sTarget == "mythal3" || sTarget == "mythal4" || sTarget == "mythal5" || sTarget == "mythal6" || sTarget == "mythal7" ){

                ds_j_StoreMythal( oPC, oBox, oInContainer );
            }

            oInContainer = GetNextItemInInventory( oTarget );
        }
    }
    else if ( oTarget == oPC ){

        ds_j_CreateMythal( oPC, oBox );
    }
    else{

        //invalid target
        SendMessageToPC( oPC, CLR_RED+"This is not a valid target for this widget. You can use it on yourself, mythals, or storage containers." );
    }
}

void ds_j_StoreScroll( object oPC, object oPouch, object oTarget ){

    string sResRef = GetDescription( oPouch, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );
    int nCharges   = StringToInt( GetSubString( GetDescription( oPouch ), 18, 6 ) );
    string sName   = GetName( oTarget );

    if ( sResRef == "" || sResRef == "-" ){

        SetDescription( oPouch, sTarget, FALSE );

        sResRef = sTarget;

        string sPouch =  "Scroll Holder: "+sName;

        SendMessageToPC( oPC, CLR_ORANGE+"Dedicating your scroll holder to "+sName+"." );

        SetName( oPouch, CLR_ORANGE+sPouch+CLR_END );
    }

    if ( sTarget != sResRef ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store "+sName+" in this holder." );

        return;
    }

    int nNewCharges = nCharges + GetNumStackedItems( oTarget );

    if ( nNewCharges > 50 ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store more than 50 scrolls in this holder." );
        return;
    }

    SendMessageToPC( oPC, CLR_ORANGE+"Storing a (stack of) "+sName+"." );

    SetDescription( oPouch, "Number of scrolls: "+IntToString( nCharges + GetNumStackedItems( oTarget ) ) );

    DestroyObject( oTarget, 1.0 );
}

void ds_j_CreateScroll( object oPC, object oPouch ){

    string sResRef      = GetDescription( oPouch, FALSE, FALSE );
    int nCharges        = StringToInt( GetSubString( GetDescription( oPouch ), 18, 6 ) );
    int nBatch          = 1;
    string sPouch       = GetName( oPouch, FALSE);

    if ( sResRef != "" && sResRef != "-" ){

        if ( nCharges > 11 && sResRef != "x2_it_cfm_bscrl" ){

            nBatch      = 10;
            SetDescription( oPouch, "Number of scrolls: "+IntToString( nCharges - nBatch ) );
        }
        else if ( nCharges > 1 ){

            SetDescription( oPouch, "Number of scrolls: "+IntToString( nCharges - nBatch ) );
        }
        else if ( nCharges == 1 ){

            SetDescription( oPouch, "This holder is empty." );

            SetName( oPouch, CLR_ORANGE+"Scroll Holder"+CLR_END );

            SetDescription( oPouch, "-", FALSE );
        }
        else{

            SendMessageToPC( oPC, CLR_RED+"You cannot create a scroll from this holder because it is empty." );

            return;
        }

        SendMessageToPC( oPC, CLR_ORANGE+"Creating a scroll..." );

        CreateItemOnObject( sResRef, oPC, nBatch );
    }
    else{

        SendMessageToPC( oPC, CLR_RED+"You cannot create a scroll from this holder because it has not been dedicated to a type of scroll." );
    }
}

void ds_j_ScrollBox( object oPC, object oPouch, object oTarget ){

    string sResRef = GetDescription( oPouch, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );

    if ( GetBaseItemType( oTarget ) == BASE_ITEM_SPELLSCROLL || GetBaseItemType( oTarget ) == BASE_ITEM_BLANK_SCROLL){

        ds_j_StoreScroll( oPC, oPouch, oTarget );
    }
    else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        if ( sResRef == "" ){

            SendMessageToPC( oPC, CLR_RED+"You need to dedicate this holder to a scroll type before you can use it on a container." );

            return;
        }

        object oInContainer = GetFirstItemInInventory( oTarget );

        while ( GetIsObjectValid( oInContainer ) == TRUE ){

            if ( GetBaseItemType( oInContainer ) == BASE_ITEM_SPELLSCROLL || GetBaseItemType( oTarget ) == BASE_ITEM_BLANK_SCROLL){

                ds_j_StoreScroll( oPC, oPouch, oInContainer );
            }

            oInContainer = GetNextItemInInventory( oTarget );
        }
    }
    else if ( oTarget == oPC ){

        ds_j_CreateScroll( oPC, oPouch );
    }
    else{

        //invalid target
        SendMessageToPC( oPC, CLR_RED+"This is not a valid target for this widget. You can use it on yourself, scrolls, or storage containers." );
    }
}

void ds_j_StoreWand( object oPC, object oPouch, object oTarget ){

    string sResRef = GetDescription( oPouch, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );
    int nCharges   = StringToInt( GetSubString( GetDescription( oPouch ), 16, 6 ) );
    string sName   = GetName( oTarget );

    if ( sResRef == "" || sResRef == "-" ){

        SetDescription( oPouch, sTarget, FALSE );

        sResRef = sTarget;

        string sPouch =  "Wand Case: "+sName;

        SendMessageToPC( oPC, CLR_ORANGE+"Dedicating your wand case to "+sName+"." );

        SetName( oPouch, CLR_ORANGE+sPouch+CLR_END );
    }

    if ( sTarget != sResRef ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store "+sName+" in this case." );

        return;
    }

    int nNewCharges = nCharges + GetNumStackedItems( oTarget );

    if ( nNewCharges > 50 ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store more than 50 wands in this case." );
        return;
    }

    SendMessageToPC( oPC, CLR_ORANGE+"Storing a "+sName+"." );

    SetDescription( oPouch, "Number of wands: "+IntToString( nCharges + GetNumStackedItems( oTarget ) ) );

    DestroyObject( oTarget, 1.0 );
}

void ds_j_CreateWand( object oPC, object oPouch ){

    string sResRef      = GetDescription( oPouch, FALSE, FALSE );
    int nCharges        = StringToInt( GetSubString( GetDescription( oPouch ), 16, 6 ) );
    int nBatch          = 1;
    string sPouch       = GetName( oPouch, FALSE);

    if ( sResRef != "" && sResRef != "-" ){

        if ( nCharges > 1 ){

            SetDescription( oPouch, "Number of wands: "+IntToString( nCharges - nBatch ) );
        }
        else if ( nCharges == 1 ){

            SetDescription( oPouch, "This case is empty." );

            SetName( oPouch, CLR_ORANGE+"Wand Case"+CLR_END );

            SetDescription( oPouch, "-", FALSE );
        }
        else{

            SendMessageToPC( oPC, CLR_RED+"You cannot create a wand from this case because it is empty." );

            return;
        }

        SendMessageToPC( oPC, CLR_ORANGE+"Creating a wand..." );

        CreateItemOnObject( sResRef, oPC, nBatch );
    }
    else{

        SendMessageToPC( oPC, CLR_RED+"You cannot create a wand from this case because it has not been dedicated to a type of wand." );
    }
}

void ds_j_WandCase( object oPC, object oPouch, object oTarget ){

    string sResRef = GetDescription( oPouch, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );

    if (GetBaseItemType( oTarget ) == BASE_ITEM_BLANK_WAND){

        ds_j_StoreWand( oPC, oPouch, oTarget );
    }
    else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        if ( sResRef == "" ){

            SendMessageToPC( oPC, CLR_RED+"You need to dedicate this case to a wand type before you can use it on a container." );

            return;
        }

        object oInContainer = GetFirstItemInInventory( oTarget );

        while ( GetIsObjectValid( oInContainer ) == TRUE ){

            if (GetBaseItemType( oTarget ) == BASE_ITEM_BLANK_WAND){

                ds_j_StoreWand( oPC, oPouch, oInContainer );
            }

            oInContainer = GetNextItemInInventory( oTarget );
        }
    }
    else if ( oTarget == oPC ){

        ds_j_CreateWand( oPC, oPouch );
    }
    else{

        //invalid target
        SendMessageToPC( oPC, CLR_RED+"This is not a valid target for this widget. You can use it on yourself, wands, or storage containers." );
    }
}

void ds_j_StoreTrap( object oPC, object oPouch, object oTarget ){

    string sResRef = GetDescription( oPouch, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );
    int nCharges   = StringToInt( GetSubString( GetDescription( oPouch ), 16, 6 ) );
    string sName   = GetName( oTarget );

    if ( sResRef == "" || sResRef == "-" ){

        SetDescription( oPouch, sTarget, FALSE );

        sResRef = sTarget;

        string sPouch =  "Trap Case: "+sName;

        SendMessageToPC( oPC, CLR_ORANGE+"Dedicating your trap case to "+sName+"." );

        SetName( oPouch, CLR_ORANGE+sPouch+CLR_END );
    }

    if ( sTarget != sResRef ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store "+sName+" in this case." );

        return;
    }

    int nNewCharges = nCharges + GetNumStackedItems( oTarget );

    if ( nNewCharges > 20 ){

        SendMessageToPC( oPC, CLR_RED+"You cannot store more than 20 traps in this case." );
        return;
    }

    SendMessageToPC( oPC, CLR_ORANGE+"Storing a "+sName+"." );

    SetDescription( oPouch, "Number of trap: "+IntToString( nCharges + GetNumStackedItems( oTarget ) ) );

    DestroyObject( oTarget, 1.0 );
}

void ds_j_CreateTrap( object oPC, object oPouch ){

    string sResRef      = GetDescription( oPouch, FALSE, FALSE );
    int nCharges        = StringToInt( GetSubString( GetDescription( oPouch ), 16, 6 ) );
    int nBatch          = 1;
    string sPouch       = GetName( oPouch, FALSE);

    if ( sResRef != "" && sResRef != "-" ){

        if ( nCharges > 1 ){

            SetDescription( oPouch, "Number of traps: "+IntToString( nCharges - nBatch ) );
        }
        else if ( nCharges == 1 ){

            SetDescription( oPouch, "This case is empty." );

            SetName( oPouch, CLR_ORANGE+"Trap Case"+CLR_END );

            SetDescription( oPouch, "-", FALSE );
        }
        else{

            SendMessageToPC( oPC, CLR_RED+"You cannot create a trap from this case because it is empty." );

            return;
        }

        SendMessageToPC( oPC, CLR_ORANGE+"Creating a trap..." );

        object lastTrap = CreateItemOnObject( sResRef, oPC, nBatch );
        SetIdentified( lastTrap, 1);
    }
    else{

        SendMessageToPC( oPC, CLR_RED+"You cannot create a trap from this case because it has not been dedicated to a type of wand." );
    }
}

void ds_j_TrapCase( object oPC, object oPouch, object oTarget ){

    string sResRef = GetDescription( oPouch, FALSE, FALSE );
    string sTarget = GetResRef( oTarget );

    if (GetBaseItemType( oTarget ) == BASE_ITEM_TRAPKIT){

        ds_j_StoreTrap( oPC, oPouch, oTarget );
    }
    else if ( GetHasInventory( oTarget ) && GetObjectType( oTarget ) == OBJECT_TYPE_ITEM ){

        if ( sResRef == "" ){

            SendMessageToPC( oPC, CLR_RED+"You need to dedicate this case to a wand type before you can use it on a container." );

            return;
        }

        object oInContainer = GetFirstItemInInventory( oTarget );

        while ( GetIsObjectValid( oInContainer ) == TRUE ){

            if (GetBaseItemType( oTarget ) == BASE_ITEM_TRAPKIT){

                ds_j_StoreTrap( oPC, oPouch, oInContainer );
            }

            oInContainer = GetNextItemInInventory( oTarget );
        }
    }
    else if ( oTarget == oPC ){

        ds_j_CreateTrap( oPC, oPouch );
    }
    else{

        //invalid target
        SendMessageToPC( oPC, CLR_RED+"This is not a valid target for this widget. You can use it on yourself, wands, or storage containers." );
    }
}


void ds_j_Spawner( object oPC, object oItem, object oTarget, location lTarget ){

    string sName   = GetName( oItem );
    string sResRef = GetDescription( oItem, FALSE, FALSE );
    object oPLC;

    if ( sName != " Job System Converter" ){

        oPLC = GetLocalObject( oPC, "ds_j_plc" );

        if ( GetIsObjectValid( oPLC ) ){

            DestroyObject( oPLC );

            DeleteLocalObject( oPC, "ds_j_plc" );
        }
        else{

            oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lTarget );

            SetLocalObject( oPC, "ds_j_plc", oPLC );
        }
    }
    else if ( sName != " Portable Shop" ){

        oPLC = GetLocalObject( oPC, "ds_j_plc" );

        if ( GetIsObjectValid( oPLC ) ){

            DestroyObject( oPLC );

            DeleteLocalObject( oPC, "ds_j_plc" );
        }
        else{

            oPLC = CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lTarget );

            SetLocalObject( oPC, "ds_j_plc", oPLC );
        }
    }
    else if ( GetObjectType( oTarget ) == OBJECT_TYPE_PLACEABLE ){

        SetDescription( oItem, GetResRef( oTarget ), FALSE );

        SetName( oItem, GetName( oTarget ) );
    }
}


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    //event variables
    int nEvent  = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;
    object oPC;
    object oItem;
    string sResRef;
    object oTarget;
    int    nBase;
    int    nCurrent;
    int    nAlt;
    location lTarget;
    object oPLC1;
    object oPLC2;

    switch ( nEvent ){

        case X2_ITEM_EVENT_ACTIVATE:

            // item activate variables
            oPC       = GetItemActivator();
            oItem     = GetItemActivated();
            oTarget   = GetItemActivatedTarget();
            sResRef   = GetResRef( oItem );
            lTarget   = GetItemActivatedTargetLocation();

            if ( sResRef == "ds_j_backpack" ){

                ds_j_SetBackPack( oPC, 79 );
            }
            else if ( sResRef == "ds_j_quiver" ){

                ds_j_SetBackPack( oPC, 81 );
            }
            else if ( sResRef == "ds_j_scabbard" ){

                ds_j_SetBackPack( oPC, 83 );
            }
            else if ( sResRef == "ds_j_scabbard_a" ){

                ds_j_SetBackPack( oPC, 85 );
            }
            else if ( sResRef == "ds_j_scabbard_b" ){

                ds_j_SetBackPack( oPC, 87 );
            }
            else if ( sResRef == "ms_guige_a" ) {

                ds_j_SetBackPack( oPC, 113 );
            }
            else if ( sResRef == "ms_guige_b" ) {

                ds_j_SetBackPack( oPC, 114 );
            }
            else if ( sResRef == "ms_guige_c" ) {

                ds_j_SetBackPack( oPC, 115 );
            }
            else if ( sResRef == "ms_guige_d" ) {

                ds_j_SetBackPack( oPC, 116 );
            }
            else if ( sResRef == "ms_guige_e" ) {

                ds_j_SetBackPack( oPC, 117 );
            }
            else if ( sResRef == "ms_guige_f" ) {

                ds_j_SetBackPack( oPC, 118 );
            }
             else if ( sResRef == "ms_guige_g" ) {

                ds_j_SetBackPack( oPC, 119 );
            }
            else if ( sResRef == "ms_guige_h" ) {

                ds_j_SetBackPack( oPC, 120 );
            }
            else if ( sResRef == "ds_j_masked" ){

                ds_j_InitCloak( oPC, oItem, sResRef );
            }
            else if ( sResRef == "ds_j_hooded" ){

                ds_j_InitCloak( oPC, oItem, sResRef );
            }
            else if ( sResRef == "ds_j_gempouch" ){

                ds_j_GemPouch( oPC, oItem, oTarget );
            }
            else if ( sResRef == "ds_j_bandagebox" || sResRef == "ds_j_bandagebag" ){

                ds_j_BandageBox( oPC, oItem, oTarget );
            }
            else if ( sResRef == "ds_j_mythalbox" ){

                ds_j_MythalBox( oPC, oItem, oTarget );
            }
            else if ( sResRef == "ds_j_scrollbox" ){

                ds_j_ScrollBox( oPC, oItem, oTarget );
            }
            else if ( sResRef == "ds_j_wandcase" ){

                ds_j_WandCase( oPC, oItem, oTarget );
            }
            else if ( sResRef == "js_arca_trca" ){

                ds_j_TrapCase( oPC, oItem, oTarget );
            }
            else if ( GetStringLeft( sResRef, 11 ) == "ds_j_candle" ){

                oPLC1 = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_plc_candle", lTarget );
                SetName( oPLC1, GetName( oItem ) );
                SetDescription( oPLC1, GetDescription( oItem ) );
                DelayCommand( 1200.0, DestroyObject( oPLC1 ) );
            }
            else if ( sResRef == "ds_j_incense" ){

                oPLC1 = CreateObject( OBJECT_TYPE_PLACEABLE, "x0_plate", lTarget );
                oPLC2 = CreateObject( OBJECT_TYPE_PLACEABLE, "ds_j_incense", lTarget );

                DelayCommand( 600.0, DestroyObject( oPLC1 ) );
                DelayCommand( 601.0, DestroyObject( oPLC2 ) );
            }
            else if ( sResRef == "ds_j_sign" ){

                ds_j_SpawnItem( oPC, oItem, "ds_sign_widget", "lala", lTarget, GetName( oItem ), GetDescription( oItem ) );
            }
            else if ( sResRef == "ds_j_trap_1" ){

                AssignCommand( oPC, ds_j_SetEssenceTrap( oPC, lTarget, sResRef ) );
            }
            else if ( sResRef == "ds_j_potion" ){

                AssignCommand( oPC, ds_j_DrinkPotion( oPC, oItem ) );
            }
            else if ( sResRef == "ds_j_servant" ){

                ds_j_CreateServant( oPC, "ds_j_servant" );
            }
            else if ( sResRef == "ds_j_bomb_1" ){

                effect ePrimary   = EffectAbilityDecrease( ABILITY_DEXTERITY, 2 );
                effect eSecundary = EffectAttackDecrease( 2 );

                AssignCommand( oPC, ds_j_DoGrenade( oTarget, ePrimary, eSecundary ) );
            }
            else if ( sResRef == "ds_j_bomb_2" ){

                effect ePrimary   = EffectBlindness();
                effect eSecundary = EffectAttackDecrease( 2 );

                AssignCommand( oPC, ds_j_DoGrenade( oTarget, ePrimary, eSecundary ) );
            }
            else if ( sResRef == "ds_j_bomb_3" ){

                effect ePrimary   = EffectDeaf();
                effect eSecundary = EffectAttackDecrease( 2 );

                AssignCommand( oPC, ds_j_DoGrenade( oTarget, ePrimary, eSecundary ) );
            }
            else if ( GetStringLeft( sResRef, 10 ) == "ds_j_furn_" ||
                      GetStringLeft ( sResRef, 13 ) == "ds_furniture_" ||
                      sResRef == "ds_j_painting" ){

                ds_j_Furniture( oPC, oTarget, lTarget );
            }
            else if ( sResRef == "ds_j_map" ){

                ds_j_Map( oPC, oItem );
            }
            else if ( sResRef == "ds_j_spawner" ){

                ds_j_Spawner( oPC, oItem, oTarget, lTarget );
            }
            else {

                //food & drinks
                int nResource = ds_j_GetResourceID( oPC, oItem );
                int nType     = GetLocalInt( oItem, DS_J_TYPE );
                int nPrice    = ds_j_GetResourcePrice( nResource );
                int nHP       = 1 + ( nPrice / 5 );

                if ( nType == 2 ){

                    //food
                    AssignCommand( oPC, SpeakString( "*eats "+GetName( oItem )+"*" ) );

                    if ( nHP > 0 ){

                        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( nHP ), oPC );
                    }
                }
                else if ( nType == 3 ){

                    //drink
                    AssignCommand( oPC, ActionPlayAnimation( ANIMATION_FIREFORGET_DRINK ) );
                    AssignCommand( oPC, SpeakString( "*drinks "+GetName( oItem )+"*" ) );

                    if ( nHP > 0 ){

                        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( nHP ), oPC );
                    }

                    if ( d3() == 3 && FortitudeSave( oPC, d20()+10 ) == FALSE ){

                        AssignCommand( oTarget, ActionPlayAnimation( ANIMATION_LOOPING_PAUSE_DRUNK ) );

                        effect eDumb = EffectAbilityDecrease( ABILITY_INTELLIGENCE, d3() );

                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDumb, oTarget, 60.0 );
                    }
                }
                else if ( nType == 5 ){

                    //cosmetics
                    AssignCommand( oPC, SpeakString( "*applies "+GetName( oItem )+"*" ) );

                    ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectSkillIncrease( SKILL_PERSUADE, d3() ), oPC, 600.0 );
                }
                else if ( nType == 6 ){

                    //drink
                    AssignCommand( oPC, ActionPlayAnimation( ANIMATION_FIREFORGET_DRINK ) );
                    AssignCommand( oPC, SpeakString( "*drinks "+GetName( oItem )+"*" ) );

                    if ( nHP > 0 ){

                        ApplyEffectToObject( DURATION_TYPE_INSTANT, EffectHeal( nHP ), oPC );
                    }
                }
                else if ( nType == 7 ){

                    if ( oPC != oTarget ){

                        //medicine
                        AssignCommand( oPC, SpeakString( "*applies "+GetName( oItem )+" to "+GetName( oTarget )+"*" ) );

                        ApplyEffectToObject( DURATION_TYPE_TEMPORARY, EffectSkillIncrease( SKILL_HEAL, d6() ), oPC, 60.0 );
                    }
                    else{

                        AssignCommand( oPC, SpeakString( "*tries to do some self-treatment with "+GetName( oItem )+" and fails*" ) );
                    }
                }
            }

        break;

        case X2_ITEM_EVENT_EQUIP:

            oItem    = GetPCItemLastEquipped();
            sResRef  = GetResRef( oItem );

            if ( sResRef == "ds_j_masked" || sResRef == "ds_j_hooded" ){

                oPC      = GetPCItemLastEquippedBy();
                nCurrent = GetCreatureBodyPart( CREATURE_PART_HEAD, oPC );
                nAlt     = GetLocalInt( oItem, "althead" );

                if ( GetLocalInt( oItem, "done" ) ) {

                    SetCreatureBodyPart( CREATURE_PART_HEAD, nAlt, oPC );
                    SendMessageToPC( oPC, "[Cloak: Setting head to #"+IntToString( nAlt )+"]" );
                }
            }

        break;

        case X2_ITEM_EVENT_UNEQUIP:

            oItem    = GetPCItemLastUnequipped();
            sResRef  = GetResRef(oItem);

            if ( sResRef == "ds_j_masked" || sResRef == "ds_j_hooded" ){

                oPC      = GetPCItemLastUnequippedBy();
                nCurrent = GetCreatureBodyPart(CREATURE_PART_HEAD,oPC);
                nBase    = GetLocalInt( oItem, "basehead" );

                if ( GetLocalInt( oItem, "done" ) ) {

                    SetCreatureBodyPart( CREATURE_PART_HEAD, nBase, oPC);
                    SendMessageToPC( oPC, "[Cloak: Setting head to #"+IntToString( nBase )+"]" );
                }
            }

        break;

    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
