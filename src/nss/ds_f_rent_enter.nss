//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_rental_enter
//group: rentable housing
//used as:area enter script
//date: 2009-09-04
//author: disco
// Editted: Angelis96, August 9th, 2018

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_rental"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC    = GetEnteringObject();
    object oHouse = OBJECT_SELF;
    object oArea = GetArea(oPC);
    object oModule  = GetModule();
    object oWidget;
    object oKey;
    string sArea = GetResRef(oArea);
    string sFactionID = sArea+"faction";
    string nArea    = GetName(GetArea( oPC ));
    string sQuery;
    string sQueryCheck;
    string sQueryDelete;
    int nModule     = GetLocalInt( oModule, "Module" );
    int nType = 10;
    int nNotExpired;
    int nNotPresent;

    if ( !GetIsPC( oPC ) ){

        return;
    }



     // First check to see if the thing is expired, and if it is take the key and widget
      sQueryCheck = "SELECT TIMESTAMPDIFF( HOUR, start_date, end_date ) "
            + "FROM faction_house WHERE "
            + "area='"+sArea + "' AND module="+IntToString( nModule )+" AND end_date < NOW()";

     SQLExecDirect( sQueryCheck );

        if ( SQLFetch() == SQL_SUCCESS ){

            if ( StringToInt( SQLGetData( 1 ) ) > 0 ){


            // Set Local variable
            SetLocalInt(oPC,"ds_check_90",0);




            oWidget = GetItemByName(oPC,nArea +" Faction Master");
            oKey  =  GetItemByName(oPC,nArea +" Faction Key");

            // Delete the faction widget if it exists
            if (GetIsObjectValid(oWidget))
            {
               DestroyObject(oWidget);
               // Delete the faction entry if it expired
               string sQueryDelete = "DELETE FROM faction_furniture WHERE faction_id='"+sFactionID+"'";
               SQLExecDirect( sQueryDelete );

            }
           // Delete the gatekey if it exists
            if (GetIsObjectValid(oKey))
            {
               DestroyObject(oKey);
            }

            }
            }
            else
            {

             nNotExpired = 1;

            }



      sQuery = "SELECT TIMESTAMPDIFF( HOUR, start_date, end_date ) "
             + "FROM faction_house WHERE "
             + "area='"+sArea + "' AND module="+IntToString( nModule )+" AND end_date > NOW()";

        SQLExecDirect( sQuery );

        if ( SQLFetch() == SQL_SUCCESS ){

            if ( StringToInt( SQLGetData( 1 ) ) > 0 )
            {

               //Set local variable
               SetLocalInt(oPC,"ds_check_90",1);
            }
        }
        else
        {
            nNotPresent = 1;

        }

       // If the rental agreement isnt expired nor is a current one present then the area isnt claimed.
       //So I remove all keys and widgets.
        if((nNotPresent == 1)&&( nNotExpired == 1))
        {
            oKey  =  GetItemByName(oPC,nArea +" Faction Key");
            oWidget = GetItemByName(oPC,nArea +" Faction Master");

            // Delete the gatekey if it exists
            if (GetIsObjectValid(oKey))
            {
               DestroyObject(oKey);
            }


            // Delete the widget if it exists
            if (GetIsObjectValid(oWidget))
            {
               DestroyObject(oWidget);
            }




        }


    //Apply the layout of a stored area
    RestoreFactionLayout();

    //store area visits
    db_onTransition( oPC, oHouse );

    //remove timestamp
    DeleteLocalInt( oHouse, RNT_TIMESTAMP );
}



