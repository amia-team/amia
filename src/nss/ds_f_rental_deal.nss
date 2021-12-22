//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_deal
//group: rentable housing
//used as: convo activation target script
//date: 2009-09-04
//author: disco
// Editted: Maverick00053, Aug 2017
//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_rental"
//#include "x0_i0_position"
#include "inc_ds_actions"



void main(){

    //check if this door is owned by somebody
    object oPC      = OBJECT_SELF;
    object oModule  = GetModule();
    object oDoor    = GetLocalObject( oPC, "ds_target" );
    object oWidget;
    object oKey;
    string sQuery;
    string sArea    = GetResRef( GetArea( oPC ) );
    string sNameArea    = GetName(GetArea( oPC ));
    string sDoor    = GetTag( oDoor );
    string sPCKEY   = GetName( GetPCKEY( oPC ) );
    string sFactionID = sArea+"faction";
    string sFactionName = sNameArea +" Faction";

    int nModule     = GetLocalInt( oModule, "Module" );
    int nTaken      = FALSE;
    int nNode       = GetLocalInt( oPC, "ds_node" );
    int nPrice;
    int nHours;
    int nType;

    SendMessageToPC(oPC,"This is running!");

    if ( nNode <= 0 || nNode > 6 ){

        return;
    }

    //I double check so people don't double deal
    if ( GetLocalString( oDoor, RNT_OWNER ) != "" ){

        nTaken = TRUE;
    }
    else {

        sQuery = "SELECT TIMESTAMPDIFF( HOUR, start_date, end_date ) "
               + "FROM faction_house WHERE "
               + "area='"+sArea+"' AND door='"+sDoor+"' AND module="+IntToString( nModule )+" AND end_date > NOW()";

        SQLExecDirect( sQuery );

        if ( SQLFetch() == SQL_SUCCESS ){

            if ( StringToInt( SQLGetData( 1 ) ) > 0 ){

                nTaken = TRUE;
            }
        }
    }

    if ( !nTaken ){

        switch ( nNode ) {
             // Change back!
             case 1:  nPrice =  5000000;  nHours = RNT_MONTHHOURS;  nType = 10;  break;
        }

        if ( GetGold( oPC ) >= nPrice ){

            TakeGoldFromCreature( nPrice, oPC, TRUE );
            //SpeakString( "You should have lost "+IntToString( nPrice )+" GP here..." );
            //Setting a variable for the conversation deal file

            SetLocalInt(oPC,"ds_check_90",1);
            // Setting the variable to all PCs in the area as well
            object oTemp = GetFirstObjectInArea(GetArea( oPC ));
            while(GetIsObjectValid(oTemp))
            {

                if(GetIsPC(oTemp))
                {
                  SetLocalInt(oTemp,"ds_check_90",1);
                }
                oTemp = GetNextObjectInArea(GetArea( oPC ));
            }


        }
        else{

            SpeakString( "You don't have enough gold for this." );
            return;
        }

        if ( !nType ){

            SpeakString( "Debug: ds_rental_deal: nType not set, abort." );
            return;
        }

        sQuery = "INSERT INTO faction_house VALUES ( "
               + "'"+sArea+"', "
               + "'"+sDoor+"', "
               + IntToString( nModule )+", "
               + "'"+sFactionID+"', "
               + "'"+IntToString( nType )+"', "
               + "NOW(), "
               + "TIMESTAMPADD( HOUR,"+IntToString( nHours )+",NOW() ) ) "
               + "ON DUPLICATE KEY UPDATE "
               + "faction_id='"+sFactionID+"', "
               + "type='"+IntToString( nType )+"', "
               + "start_date=NOW(), "
               + "end_date=TIMESTAMPADD( HOUR,"+IntToString( nHours )+",NOW() )";

        SQLExecDirect( sQuery );

     //Checking for a faction widget, adding one if it is missing and also adding in a gatekey
        oWidget = GetItemPossessedBy( oPC, "ds_f_rent_item" );

        if ( !GetIsObjectValid( oWidget ) ){

             oWidget = CreateItemOnObject( "i_ds_f_rent_item" );
             SetName(oWidget, sNameArea +" Faction Master");
             oKey = CreateItemOnObject("ds_faction_gatekey", oPC, 1, sArea);
             SetName(oKey, sNameArea +" Faction Key");
        }

        string sDoorID     = sArea+"_"+sDoor;

        //update local settings
        SetLocalString( oModule, sDoorID, sPCKEY );
        SetLocalInt( oModule, sDoorID, nType );
        SetLocalInt( oModule, RNT_PREFIX+sPCKEY, nHours );

        //number of charges = number of PLCs
        SetItemCharges( oWidget, nType * 10 );
    }
}

