//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_playerlist
//group:   rest menu
//date:    2008-10-17
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    int nModule = GetLocalInt( GetModule(), "Module" );
    object oPC  = GetPCSpeaker();
    string sSQL;
    string sPC;
    string sAccount;
    string sArea;
    int i;

    if ( nModule == 1 ){

        nModule = 2;
    }
    else{

        nModule = 1;
    }

    if ( !GetIsDM( oPC ) ){

        sSQL = "SELECT account, pc FROM player_runtime WHERE state = " + IntToString( nModule ) + " ORDER BY pc";

        SQLExecDirect( sSQL );

        while( SQLFetch( ) == SQL_SUCCESS ){

            ++i;

            sAccount = SQLDecodeSpecialChars( SQLGetData( 1 ) );
            sPC      = SQLDecodeSpecialChars( SQLGetData( 2 ) );

            if ( sPC == "DM Avatar" ){

                SendMessageToPC( oPC, IntToString( i )+". <cþ þ>"+sPC+"</c>" );
            }
            else{

                SendMessageToPC( oPC, IntToString( i )+". <c þþ>"+sPC+"</c>, "+sAccount );
            }
        }
    }
    else{

        sSQL = "SELECT account, pc, area FROM player_runtime WHERE state = " + IntToString( nModule ) + " ORDER BY pc";

        SQLExecDirect( sSQL );

        while( SQLFetch( ) == SQL_SUCCESS ){

            ++i;

            sAccount = SQLDecodeSpecialChars( SQLGetData( 1 ) );
            sPC      = SQLDecodeSpecialChars( SQLGetData( 2 ) );
            sArea    = SQLDecodeSpecialChars( SQLGetData( 3 ) );

            SendMessageToPC( oPC, "<c¥¥¥>"+IntToString( i )+". </c>"+sPC+"<c¥¥¥>, "+sAccount+"</c>" );
            SendMessageToPC( oPC, "   <c¥¥¥>Area: </c><c¥¥ >"+sArea+"</c>" );
        }

    }
}
