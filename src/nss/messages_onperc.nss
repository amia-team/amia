/*  messages_onperc

--------
Verbatim
--------
Collects messages from database, stores them on the NPC and speaks one of them when a PC OnPerception is triggered.


---------
Changelog
---------

Date        Name        Reason
------------------------------------------------------------------
2006-11-04  Disco       Start of header
2007-09-10  Disco       Check if a message is actually a string
------------------------------------------------------------------

*/


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "aps_include"
#include "amia_include"

//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    //variables
    int i;
    int nResult;
    int nCount = GetLocalInt( OBJECT_SELF, "m_cnt");
    string sVariable;
    string sMessage;

    if ( GetIsBlocked( OBJECT_SELF ) <= 0 && d20() == 5 ){

        SetBlockTime( OBJECT_SELF, 10, 0 );

        if ( !nCount ){

            //SQLExecDirect( "SELECT * FROM messages WHERE caller_tag='ds_announcer' LIMIT 1" );
            SQLExecDirect( "SELECT message FROM messages WHERE caller_tag='"+GetTag(OBJECT_SELF)+"' AND active = 'yes'" );

            while ( SQLFetch( ) == SQL_SUCCESS ) {

                sMessage  = SQLGetData( 1 );

                if ( sMessage != "" ){

                    ++i;
                    sVariable = "m_"+IntToString(i);
                    SetLocalString( OBJECT_SELF, sVariable, SQLDecodeSpecialChars( sMessage ) );
                }
            }

            SetLocalInt( OBJECT_SELF, "m_cnt", i );
            nCount = i;
            //SpeakString( "[Loaded "+IntToString(i)+" messages from database]", TALKVOLUME_WHISPER );

        }

        sVariable = "m_"+IntToString( 1 + Random( nCount ) );
        sMessage  = GetLocalString( OBJECT_SELF, sVariable );

        if ( sMessage != "" ){

            SpeakString( sMessage );
        }
    }

}


//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

