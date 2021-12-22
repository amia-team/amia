//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_f_rent_layout
//group: rentable housing
//used as: item activation target script
//date: 2009-09-04
//author: disco
//Editted and repurposed: Maverick00053 8/26/17
//

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_rental"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC       = OBJECT_SELF;
    object oArea     = GetArea( oPC );
    object oTarget   = GetLocalObject( oPC, "ds_target" );
    object oWidget;
    object oKey;
    string sPCKEY    = GetName( GetPCKEY( oPC ) );
    object sKey;
    string sResRef;
    string sQuery;
    string nArea     = GetName(GetArea( oPC ));
    string sArea    = GetResRef( GetArea( oPC ) );
    string sFactionID = sArea+"faction";
    string sFactionName = nArea +" Faction";
    location lTarget = GetLocalLocation( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int nSection     = GetLocalInt( oPC, "ds_section" );
    int nRep;
    // Old nLimit formula
    //int nLimit       = FloatToInt( GetItemCharges( oTarget ) * 1.5 );

    // New nLimit set for faction areas
    int nLimit       = 200;
    int nPLCs;
    int nTrack;



    //used on a PC
    if ( GetIsPC( oTarget ) ){

        if ( nNode > 0 && nNode < 2 ) {

            if ( oTarget != oPC ){

                return;
            }

            //prolong rent
            int nPrice;
            int nHours;
            int nType;

            switch ( nNode ) {

                case 1:  nPrice =  1000000;  nHours = RNT_MONTHHOURS;  nType = 10;  break;
            }

            if ( GetGold( oPC ) >= nPrice ){

                TakeGoldFromCreature( nPrice, oPC, TRUE );
                //SpeakString( "You should have lost "+IntToString( nPrice )+" GP here..." );
            }
            else{

                SpeakString( "You don't have enough gold for this." );
                return;
            }

            if ( !nType ){

                SpeakString( "Debug: ds_rental_layout: nType not set, abort." );
                return;
            }

            sQuery = "UPDATE faction_house SET "
                  + "type="+IntToString( nType )+", "
                  + "start_date=NOW(), "
                  + "end_date=TIMESTAMPADD( HOUR,"+IntToString( nHours )+",NOW() ) "
                  + "WHERE faction_id='"+sFactionID+"' LIMIT 1";

            SQLExecDirect( sQuery );

            //fix widget
            oWidget = GetItemPossessedBy( oPC, "ds_f_rent_item" );

            if ( !GetIsObjectValid( oWidget ) ){

               oWidget = CreateItemOnObject( "i_ds_f_rent_item" );
               SetName(oWidget, nArea +" Faction");
            }


            //number of charges = number of PLCs
            SetItemCharges( oWidget, ( nType * 10 ) );

            //remove previous layout - Might want to get rid of this?
            object oObject = GetFirstObjectInArea( oArea );

            while ( GetIsObjectValid( oObject ) ){

                if ( GetObjectType( oObject ) == OBJECT_TYPE_PLACEABLE && GetTag( oObject ) != RNT_STAY_TAG ){

                    SafeDestroyObject( oObject );
                }
                else if ( GetObjectType( oObject ) == OBJECT_TYPE_ITEM ){

                    DestroyObject( oObject );
                }

                oObject = GetNextObjectInArea( oArea );
            }

            DeleteLocalInt( oArea, RNT_FURNITURE_COUNT );
            DeleteLocalInt( oArea, RNT_LAYOUT_APPLIED );

            //apply new faction layout
            ApplyFactionLayout(oPC, oArea, nType );
            //
        }
        else if ( nNode == 10 ){

            if ( oTarget == oPC ){

                //return;
            }


            // check for a key and create gate key if one isnt present
            sKey  = GetItemPossessedBy(oTarget, sArea);

            if ( !GetIsObjectValid(sKey) ){

                //create new key
                SpeakString( "*gives key*" );

                oKey = CreateItemOnObject("ds_faction_gatekey", oPC, 1, sArea);
                SetName(oKey, nArea +" Faction Key");
            }
            else{

                //already has a key
                SendMessageToPC( oPC, "Error: This PC already has faction key. Perhaps of another faction?" );
            }
        }
        else if ( nNode == 11 ){

            if ( oTarget == oPC ){

                //return;
            }

            //remove key
            sKey  = GetItemPossessedBy(oTarget, sArea);

            if ( GetIsObjectValid(sKey)){

                //remove key

                    DestroyObject( sKey );

                    DeleteLocalString( oTarget, RNT_PCKEY );

                    SpeakString( "*takes key*" );

            }
            else{

                //nothing to remove
                SendMessageToPC( oPC, "Error: There's no key to remove from this PC." );
            }
        }
        else if ( nNode == 12 ){

            if ( oTarget == oPC ){

                //return;
            }

            //needs a check on sql db
            sQuery = "SELECT TIMESTAMPDIFF( HOUR, start_date, end_date ) "
                   + "FROM faction_house WHERE "
                   + "faction_id='"+sFactionID+"' AND end_date > NOW()";

            SQLExecDirect( sQuery );

            if ( SQLFetch() == SQL_SUCCESS ){

                if ( StringToInt( SQLGetData( 1 ) ) > -1 ){

                    SpeakString( "You cannot make this PC a faction owner because she/he already owns a faction." );
                    return;
                }
            }
            /*
            // Need to think this over
            sQuery = "UPDATE faction_house SET "
                  + "pckey='"+GetName( GetPCKEY( oTarget ) )+"' "
                  + "WHERE faction_id='"+sFactionID+"' LIMIT 1";

            SQLExecDirect( sQuery );
            */
            //fix widget
            SpeakString( "Give your faction widget to the new owner. The transfer will be final next reset." );
        }

        return;
    }

    if ( nNode == 40 ){

        SetLocalInt( oPC, "ds_section", 0 );
    }

    if ( !nSection ){

        if ( nNode > 0 && nNode < 24 ){

            SetLocalInt( oPC, "ds_section", nNode );
        }
    }
    else if ( nSection == 1 ){

        //chairs
        switch ( nNode ) {

            case 21:     sResRef = "chairuse003";    break;
            case 22:     sResRef = "chairuse001";    break;
            case 23:     sResRef = "chairuse006";    break;
            case 24:     sResRef = "custom_plc_030"; break;
            case 25:     sResRef = "chairuse004";    break;
            case 26:     sResRef = "chair";          break;
            case 27:     sResRef = "ds_stool";       break;
            case 28:     sResRef = "custom_plc_020"; break;
            case 29:     sResRef = "custom_plc_021"; break;
            case 30:     sResRef = "custom_plc_022"; break;
            case 31:     sResRef = "chairuse";       break;
            case 32:     sResRef = "bench003";       break;
            case 33:     sResRef = "ds_rental_013";       break;
            case 34:     sResRef = "ds_rental_014";       break;
            case 35:     sResRef = "ds_rental_015";       break;
            case 36:     sResRef = "ds_rental_016";       break;

        }
    }
    else if ( nSection == 2 ){

        //carpets
        switch ( nNode ) {

            case 21:     sResRef = "x0_bearskinrug1";   break;
            case 22:     sResRef = "x0_rugoriental";    break;
            case 23:     sResRef = "x0_rugoriental";    break;
            case 24:     sResRef = "x0_ruglarge";       break;
            case 25:     sResRef = "x0_roundrugorien";  break;
            case 26:     sResRef = "plc_throwrug";      break;
            case 27:     sResRef = "ds_rental_017";      break;
            case 28:     sResRef = "ds_rental_018";      break;
            case 29:     sResRef = "ds_rental_019";      break;
            case 30:     sResRef = "ds_rental_020";      break;
            case 31:     sResRef = "ds_rental_021";      break;
            case 32:     sResRef = "ds_rental_022";      break;
            case 33:     sResRef = "ds_rental_023";      break;
            case 34:     sResRef = "ds_rental_024";      break;
        }
    }
    else if ( nSection == 3 ){

        //candles, vfx, and other lightning
        switch ( nNode ) {

            case 21:  sResRef = "plc_candelabra";       break;
            case 22:  sResRef = "nw_plc_candle1";       break;
            case 23:  sResRef = "nw_plc_candle1na";     break;
            case 24:  sResRef = "nw_plc_candle2";       break;
            case 25:  sResRef = "nw_plc_candle2na";     break;
            case 26: // sResRef = "x0_chandelier";        break;
            case 27:  sResRef = "ds_rental_008";        break;
            case 28:  sResRef = "ds_rental_009";        break;
            case 29:  sResRef = "ds_rental_010";        break;
            case 30:  sResRef = "ds_rental_011";        break;
            case 31:  sResRef = "plc_dustplume";        break;
            case 32:  sResRef = "plc_flamelarge";       break;
            case 33:  sResRef = "plc_flamemedium";      break;
            case 34:  sResRef = "plc_flamesmall";       break;
            case 35:  sResRef = "ds_rental_012";        break;
            case 36:  sResRef = "freetorch";            break;
        }
    }
    else if ( nSection == 4 ){

        //bookshelf and cupboard
        switch ( nNode ) {

            case 21:  sResRef = "nb_bookshelf";       break;
            case 22:  sResRef = "chest006";           break;
            case 23:  sResRef = "chest007";           break;
            case 24:  sResRef = "chest008";           break;
            case 25:  sResRef = "chest009";           break;
            case 26:  sResRef = "chest010";           break;
            case 27:  sResRef = "x0_bookcase03";      break;
            case 28:  sResRef = "x0_bookcase2";       break;
            case 29:  sResRef = "ds_rental_032";      break;
            case 30:  sResRef = "ds_rental_033";      break;
            case 31:  sResRef = "ds_rental_034";      break;
            case 32:  sResRef = "ds_rental_035";      break;
        }
    }
    else if ( nSection == 5 ){

        //broken stuff, houses, tower, walls etc
        switch ( nNode ) {


            case 21:  sResRef = "ds_rental_036";            break;
            case 22:  sResRef = "ds_rental_037";            break;
            case 23:  sResRef = "ds_rental_038";            break;
            case 24:  sResRef = "ds_rental_039";            break;
            case 25:  sResRef = "ds_rental_040";            break;
            case 26:  sResRef = "ds_rental_041";            break;
            case 27:  sResRef = "ds_rental_042";            break;
            case 28:  sResRef = "factionhouse1";            break;
            case 29:  sResRef = "factionhouse2";            break;
            case 30:  sResRef = "factionhut1";              break;
            case 31:  sResRef = "factionhut2";              break;
            case 32:  sResRef = "factiontent1";            break;
            case 33:  sResRef = "factiontent2";            break;
            case 34:  sResRef = "factiontower1";           break;
            case 35:  sResRef = "factionwallbrick";        break;
            case 36:  sResRef = "factionwalldark1";        break;
            case 37:  sResRef = "factionwalldark2";        break;
            case 38:  sResRef = "factionwallstone1";       break;
            case 39:  sResRef = "factionwallstone2";       break;

        }
    }
    else if ( nSection == 6 ){

        //chests, crates and barrels
        switch ( nNode ) {

            case 21:  sResRef = "barrel";             break;
            case 22:  sResRef = "barrel001";          break;
            case 23:  sResRef = "chest003";           break;
            case 24:  sResRef = "tha_chest";          break;
            case 25:  sResRef = "chest1";             break;
            case 26:  sResRef = "chest002";           break;
            case 27:  sResRef = "chest004";           break;
            case 28:  sResRef = "ds_rental_002";      break;
            case 29:  sResRef = "box002";             break;
            case 30:  sResRef = "box003";             break;
            case 31:  sResRef = "box004";             break;
            case 32:  sResRef = "box005";             break;
            case 33:  sResRef = "emptyblackcrate";    break;
            case 34:  sResRef = "emptyblackcrate2";   break;
            case 35:  sResRef = "ds_rental_002";   break;
            case 36:  sResRef = "ds_rental_003";   break;
            case 37:  sResRef = "ds_rental_005";   break;
            case 38:  sResRef = "ds_rental_006";   break;
            case 39:  sResRef = "ds_rental_007";   break;



        }
    }
    else if ( nSection == 7 ){

        //benches & beds
        switch ( nNode ) {

            case 21:  sResRef = "bench002";           break;
            case 22:  sResRef = "chairuse005";        break;
            case 23:  sResRef = "custom_plc_023";     break;
            case 24:  sResRef = "bench005";           break;
            case 25:  sResRef = "bench004";           break;
            case 31:  sResRef = "plc_bed";            break;
            case 32:  sResRef = "nw_plc_dwarfbed";    break;
            case 33:  sResRef = "x0_beddouble";       break;
            case 34:  sResRef = "x0_largebed";        break;
            case 35:  sResRef = "plc_bedrolls";       break;
        }
    }
    else if ( nSection == 8 ){

        //creepy stuff
        switch ( nNode ) {

            case 21:  sResRef = "pl_skeleton001";      break;
            case 22:  sResRef = "x3_plc_skelmage";    break;
            case 23:  sResRef = "plc_animalcage";      break;
            case 24:  sResRef = "pl_zombie001";        break;
            case 25:  sResRef = "plc_bloodstain";      break;
            case 26:  sResRef = "x3_plc_pedestal";     break;
            case 27:  sResRef = "x0_RuneCircle";       break;
            case 28:  sResRef = "sarco003";            break;
            case 29:  sResRef = "sarco004";            break;
            case 30:  sResRef = "sarco041";            break;
            case 31:  sResRef = "x3_plc_stocks001";    break;
            case 32:  sResRef = "x0_skullpole";        break;
            case 33:  sResRef = "plc_torture1";        break;
            case 34:  sResRef = "plc_torture2";        break;
            case 35:  sResRef = "corpse002";     break;
            case 36:  sResRef = "plc_flrshackles";     break;
            case 37:  sResRef = "plc_hangmnpost";      break;
            case 38:  sResRef = "plc_pileskulls";      break;
        }
    }
    else if ( nSection == 9 ){

        //tables and desks
        switch ( nNode ) {

            case 21:  sResRef = "x2_plc_tabledrow";    break;
            case 23:  sResRef = "x2_plc_tablemind";    break;
            case 24:  sResRef = "x0_librarydesk";      break;
            case 25:  sResRef = "nw_plc_dwarftabl";    break;
            case 26:  sResRef = "nw_plc_seatable";     break;
            case 27:  sResRef = "x2_plc_tablernd";     break;
            case 28:  sResRef = "x0_smalldesk";        break;
            case 29:  sResRef = "x0_wizdesk";          break;
            case 30:  sResRef = "plc_table";           break;
            case 31:  sResRef = "x3_plc_table002";     break;
            case 32:  sResRef = "x2_plc_drowbar";      break;
            case 33:  sResRef = "ds_rental_025";       break;
            case 34:  sResRef = "ds_rental_026";       break;
            case 35:  sResRef = "ds_rental_027";       break;
            case 36:  sResRef = "ds_rental_028";       break;
            case 37:  sResRef = "ds_rental_029";       break;
            case 38:  sResRef = "ds_rental_030";       break;
            case 39:  sResRef = "ds_rental_031";       break;
        }
    }
    else if ( nSection == 10 ){

        //mechanisms
        switch ( nNode ) {

            case 21:  sResRef = "custom_plc_4";        break;
            case 22:  sResRef = "custom_plc_5";        break;
            case 23:  sResRef = "custom_plc_2";        break;
            case 24:  sResRef = "custom_plc_2a";       break;
            case 25:  sResRef = "custom_plc_3";        break;
            case 26:  sResRef = "custom_plc_3a";       break;
            case 27:  sResRef = "plc_pullrope";        break;
            case 28:  sResRef = "plc_prssplate2";      break;
            case 29:  sResRef = "custom_plc_1";        break;
            case 30:  sResRef = "custom_plc_1a";       break;
            case 31:  sResRef = "udb_glowingorb";      break;
            case 32:  sResRef = "rentalgatewayope";      break;
            case 33:  sResRef = "factionresourcec";      break;
        }
    }
    else if ( nSection == 11 ){

        //statues
        switch ( nNode ) {

            case 21:  sResRef = "plc_statue2";         break;
            case 22:  sResRef = "x2_plc_statu_dra";    break;
            case 23:  sResRef = "x2_plc_statue_f";     break;
            case 24:  sResRef = "x2_plc_statue_fl";    break;
            case 25:  sResRef = "plc_statue3";         break; //Gargoyle Statue
            case 26:  sResRef = "x2_plc_statue_h";     break; //Giant Warrior Statue
            case 27:  sResRef = "x2_plc_statue_la";    break; //Globe Man Statue
            case 28:  sResRef = "x3_plc_statuec";      break; //Great Warrior Statue
            case 29:  sResRef = "x2_plc_statue_mo";    break;
            case 30:  sResRef = "x0_sphinxstatue";     break;
            case 31:  sResRef = "plc_statue1";         break; //Stone Shield Warrior
            case 32:  sResRef = "x3_plc_gg001";        break; //Wizard Statue
            case 33:  sResRef = "x3_plc_statuew";      break; //Wyvern
        }
    }
    else if ( nSection == 12 ){

        //food
        switch ( nNode ) {

            case 21:  sResRef = "x0_bigvase";             break;
            case 22:  sResRef = "ds_rental_046";          break;
            case 23:  sResRef = "ds_rental_047";   break;
            case 24:  sResRef = "ds_rental_048";          break;
            case 25:  sResRef = "ds_rental_049";             break;
            case 26:  sResRef = "x0_vaseflower";           break;
            case 27:  sResRef = "plc_pottedplant";           break;
        }
    }
    else if ( nSection == 13 ){

        //deco
        switch ( nNode ) {

            case 21:  sResRef = "ds_rental_050";             break;
            case 22:  sResRef = "udb_crystal";          break;
            case 23:  sResRef = "plc_watertrough";   break;
            case 24:  sResRef = "x3_plc_dartbrd";          break;
            case 25:  sResRef = "x0_fenceruined";             break;
            case 26:  sResRef = "ds_rental_051";           break;
            case 27:  sResRef = "plc_fountain";           break;
            case 28:  sResRef = "x2_plc_mirror_lg";           break;
            case 29:  sResRef = "x0_loom";             break;
            case 30:  sResRef = "x2_plc_mirror";             break;
            case 31:  sResRef = "x0_painting";             break;
            case 32:  sResRef = "x0_painting2";             break;
            case 33:  sResRef = "ds_rental_052";    break;
            case 34:  sResRef = "x0_ruinedpillar";   break;
            case 35:  sResRef = "freetorch";   break;
            case 36:  sResRef = "plc_urn";   break;
            case 37:  sResRef = "x2_plc_web";   break;
            case 38:  sResRef = "x0_window";   break;
            case 39:  sResRef = "plc_woodpile";   break;
        }
    }
    else if ( nSection == 14 ){

        //basic items
        switch ( nNode ) {

            case 21:  sResRef = "ds_bar_1";         break;
            case 22:  sResRef = "ds_clothes_1";     break;
            case 30:  nTrack  = TRACK_CITYSLUMDAY;  break;
            case 31:  nTrack  = TRACK_CITYSLUMNIGHT;  break;
            case 32:  nTrack  = TRACK_RURALDAY1;  break;
            case 33:  nTrack  = TRACK_RURALNIGHT;  break;
        }
    }
    else if ( nSection == 15 ){

        //stabdard items
        switch ( nNode ) {

            case 21:  sResRef = "ds_bar_2";         break;
            case 22:  sResRef = "ds_clothes_2";     break;
            case 30:  nTrack  = TRACK_CITYDOCKDAY;  break;
            case 31:  nTrack  = TRACK_CITYDOCKNIGHT;  break;
            case 32:  nTrack  = TRACK_CITYNIGHT;  break;
            case 33:  nTrack  = TRACK_DESERT_DAY;  break;
            case 34:  nTrack  = TRACK_FORESTDAY1;  break;
            case 35:  nTrack  = TRACK_STORE;  break;
            case 36:  nTrack  = TRACK_TAVERN1;  break;
        }
    }
    else if ( nSection == 16 ){

        //deluxe items
        switch ( nNode ) {

            case 21:  sResRef = "ds_bar_3";         break;
            case 22:  sResRef = "ds_clothes_3";     break;
            case 30:  nTrack  = TRACK_CITYWEALTHY;  break;
            case 31:  nTrack  = TRACK_RICHHOUSE;  break;
            case 32:  nTrack  = TRACK_TEMPLEEVIL;  break;
            case 33:  nTrack  = TRACK_TEMPLEGOOD;  break;
            case 34:  nTrack  = TRACK_TEMPLEGOOD2;  break;
            case 35:  nTrack  = TRACK_THEME_ARIBETH1;  break;
            case 36:  nTrack  = TRACK_THEME_GEND;  break;
            case 37:  nTrack  = TRACK_THEME_MAUGRIM;  break;
            case 38:  nTrack  = TRACK_THEME_MORAG;  break;
            case 39:  nTrack  = TRACK_THEME_NWN;  break;
        }
    }
    else if ( nSection == 17 ){

        //altars
        switch ( nNode ) {

            case 21:  sResRef = "x3_plc_evlaltar";     break;
            case 22:  sResRef = "nw_plc_trogshrin";    break;
            case 23:  sResRef = "plc_altrevil";        break;
            case 24:  sResRef = "plc_altrgood";        break;
            case 25:  sResRef = "plc_altrneutral";     break;
            case 26:  sResRef = "x2_plc_phylact";      break;
            case 27:  sResRef = "ds_rental_043";       break;
            case 28:  sResRef = "ds_rental_044";       break;
            case 29:  sResRef = "ds_rental_045";       break;
        }
    }
    else if ( nSection == 19 ){

        //manipulation
        switch ( nNode ) {

            case 21:     ShowPLC( lTarget );            break;
            case 22:     RotatePLC( lTarget, 20.0 );    break;
            case 23:     RotatePLC( lTarget, 90.0 );    break;
            case 24:     RotatePLC( lTarget, -20.0 );   break;
            case 25:     RotatePLC( lTarget, -90.0 );   break;
            case 26:     FaceMePLC( lTarget );          break;
            case 39:     DestroyPLC( lTarget );         break;
        }
    }
    else if ( nSection == 20 ){

        //manipulation
        switch ( nNode ) {

            case 21:     RestoreFactionLayout( );            break;
            case 22:     StoreFactionLayout( oTarget );    break;
            case 23:     DeleteFactionLayout( );    break;
        }
    }
    else if ( nSection == 21 ){

        //Job system
        switch ( nNode ) {

            case 21:  sResRef = "ds_j_alchemy";         break;
            case 22:  sResRef = "ds_j_armouranvil";     break;
            case 23:  sResRef = "ds_j_bakeroven";     break;
            case 24:  sResRef = "ds_j_bowyersbenc";     break;
            case 25:  sResRef = "ds_j_brewingkett";     break;
            case 26:  sResRef = "ds_j_butcherslab";     break;
            case 27:  sResRef = "ds_j_butterchurn";     break;
            case 28:  sResRef = "ds_j_candlepot";     break;
            case 29:  sResRef = "ds_j_carpenterbe";     break;
            case 30:  sResRef = "ds_j_globe";     break;
            case 31:  sResRef = "ds_j_cheesevat";     break;
            case 32:  sResRef = "ds_j_cookingpot";     break;
            case 33:  sResRef = "ds_j_curing";     break;
            case 34:  sResRef = "ds_j_lab";     break;
            case 35:  sResRef = "ds_j_fletcherben";     break;
            case 36:  sResRef = "ds_j_gembench";     break;
            case 37:  sResRef = "ds_j_herbpot";     break;
            case 38:  sResRef = "ds_j_inventorlab";     break;
            case 39:  sResRef = "ds_j_jeweler";     break;
            case 41:  sResRef = "ds_j_juicepress";     break;
            case 42:  sResRef = "ds_j_leatherbenc";     break;
            case 43:  sResRef = "ds_j_shroombrew";     break;
            case 44:  sResRef = "ds_j_shroomcook";     break;
            case 45:  sResRef = "ds_j_smelting";     break;
            case 46:  sResRef = "ds_j_research";     break;
            case 47:  sResRef = "ds_j_sawhorse";     break;
            case 48:  sResRef = "ds_j_slab";     break;
            case 49:  sResRef = "ds_j_stonemason";     break;
            case 50:  sResRef = "ds_j_tailorbench";     break;
            case 51:  sResRef = "ds_j_tredmill";     break;
            case 52:  sResRef = "ds_j_weaponanvil";     break;
            case 53:  sResRef = "ds_j_loom";     break;
            case 54:  sResRef = "ds_j_windmill";     break;
            case 55:  sResRef = "ds_j_desk";     break;
        }
    }
    else if ( nSection == 22 ){

        //Blood/Corpse/weapons PLC
        switch ( nNode ) {

            case 21:  sResRef = "factionarrow";         break;
            case 22:  sResRef = "factionarrowtilt";     break;
            case 23:  sResRef = "factionbaxetilt";     break;
            case 24:  sResRef = "factionbolt";     break;
            case 25:  sResRef = "factionbolt2";     break;
            case 26:  sResRef = "factionblood1";     break;
            case 27:  sResRef = "factionblood2";     break;
            case 28:  sResRef = "factionblood3";     break;
            case 29:  sResRef = "factionblood4";     break;
            case 30:  sResRef = "factionblood5";     break;
            case 31:  sResRef = "factionblood10";     break;
            case 32:  sResRef = "factionblood11";     break;
            case 33:  sResRef = "factionblood12";     break;
            case 34:  sResRef = "factionblood6";     break;
            case 35:  sResRef = "factionblood7";     break;
            case 36:  sResRef = "factionblood8";     break;
            case 37:  sResRef = "factionblood9";     break;
            case 38:  sResRef = "factionbone1";     break;
            case 39:  sResRef = "factionbone2";     break;
            case 41:  sResRef = "factionbone3";     break;
            case 42:  sResRef = "factionbone5";     break;
            case 43:  sResRef = "factionbone6";     break;
            case 44:  sResRef = "factionbone7";     break;
            case 45:  sResRef = "factionbone8";     break;
            case 46:  sResRef = "factioncheval";     break;
            case 47:  sResRef = "factioncorpse7";     break;
            case 48:  sResRef = "factioncorpse8";     break;
            case 49:  sResRef = "factioncorpse9";     break;
            case 50:  sResRef = "factioncorpse10";     break;
            case 51:  sResRef = "factioncorpse11";     break;
            case 52:  sResRef = "factioncorpse12";     break;
            case 53:  sResRef = "factioncorpse13";     break;
            case 54:  sResRef = "factioncorpse14";     break;
            case 55:  sResRef = "factioncorpse15";     break;
            case 56:  sResRef = "factioncorpse16";     break;
            case 57:  sResRef = "factioncorpse17";     break;
            case 58:  sResRef = "factioncorpse18";     break;
            case 59:  sResRef = "factioncorpse19";     break;
            case 60:  sResRef = "factioncorpse20";     break;
            case 61:  sResRef = "factioncorpse26";     break;
            case 62:  sResRef = "factioncorpse29";     break;
            case 63:  sResRef = "factioncorpse30";     break;
            case 64:  sResRef = "factioncorpse24";     break;
            case 65:  sResRef = "factioncorpse25";     break;
            case 66:  sResRef = "factioncorpse21";     break;
            case 67:  sResRef = "factioncorpse22";     break;
            case 68:  sResRef = "factioncorpse23";     break;
            case 69:  sResRef = "factioncorpse1";     break;
            case 70:  sResRef = "factioncorpse2";     break;
            case 71:  sResRef = "factioncorpse3";     break;
            case 72:  sResRef = "factioncorpse4";     break;
            case 73:  sResRef = "factioncorpse5";     break;
            case 74:  sResRef = "factioncorpse6";     break;
            case 75:  sResRef = "factioncorpse27";     break;
            case 76:  sResRef = "factioncorpse28";     break;
            case 77:  sResRef = "factioncorpse31";     break;
            case 78:  sResRef = "factioncorpse32";     break;
            case 79:  sResRef = "factioncorpse33";     break;
            case 80:  sResRef = "factiondagger1";     break;
            case 81:  sResRef = "factiondagger2";     break;
            case 82:  sResRef = "factionlongsword";     break;
            case 83:  sResRef = "factionsorch3";     break;
            case 84:  sResRef = "factionsorch2";     break;
            case 85:  sResRef = "factionsorch1";     break;
        }
    }
   else if ( nSection == 23 ){

     //Reputation PLC
     // First check to see the reputation level
     sQuery = "SELECT int_1 FROM faction_reputation WHERE faction_id='"+sArea+"'";

     SQLExecDirect( sQuery );

        if ( SQLFetch() == SQL_SUCCESS )
        {
            nRep  = StringToInt(SQLGetData( 1 ));
        }
        else
        {
           nRep = 0;
        }





            if(nNode == 21)
            {


              if(nRep >= 100)
              {

               sResRef = "factionballista";


              }
              else
              {
                SendMessageToPC(oPC,"You do not have enough reputation points for this.");

              }


            }











    }

    SendMessageToPC( oPC, "nSection="+IntToString( nSection ) );
    SendMessageToPC( oPC, "nNode="+IntToString( nNode ) );
    SendMessageToPC( oPC, "sResRef="+sResRef );

    if ( sResRef != "" ){

        nPLCs = GetLocalInt( oArea, RNT_FURNITURE_COUNT );

        if ( nPLCs >= nLimit ){

            SendMessageToPC( oPC, "Error: You can only add up to "+IntToString( nLimit )+" pieces of furniture in your setup." );
        }
        else{

            ++nPLCs;

            SetLocalInt( oArea, RNT_FURNITURE_COUNT, nPLCs );

            CreateObject( OBJECT_TYPE_PLACEABLE, sResRef, lTarget, 0, RNT_FURNITURE_TAG );

            SendMessageToPC( oPC, "You can place "+IntToString( nLimit-nPLCs )+" more pieces of furniture." );
        }

        SetLocalInt( oPC, "ds_section", 0 );
    }
    else if ( nTrack > 0 ){

        MusicBackgroundStop( oArea );
        MusicBackgroundChangeDay( oArea, nTrack );
        MusicBackgroundChangeNight( oArea, nTrack );
        MusicBackgroundPlay( oArea );
    }
    else if ( nNode > 24 && nNode < 40 ){

        SetLocalInt( oPC, "ds_section", 0 );
    }
}





