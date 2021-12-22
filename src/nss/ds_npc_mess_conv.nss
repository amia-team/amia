//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:ds_npc_mess_conv
//group: npc announcements
//used as: OnConversation event
//date: 2013-10-27
//author: disco

//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------

#include "inc_ds_records"

//for reference
//type ds_npc_talk = npc starting convo on click (type 1 in database)
//type ds_npc_chat = two npc's chatting to each other on trigger (type 2 in database)
//type ds_npc_herald = herald making announcement on trigger (type 3 in database)


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC    = GetLastSpeaker();
    object oNPC   = OBJECT_SELF;
    string sAnnouncement = GetLocalString( oNPC, "chat" );
    string sToken = "";
    string sTag   = GetTag(oNPC);

    if ( sAnnouncement == "[none]" ){

        sAnnouncement = "I don't have time to talk with you right now.";
    }
    else if ( sAnnouncement == "" ){

        //it shouldn't be possible to reach the herald withotu triggering its message,
        //so I don't check that one here

        string sModule  = IntToString( GetLocalInt( GetModule(), "Module" ) );
        string sArea    = GetResRef( GetArea( oPC ) );
        string sSQL     = "SELECT message FROM npc_messages WHERE messenger = 1 AND area='"+sArea+"' AND module="+sModule;

        SQLExecDirect( sSQL );

        if ( SQLFetch( ) == SQL_SUCCESS ){

            sAnnouncement = SQLDecodeSpecialChars( SQLGetData( 1 ) );
        }
        else{

            sAnnouncement = "[none]";
        }

        SetLocalString( oNPC, "chat", sAnnouncement );
    }

    SetCustomToken( 9000, sAnnouncement );

    ActionStartConversation( oPC, "ds_npc_mess", TRUE, FALSE );
}

