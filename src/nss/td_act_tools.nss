#include "aps_include"
void main(){

    object oPC = OBJECT_SELF;
    int nNode = GetLocalInt( oPC, "ds_node" );

    if( nNode == 40 ){

        int nEntries = 10;
        int nStart = GetLocalInt( oPC, "tool_next" ) * 10;

        SetLocalInt( oPC, "ds_check_40", FALSE );

        int n;
        for( n=0;n<nEntries;n++ ){

            SetLocalInt( oPC, "ds_check_"+IntToString( n+1 ), FALSE );
        }

        SQLExecDirect( "SELECT name,val FROM pwdata WHERE player='-' AND tag ='TOOL_LIST' LIMIT "+IntToString( nStart )+",10" );

        n=0;
        while( SQLFetch() ){

            SetCustomToken( 48110+(n++), SQLGetData( 1 ) );
            SetLocalInt( oPC, "ds_check_"+IntToString( n ), TRUE );
            SetLocalString( oPC, "tool_list_"+IntToString( n ), SQLGetData( 2 ) );
            if( n == nEntries ){
                SetLocalInt( oPC, "tool_next", GetLocalInt( oPC, "tool_next" ) + 1 );
                break;
            }
        }
    }
    else{

        string sResRef = GetLocalString( oPC, "tool_list_"+IntToString( nNode ) );

        object oItem = CreateItemOnObject( sResRef, oPC );
        if( !GetIsObjectValid( oItem ) ){
            SendMessageToPC( oPC, "Failed to spawn: " + sResRef );
        }
    }
}
