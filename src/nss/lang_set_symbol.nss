#include "nwnx_messages"
void main( ){

    object oPC = GetPCSpeaker();
    string sMessage = GetLocalString( oPC, "last_chat" );

    if( GetStringLength( sMessage ) > 1 || GetStringLength( sMessage ) <= 0 ){
        SendMessageToPC( oPC, sMessage+" is  to be used as the emote symbol!" );
        return;
    }
    else if( sMessage == DoubleQuote() ){
        SendMessageToPC( oPC, "You are now set to denote speech with doublequotes!" );
        SetLocalInt( oPC, "chat_reverse", TRUE );
    }
    else{
        SendMessageToPC( oPC, sMessage+" has been set to the emote symbol!" );
        SetLocalInt( oPC, "chat_reverse", FALSE );
    }

    SetLocalString( oPC, "chat_emote", sMessage );
}
