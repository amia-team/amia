const string EX_MEM = "                                                                                                                                                                                                                                                                   ";

//Send a message though the talk channel
//Only oReceiver will see the message
int Messages_SendTalk( object oSender, object oReceiver, string sMessage );

//Send a message though the whisper channel
//Only oReceiver will see the message
int Messages_SendWhisper( object oSender, object oReceiver, string sMessage );

//Send a message though the party channel
//Only oReceiver will see the message
int Messages_SendParty( object oSender, object oReceiver, string sMessage );

//Send a message though the tell channel
//Only oReceiver will see the message
int Messages_SendTell( object oSender, object oReceiver, string sMessage );

//Send a message though the shout channel
//Only oReceiver will see the message
int Messages_SendShout( object oSender, object oReceiver, string sMessage );

//Send a message though the dm channel
//Only oReceiver will see the message
int Messages_SendDMChannel( object oSender, object oReceiver, string sMessage );

//Scramble the message according to nLanguage ID
//sEmoteSym will denote emoting and scrambling will not occur on text within
//nReverse will reverse and scrambling will only occur within the emotesymbols
//sHead will be applied before emotes
//sTail will be applied after emotes
string Messages_Scramble( string sMessage, int nLangugeID, string sEmoteSym, int nReverse, string sHead, string sTail );

//Get the language ID of sLanguage (not case sensetive)
int Messages_GetLanguageID( string sLang );

//Get the language level as defined in the language definition
int Messages_GetLanguageLevel( int nLanguageID );

//Get the name of the language
string Messages_GetLanguageName( int nLanguageID );

//Returns the language ID corresponding to the index given
//Returns -1 on error
int Messages_GetLanguage( int nIndex );

//Returns a double-quote
string DoubleQuote();

string DoubleQuote(){

    SetLocalString( OBJECT_SELF, "NWNX!MESSAGES!12", "*" );
    string s = GetLocalString( OBJECT_SELF, "NWNX!MESSAGES!12" );
    DeleteLocalString( OBJECT_SELF, "NWNX!MESSAGES!12" );
    return s;
}

int Messages_GetLanguage( int nIndex ){

    SetLocalString( OBJECT_SELF, "NWNX!MESSAGES!11", IntToString( nIndex )+"              " );
    int nRet = StringToInt( GetLocalString( OBJECT_SELF, "NWNX!MESSAGES!11" ) );
    DeleteLocalString( OBJECT_SELF, "NWNX!MESSAGES!11" );
    return nRet;
}

string Messages_GetLanguageName( int nLanguageID ){

    SetLocalString( OBJECT_SELF, "NWNX!MESSAGES!10", IntToString(nLanguageID)+EX_MEM );
    string nRet = GetLocalString( OBJECT_SELF, "NWNX!MESSAGES!10" );
    DeleteLocalString( OBJECT_SELF, "NWNX!MESSAGES!10" );
    return nRet;
}

int Messages_GetLanguageLevel( int nLanguageID ){

    SetLocalString( OBJECT_SELF, "NWNX!MESSAGES!9", IntToString( nLanguageID )+"              " );
    int nRet = StringToInt( GetLocalString( OBJECT_SELF, "NWNX!MESSAGES!9" ) );
    DeleteLocalString( OBJECT_SELF, "NWNX!MESSAGES!9" );
    return nRet;
}

int Messages_GetLanguageID( string sLang ){

    SetLocalString( OBJECT_SELF, "NWNX!MESSAGES!8", sLang );
    int nRet = StringToInt( GetLocalString( OBJECT_SELF, "NWNX!MESSAGES!8" ) );
    DeleteLocalString( OBJECT_SELF, "NWNX!MESSAGES!8" );
    return nRet;
}

string Messages_Scramble( string sMessage, int nLangugeID, string sEmoteSym, int nReverse, string sHead, string sTail ){

    SetLocalString( OBJECT_SELF, "NWNX!MESSAGES!7", IntToString(nReverse)+"|"+sEmoteSym+"|"+IntToString( nLangugeID )+"|"+sHead+"|"+sTail+"|"+sMessage+"|"+EX_MEM );
    string nRet = GetLocalString( OBJECT_SELF, "NWNX!MESSAGES!7" );
    DeleteLocalString( OBJECT_SELF, "NWNX!MESSAGES!7" );
    return nRet;
}

int Messages_SendTalk( object oSender, object oReceiver, string sMessage ){

    SetLocalString( oReceiver, "NWNX!MESSAGES!1", ObjectToString( oSender )+" "+sMessage );
    int nRet = StringToInt( GetLocalString( oReceiver, "NWNX!MESSAGES!1" ) );
    DeleteLocalString( oReceiver, "NWNX!MESSAGES!1" );
    return nRet;
}

int Messages_SendWhisper( object oSender, object oReceiver, string sMessage ){

    SetLocalString( oReceiver, "NWNX!MESSAGES!2", ObjectToString( oSender )+" "+sMessage );
    int nRet = StringToInt( GetLocalString( oReceiver, "NWNX!MESSAGES!2" ) );
    DeleteLocalString( oReceiver, "NWNX!MESSAGES!2" );
    return nRet;
}

int Messages_SendParty( object oSender, object oReceiver, string sMessage ){

    SetLocalString( oReceiver, "NWNX!MESSAGES!3", ObjectToString( oSender )+" "+sMessage );
    int nRet = StringToInt( GetLocalString( oReceiver, "NWNX!MESSAGES!3" ) );
    DeleteLocalString( oReceiver, "NWNX!MESSAGES!3" );
    return nRet;
}

int Messages_SendTell( object oSender, object oReceiver, string sMessage ){

    SetLocalString( oReceiver, "NWNX!MESSAGES!4", ObjectToString( oSender )+" "+sMessage );
    int nRet = StringToInt( GetLocalString( oReceiver, "NWNX!MESSAGES!4" ) );
    DeleteLocalString( oReceiver, "NWNX!MESSAGES!4" );
    return nRet;
}

int Messages_SendShout( object oSender, object oReceiver, string sMessage ){

    SetLocalString( oReceiver, "NWNX!MESSAGES!5", ObjectToString( oSender )+" "+sMessage );
    int nRet = StringToInt( GetLocalString( oReceiver, "NWNX!MESSAGES!5" ) );
    DeleteLocalString( oReceiver, "NWNX!MESSAGES!5" );
    return nRet;
}

int Messages_SendDMChannel( object oSender, object oReceiver, string sMessage ){

    SetLocalString( oReceiver, "NWNX!MESSAGES!6", ObjectToString( oSender )+" "+sMessage );
    int nRet = StringToInt( GetLocalString( oReceiver, "NWNX!MESSAGES!6" ) );
    DeleteLocalString( oReceiver, "NWNX!MESSAGES!6" );
    return nRet;
}
