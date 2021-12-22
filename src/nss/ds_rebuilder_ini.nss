//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_rebuilder_ini
//group:   dm tools
//used as: ini script
//date:    oct 25 2009
//author:  disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "inc_ds_actions"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oDM      = OBJECT_SELF;
    object oTarget  = GetLocalObject( oDM, "ds_target" );
    string sAccounts = "<cþþ >";
    int nType;
    string sType;

    clean_vars( oDM, 4 );

    //check for previous rebuilds
    string sQuery = "SELECT account, pcname, DATE_FORMAT(insert_at, '%a %e %b %Y'), dm, type, QUARTER(insert_at) FROM player_rebuild WHERE  cdkey='"+GetPCPublicCDKey( oTarget, TRUE )
                   +"' AND TIMESTAMPDIFF( YEAR, insert_at, NOW()) < 1 ORDER BY insert_at DESC";

    SQLExecDirect( sQuery );

    while ( SQLFetch() == SQL_SUCCESS ){

        nType =  StringToInt( SQLGetData( 5 ) );

        switch ( nType ) {

            case 1: sType = "Quarterly Rebuild";    break;
            case 2: sType = "Full Paid Rebuild";    break;
            case 3: sType = "Bugged Character";     break;
            case 4: sType = "Self Rebuild";         break;
            case 5: sType = "Other";                break;
            case 6: sType = "Partial Paid Rebuild";    break;
        }

        sAccounts  += "\n\nPC: "+SQLDecodeSpecialChars( SQLGetData( 2 ) )+"\nAccount: "+SQLDecodeSpecialChars( SQLGetData( 1 ) )+"\nDate: "+SQLGetData( 3 )+", Q"+SQLGetData( 6 )+"\nDM: "+SQLGetData( 4 )+"\nType: "+sType;
    }

    if ( sAccounts != "<cþþ >" ){

        SetCustomToken( 4502, sAccounts+"</c>" );
        SetLocalInt( oDM, "ds_check_1", 1 );
    }

    //start convo
    SetLocalString( oDM, "ds_action", "ds_rebuilder_act" );
    SetCustomToken( 4501, GetName( oTarget ) );
    SetLocalObject( oDM, "ds_target", oTarget );

    ActionStartConversation( oDM, "ds_rebuilder", TRUE, FALSE );
}

