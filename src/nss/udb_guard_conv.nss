//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

void main()
{

    int i;
    string sName;
    string sMessage;
    int nCount = GetLocalInt( OBJECT_SELF, "udb_g_i" );
    int nTime;
    int nRuntime = NWNX_GetRunTime();

    SpeakString( "I have seen..." );
    object oPC = GetPCSpeaker();

    for ( i=0; i<nCount; ++i ){

        sName = GetLocalString( OBJECT_SELF, "udb_g_"+IntToString( i ) );
        nTime = nRuntime - GetLocalInt( OBJECT_SELF, "udb_g_"+IntToString( i ) );

        if ( nTime > 120 ){

            sMessage += IntToString( i + 1 )+". "+sName+" - "+IntToString( nTime / 60 )+" minutes ago.\n";
        }
        else{

            sMessage += IntToString( i + 1 )+". "+sName+" - "+IntToString( nTime )+" seconds ago.\n";
        }

    }

    SendMessageToPC( oPC, sMessage );
}

