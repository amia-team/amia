#include "inc_language"
void main(){

    object oPC = OBJECT_SELF;
    int nNode = GetLocalInt( oPC, "ds_node" );
    int nSel = GetLocalInt( oPC, "lang_"+IntToString( nNode ) );
    SetLocalInt( oPC, "Lang_selected", nSel );
    SetCustomToken( 11111, "You are about to learn "+Messages_GetLanguageName( nSel )+"\n\nAre you sure? This cannot be undone without DM intervention!" );
}
