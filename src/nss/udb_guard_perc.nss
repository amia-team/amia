//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

void main()
{
    object oPC = GetLastPerceived();
    string sPCName = GetName( oPC );
    string sName;
    int i;
    int nCount = GetLocalInt( OBJECT_SELF, "udb_g_i" );

    if ( GetLastPerceptionSeen() && GetIsPC( oPC ) ){

        for ( i=0; i<nCount; ++i ){

            sName = GetLocalString( OBJECT_SELF, "udb_g_"+IntToString( i ) );

            if ( sName == sPCName ){

                break;
            }
        }

        if ( sName != sPCName ){

            SendMessageToPC( oPC, "*identifies you*" );

            TurnToFaceObject( oPC );

            SetLocalString( OBJECT_SELF, "udb_g_"+IntToString( i ), sPCName );
            SetLocalInt( OBJECT_SELF, "udb_g_"+IntToString( i ), NWNX_GetRunTime() );
            SetLocalInt( OBJECT_SELF, "udb_g_i", nCount + 1 );


        }
    }
}

