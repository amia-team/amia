//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_trans_actions
//group:   transmutation
//used as: action script
//date:    apr 02 2007
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_bank"


void main()
{


    object oPC       = OBJECT_SELF;
    int nNode        = GetLocalInt( oPC, "ds_node" );
    int nSection     = GetLocalInt( oPC, "ds_section" );
    int nStart       = 0;
    int nEnd         = 0;
    string sPCKEY    = GetName( GetPCKEY( oPC ) );
    string sList;
    string sQuery;
    string sKey;
    int i;
    int nQuotum      = GetPCKEYValue( oPC, "ds_storage" );

    //SpeakString( "node="+IntToString( nNode ) );
    //SpeakString( "section="+IntToString( nSection ) );

    if ( sPCKEY == "" ){

        SendMessageToPC( oPC, "No PCKEY found on you." );

        return;
    }


    if ( nNode >= 1 && nNode <= 10 ){

        nStart = nSection + nNode - 1;
        nEnd   = 1;

        sQuery = "SELECT item_key FROM player_storage WHERE pckey = '"+sPCKEY+"' ORDER BY item_name LIMIT "+IntToString(nStart)+","+IntToString(nEnd);

        //execute
        SQLExecDirect( sQuery );

        if ( SQLFetch() == SQL_SUCCESS ){

            sKey = SQLGetData( 1 );

            sQuery = "SELECT item_data FROM player_storage WHERE pckey = '" + sPCKEY + "' AND item_key = '" + sKey + "' LIMIT 1";

            //execute
            SetLocalString( GetModule(), "NWNX!ODBC!SETSCORCOSQL", sQuery );

            //sql hooks into BioWare campaign DB stuff
            object oItem =  RetrieveCampaignObject ("NWNX", "-", GetLocation( oPC ), oPC );

            //check object valid
            if ( !GetIsObjectValid( oItem ) ){

                SendMessageToPC( oPC, "Argghhh! Something went wrong!." );
            }
            else{

                sQuery = "DELETE FROM player_storage WHERE pckey = '" + sPCKEY + "' AND item_key = '" + sKey + "' LIMIT 1";

                SQLExecDirect( sQuery );

                if ( nQuotum == 0 ){

                    TakeGoldFromCreature( 5, oPC, TRUE );
                }
            }
        }

        nNode = 13;
    }

    if ( nNode == 11 ){

        nStart = nSection + 10;
        nEnd   = nSection + 21;

        SetLocalInt( oPC, "ds_section", nStart );

        sQuery = "SELECT item_name, DATE_FORMAT( insert_at, '%d %b %Y' ) as date FROM player_storage WHERE pckey = '"+sPCKEY+"' ORDER BY item_name LIMIT "+IntToString(nStart)+","+IntToString(nEnd);

        //execute
        SQLExecDirect( sQuery );

        for ( i=1; i<=11; ++i ){

            if ( SQLFetch() == SQL_SUCCESS ){

                sList = SQLDecodeSpecialChars( SQLGetData( 1 ) );

                SetCustomToken( ( 4360 + i ), sList );

                SetLocalInt( oPC, "ds_check_"+IntToString( i ), 1 );
            }
            else{

                SetLocalInt( oPC, "ds_check_"+IntToString( i ), 0 );
            }
        }

        SetLocalInt( oPC, "ds_check_12", 1 );

        SetCustomToken( 4350, GetName( oPC ) );
    }
    else if ( nNode == 12 ){

        nStart = nSection - 10;
        nEnd   = nSection + 1;

        SetLocalInt( oPC, "ds_section", nStart );

        sQuery = "SELECT item_name, DATE_FORMAT( insert_at, '%d %b %Y' ) as date FROM player_storage WHERE pckey = '"+sPCKEY+"' ORDER BY item_name LIMIT "+IntToString(nStart)+","+IntToString(nEnd);

        //execute
        SQLExecDirect( sQuery );

        for ( i=1; i<=11; ++i ){

            if ( SQLFetch() == SQL_SUCCESS ){

                sList = SQLDecodeSpecialChars( SQLGetData( 1 ) );

                SetCustomToken( ( 4360 + i ), sList );

                SetLocalInt( oPC, "ds_check_"+IntToString( i ), 1 );
            }
            else{

                SetLocalInt( oPC, "ds_check_"+IntToString( i ), 0 );
            }
        }

        if ( nSection > 10 ){

            SetLocalInt( oPC, "ds_check_12", 1 );
        }
        else{

            SetLocalInt( oPC, "ds_check_12", 0 );
        }

        SetCustomToken( 4350, GetName( oPC ) );
    }
    else if ( nNode == 13 ){

        nStart = 0;
        nEnd   = 11;

        SetLocalInt( oPC, "ds_section", 0 );

        sQuery = "SELECT item_name, DATE_FORMAT( insert_at, '%d %b %Y' ) as date FROM player_storage WHERE pckey = '"+sPCKEY+"' ORDER BY item_name LIMIT "+IntToString(nStart)+","+IntToString(nEnd);

        //execute
        SQLExecDirect( sQuery );

        for ( i=1; i<=11; ++i ){

            if ( SQLFetch() == SQL_SUCCESS ){

                sList = SQLDecodeSpecialChars( SQLGetData( 1 ) )+"\n";

                SetCustomToken( ( 4360 + i ), sList );

                SetLocalInt( oPC, "ds_check_"+IntToString( i ), 1 );
            }
            else{

                SetLocalInt( oPC, "ds_check_"+IntToString( i ), 0 );
            }
        }

        SetLocalInt( oPC, "ds_check_12", 0 );

        SetCustomToken( 4350, GetName( oPC ) );
    }
    else if ( nNode == 14 ){

        sQuery = "SELECT item_name, DATE_FORMAT( insert_at, '%d %b %Y' ) as date FROM player_storage WHERE pckey = '"+sPCKEY+"'ORDER BY item_name ";

        //execute
        SQLExecDirect( sQuery );

        while ( SQLFetch() == SQL_SUCCESS ){

            ++i;

            sList += SQLDecodeSpecialChars( SQLGetData( 1 ) )+" ("+SQLGetData( 2 )+"\n";
        }

        SetCustomToken( 4350, GetName( oPC ) );

        SetCustomToken( 4351, sList );
    }
    else if ( nNode == 15 ){

        if ( nQuotum == 10 ){

            SetLocalInt( oPC, "ds_check_16", 0 );
            SetLocalInt( oPC, "ds_check_17", 1 );
            SetLocalInt( oPC, "ds_check_18", 0 );
        }
        else if ( nQuotum == 20 ){

            SetLocalInt( oPC, "ds_check_16", 0 );
            SetLocalInt( oPC, "ds_check_17", 0 );
            SetLocalInt( oPC, "ds_check_18", 1 );
        }
        else if ( nQuotum == 30 ){

            SetLocalInt( oPC, "ds_check_16", 0 );
            SetLocalInt( oPC, "ds_check_17", 0 );
            SetLocalInt( oPC, "ds_check_18", 0 );
        }
        else {

            SetLocalInt( oPC, "ds_check_16", 1 );
            SetLocalInt( oPC, "ds_check_17", 0 );
            SetLocalInt( oPC, "ds_check_18", 0 );
        }
    }
    else if ( nNode == 16 ){

        if ( GetGold( oPC ) > 10000 ){

            TakeGoldFromCreature( 10000, oPC, TRUE );

            SetPCKEYValue( oPC, "ds_storage", 10 );

            SpeakString( "Hurray! You have become a Gold Member!" );
        }
        else{

            SpeakString( "You don't have that kind of money on you..." );
        }
    }
    else if ( nNode == 17 ){

        if ( GetGold( oPC ) > 100000 ){

            TakeGoldFromCreature( 100000, oPC, TRUE );

            SetPCKEYValue( oPC, "ds_storage", 20 );

            SpeakString( "Hurray! You have become a Platinum Member!" );
        }
        else{

            SpeakString( "You don't have that kind of money on you..." );
        }
    }
    else if ( nNode == 18 ){

        if ( GetGold( oPC ) > 1000000 ){

            TakeGoldFromCreature( 1000000, oPC, TRUE );

            SetPCKEYValue( oPC, "ds_storage", 30 );

            SpeakString( "Hurray! You have become an Insane Member!" );
        }
        else{

            SpeakString( "You don't have that kind of money on you..." );
        }
    }
}
