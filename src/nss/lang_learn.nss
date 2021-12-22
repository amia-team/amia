#include "inc_language"
void main(){

    object oPC = GetPCSpeaker();
    int nLang = GetLocalInt( oPC, "Lang_selected" );
    DeleteLocalInt( oPC, "Lang_selected" );

    if( GetAvailableLanguagePoints( oPC ) <= 0 ){
        SendMessageToPC( oPC, "Not enough language points!" );
        return;
    }

    AddLanguageToPC( oPC, nLang );
    SendMessageToPC( oPC, "Added language: ("+IntToString(nLang)+") "+Messages_GetLanguageName( nLang ) );
    //UpdateChatAccountSettings( oPC );
    SendMessageToPC( oPC, "<cþ þ>THIS IS CURRENTLY IN TESTING! LEARNING LANGUAGES IS NOT PREMANENT YET!</c>" );
}
