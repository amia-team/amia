//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_deal
//group: rentable housing
//used as: convo activation target script
//date: 2009-09-04
//author: disco

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
    string sQuery;
    string sArea    = GetResRef( GetArea( oPC ) );
    string sDoor    = GetTag( oDoor );
    string sPCKEY   = GetName( GetPCKEY( oPC ) );
    int nModule     = GetLocalInt( oModule, "Module" );
    int nTaken      = FALSE;
    int nNode       = GetLocalInt( oPC, "ds_node" );
    int nPrice;
    int nHours;
    int nType;

    if ( nNode <= 0 || nNode > 6 ){

        return;
    }

    //I double check so people don't double deal
    if ( GetLocalString( oDoor, RNT_OWNER ) != "" ){

        nTaken = TRUE;
    }
    else {

        sQuery = "SELECT TIMESTAMPDIFF( HOUR, start_date, end_date ) "
               + "FROM rental_house WHERE "
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

            case 1:  nPrice =   25000;  nHours = RNT_WEEKHOURS;   nType = 1;  break;
            case 2:  nPrice =   50000;  nHours = RNT_WEEKHOURS;   nType = 2;  break;
            case 3:  nPrice =   100000;  nHours = RNT_WEEKHOURS;   nType = 3;  break;
            case 4:  nPrice =   125000;  nHours = RNT_MONTHHOURS;  nType = 1;  break;
            case 5:  nPrice =   250000;  nHours = RNT_MONTHHOURS;  nType = 2;  break;
            case 6:  nPrice =   500000;  nHours = RNT_MONTHHOURS;  nType = 3;  break;
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

            SpeakString( "Debug: ds_rental_deal: nType not set, abort." );
            return;
        }

        sQuery = "INSERT INTO rental_house VALUES ( "
               + "'"+sArea+"', "
               + "'"+sDoor+"', "
               + IntToString( nModule )+", "
               + "'"+sPCKEY+"', "
               + "'"+IntToString( nType )+"', "
               + "NOW(), "
               + "TIMESTAMPADD( HOUR,"+IntToString( nHours )+",NOW() ) ) "
               + "ON DUPLICATE KEY UPDATE "
               + "pckey='"+sPCKEY+"', "
               + "type='"+IntToString( nType )+"', "
               + "start_date=NOW(), "
               + "end_date=TIMESTAMPADD( HOUR,"+IntToString( nHours )+",NOW() )";

        SQLExecDirect( sQuery );

        oWidget = GetItemPossessedBy( oPC, "ds_rental_item" );

        if ( !GetIsObjectValid( oWidget ) ){

             oWidget = CreateItemOnObject( "i_ds_rental_item" );
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

