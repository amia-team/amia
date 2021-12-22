#include "inc_language"
void main(){

    int n;
    int nID;
    int nCur=0;
    object oPC = GetPCSpeaker();

    DeleteLocalInt( oPC, "lang_newpage" );
    DeleteLocalInt( oPC, "lang_back" );
    SetLocalString( oPC, "ds_action", "lang_spk" );

    for( n=0;n<11;n++ ){
        SetLocalInt( oPC, "ds_check_"+IntToString( n+1 ), FALSE );
    }

    //SendMessageToPC( oPC, "---" );

    for( n=0;TRUE;n++ ){

        nID = Messages_GetLanguage(n);
        if( nID == -1 )
            break;

        if( GetKnowsLanguage( oPC, nID ) ){

            //SendMessageToPC( oPC, Messages_GetLanguageName( nID ) );

            SetLocalInt( oPC, "ds_check_"+IntToString( nCur+1 ), TRUE );
            SetCustomToken( 11110+nCur, Messages_GetLanguageName( nID ) );
            SetLocalInt( oPC, "lang_"+IntToString( nCur+1 ), nID );
            nCur++;
            if( nCur == 10 ){
                SetLocalInt( oPC, "ds_check_11", TRUE );
                SetLocalInt( oPC, "lang_newpage", n );
                return;
            }
        }
    }
}
