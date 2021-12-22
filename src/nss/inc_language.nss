//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: inc_language
//group: chat/language
//used as: lib
//date: 2013-10-25
//author: Terrah

#include "nwnx_messages"
#include "aps_include"
#include "inc_ds_records"
#include "inc_lua"

//void main(){}

//-----------------------------------------------------------------------------
// Should be moved to other lib
//-----------------------------------------------------------------------------

string ReplaceInString( string sString, string sToReplace, string sReplaceWith );
string ReplaceInString( string sString, string sToReplace, string sReplaceWith ){

    int     nFind   = FindSubString( sString, sToReplace );
    int     nOffset = GetStringLength( sToReplace );
    string  sReturn;

    while( nFind >= 0 ){

        sReturn = GetStringLeft( sString, nFind );
        sReturn += sReplaceWith;
        sReturn += GetStringRight( sString, ( GetStringLength( sString ) - nFind ) - nOffset );
        sString = sReturn;
        nFind   = FindSubString( sString, sToReplace, nFind + nOffset );
    }

    return  sString;
}

string SQLEscapeSingleQuotes( string sString );
string SQLEscapeSingleQuotes( string sString ){

    int     nFind   = FindSubString( sString, "'" );
    if( nFind == -1 )
        return sString;

    string  sReturn;

    while( nFind >= 0 ){

        sReturn = GetStringLeft( sString, nFind );
        sReturn += "''";
        sReturn += GetStringRight( sString, ( GetStringLength( sString ) - nFind ) - 1 );
        sString = sReturn;
        nFind   = FindSubString( sString, "'", nFind + 2 );
    }

    return  sString;
}

//-----------------------------------------------------------------------------
// Proto
//-----------------------------------------------------------------------------

//Returns true if oPC is able to speak nLang
int GetKnowsLanguage( object oPC, int nLang ){return 0;}

//Adds "teaches" oPC nLang
void AddLanguageToPC( object oPC, int nLang ){}

//Removes "forgets" nLan from oPC
void RemoveLanguageFromPC( object oPC, int nLang ){}

//Broadcasts text from oSender, only works with whisper and talk
void BroadcastChat( object oSender, string sMessage, int nChannel ){}

//This writes the current settings to the database, don't run this unless neasesary
void UpdateChatAccountSettings( object oPC );

//Get the languagepoints a PC has
int GetAvailableLanguagePoints( object oPC ){return 0;}

//Returns how many languages oPC can speak
int GetNumberOfLanguagesKnown( object oPC ){return 0;}

//Broadcast chat with lua routines
void BroadcastChatLua( object oSender, string sMessage, int nChannel );

//-----------------------------------------------------------------------------
// Defs
//-----------------------------------------------------------------------------

void UpdateChatAccountSettings( object oPC ){

    string sAcc = SQLEscapeSingleQuotes( GetPCPlayerName( oPC ) );

    if( sAcc == "" )
        return;

    SQLExecDirect( "INSERT INTO `pc_account_settings` (`account`, `variable`, `value`) VALUES ('"+sAcc+"', 'chat_reverse', '"+IntToString( GetLocalInt( oPC, "chat_reverse" ) )+"') ON DUPLICATE KEY UPDATE `value`=VALUES(`value`)" );
    SQLExecDirect( "INSERT INTO `pc_account_settings` (`account`, `variable`, `value`) VALUES ('"+sAcc+"', 'chat_emote', '"+SQLEscapeSingleQuotes( GetLocalString( oPC, "chat_emote" ) )+"') ON DUPLICATE KEY UPDATE `value`=VALUES(`value`)" );
    SQLExecDirect( "INSERT INTO `pc_account_settings` (`account`, `variable`, `value`) VALUES ('"+sAcc+"', 'chat_plain', '"+IntToString( GetLocalInt( oPC, "CHAT_PLAIN" ) )+"') ON DUPLICATE KEY UPDATE `value`=VALUES(`value`)" );
}

void BroadcastChatLua( object oSender, string sMessage, int nChannel ){

    //Inherit DM properties on DM possession
    if( GetIsDMPossessed( oSender ) && GetLocalString( oSender, "DM" ) != GetPCPlayerName( oSender ) ){
        SetLocalString( oSender, "last_chat", "" );
        SetLocalString( oSender, "DM", GetPCPlayerName( oSender ) );
    }
    else if( GetIsPossessedFamiliar( oSender ) ){

        SetLocalInt( oSender, "chat_language", GetLocalInt( GetMaster( oSender ), "chat_language" ) );
        SetLocalInt( oSender, "chat_reverse", GetLocalInt( GetMaster( oSender ), "chat_reverse" ) );
        SetLocalString( oSender, "chat_emote", GetLocalString( GetMaster( oSender ), "chat_emote" ) );
    }

    location lTarget = GetLocation( oSender );

    if( FindSubString( sMessage, "[=[" ) != -1 || FindSubString( sMessage, "]=]" ) != -1 ){
        SendMessageToPC( oSender, "Chat message contains invalid symbols!" );
        SetPCChatMessage();
        return;
    }

    ExecuteLuaString( oSender, "last_said = nwn.tokanize( [=[" + sMessage + "]=] );" );

    if( GetIsDM( oSender ) ){

        ExecuteLuaString( oSender, "nwn.GetDMText( OBJECT_SELF, last_said );" );
        SetPCChatMessage( GetLocalString( oSender, "last_dm_text" ) );
        return;
    }
    else
        SetPCChatMessage();

    float MaxDist = nChannel == TALKVOLUME_WHISPER ? 3.0 : 20.0;

    object oPC = GetFirstObjectInShape( SHAPE_SPHERE, MaxDist, lTarget, FALSE, OBJECT_TYPE_ALL );

    int isDM=FALSE;

    while( GetIsObjectValid( oPC ) ){

        isDM = GetIsDM( oPC ) || GetIsDMPossessed( oPC );

        if( GetIsPC( oPC ) && ( isDM || ( GetObjectHeard( oSender, oPC ) && nChannel != TALKVOLUME_WHISPER ) || LineOfSightObject( oSender, oPC ) ) ){

            //SendMessageToPC( oSender, "Sent: "+GetName( oPC ) );
            ExecuteLuaString( oSender, "nwn.SendFromNWN( OBJECT_SELF, '"+ObjectToString(oPC)+"', "+IntToString( isDM )+", last_said, "+IntToString( nChannel+6 )+" );" );
        }

        oPC = GetNextObjectInShape( SHAPE_SPHERE, MaxDist, lTarget, FALSE, OBJECT_TYPE_ALL );
    }
}

