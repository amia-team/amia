#include "inc_language"
void main(){

    object oPC = OBJECT_SELF;
    int nNode = GetLocalInt( oPC, "ds_node" );
    int nSel = GetLocalInt( oPC, "lang_"+IntToString( nNode ) );
    SetLocalInt( oPC, "chat_language", nSel );
    SendMessageToPC( oPC, "You're now speaking: "+Messages_GetLanguageName( nSel ) );
}
