//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_layout
//group: rentable housing
//used as: item activation target script
//date: 2009-09-04
//author: disco


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
    string sKey;
    string sResRef;
    string sQuery;
    location lTarget = GetLocalLocation( oPC, "ds_target" );
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int nSection     = GetLocalInt( oPC, "ds_section" );
    int nLimit       = FloatToInt( GetItemCharges( oTarget ) * 1.5 );
    int nPLCs;
    int nTrack;

    //used on a PC
    if ( GetIsPC( oTarget ) ){

        if ( nNode > 0 && nNode < 7 ) {

            if ( oTarget != oPC ){

                return;
            }

            //prolong rent
            int nPrice;
            int nHours;
            int nType;

            switch ( nNode ) {

                case 1:  nPrice =   25000;  nHours = RNT_WEEKHOURS;   nType = 1;  break;
                case 2:  nPrice =   50000;  nHours = RNT_WEEKHOURS;   nType = 2;  break;
                case 3:  nPrice =  100000;  nHours = RNT_WEEKHOURS;   nType = 3;  break;
                case 4:  nPrice =  125000;  nHours = RNT_MONTHHOURS;  nType = 1;  break;
                case 5:  nPrice =  250000;  nHours = RNT_MONTHHOURS;  nType = 2;  break;
                case 6:  nPrice =  500000;  nHours = RNT_MONTHHOURS;  nType = 3;  break;
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

            sQuery = "UPDATE rental_house SET "
                  + "type="+IntToString( nType )+", "
                  + "start_date=NOW(), "
                  + "end_date=TIMESTAMPADD( HOUR,"+IntToString( nHours )+",NOW() ) "
                  + "WHERE pckey='"+sPCKEY+"' LIMIT 1";

            SQLExecDirect( sQuery );

            //fix widget
            oWidget = GetItemPossessedBy( oPC, "ds_rental_item" );

            if ( !GetIsObjectValid( oWidget ) ){

                 oWidget = CreateItemOnObject( "i_ds_rental_item", oPC );
            }

            //number of charges = number of PLCs
            SetItemCharges( oWidget, ( nType * 10 ) );

            //remove previous layout
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

            //apply new layout
            ApplyLayout( oPC, oArea, sPCKEY, nType );
        }
        else if ( nNode == 10 ){

            if ( oTarget == oPC ){

                //return;
            }

            //create key
            sKey   = GetLocalString( oTarget, RNT_PCKEY );

            if ( sKey == "" ){

                //create new key
                SpeakString( "*gives key*" );

                oKey = CreateItemOnObject( RNT_KEY_TAG, oTarget, 1, sPCKEY );
            }
            else{

                //already has a key
                SendMessageToPC( oPC, "Error: This PC already has key. Perhaps of another house?" );
            }
        }
        else if ( nNode == 11 ){

            if ( oTarget == oPC ){

                //return;
            }

            //remove key
            sKey   = GetLocalString( oTarget, RNT_PCKEY );

            if ( sKey != "" ){

                //remove key
                oKey = GetItemPossessedBy( oTarget, sKey );

                if ( GetResRef( oKey ) == RNT_KEY_TAG ){

                    DestroyObject( oKey );

                    DeleteLocalString( oTarget, RNT_PCKEY );

                    SpeakString( "*takes key*" );
                }
                else{

                    SendMessageToPC( oPC, "Error: "+GetName( oKey )+" isn't a key." );
                }
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
                   + "FROM rental_house WHERE "
                   + "pckey='"+GetName( GetPCKEY( oTarget ) )+"' AND end_date > NOW()";

            SQLExecDirect( sQuery );

            if ( SQLFetch() == SQL_SUCCESS ){

                if ( StringToInt( SQLGetData( 1 ) ) > -1 ){

                    SpeakString( "You cannot make this PC a house owner because he already owns a house." );
                    return;
                }
            }

            sQuery = "UPDATE rental_house SET "
                  + "pckey='"+GetName( GetPCKEY( oTarget ) )+"' "
                  + "WHERE pckey='"+sPCKEY+"' LIMIT 1";

            SQLExecDirect( sQuery );

            //fix widget
            SpeakString( "Give your furniture widget to the new owner. The transfer will be final next reset." );
        }

        return;
    }

    if ( nNode == 40 ){

        SetLocalInt( oPC, "ds_section", 0 );
    }

    if ( !nSection ){

        if ( nNode > 0 && nNode < 21 ){

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
            case 26:  sResRef = "x0_chandelier";        break;
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

        //broken stuff
        switch ( nNode ) {

            case 21:  sResRef = "ds_rental_036";            break;
            case 22:  sResRef = "ds_rental_037";            break;
            case 23:  sResRef = "ds_rental_038";            break;
            case 24:  sResRef = "ds_rental_039";            break;
            case 25:  sResRef = "ds_rental_040";            break;
            case 26:  sResRef = "ds_rental_041";            break;
            case 27:  sResRef = "ds_rental_042";            break;
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

            case 21:     RestoreLayout( );            break;
            case 22:     StoreLayout( oTarget );    break;
            case 23:     DeleteLayout( );    break;
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
    else if ( nNode > 20 && nNode < 40 ){

        SetLocalInt( oPC, "ds_section", 0 );
    }
}






