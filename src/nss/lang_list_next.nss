#include "inc_language"

void ForSpeak( object oPC ){

    int n;
    int nID;
    int nCur=0;


    int nStart = GetLocalInt( oPC, "lang_newpage" );
    DeleteLocalInt( oPC, "lang_newpage" );

    for( n=0;n<11;n++ ){
        SetLocalInt( oPC, "ds_check_"+IntToString( n+1 ), FALSE );
    }

    for( n=nStart+1;TRUE;n++ ){

        nID = Messages_GetLanguage(n);
        if( nID == -1 )
            break;

        if( GetKnowsLanguage( oPC, nID ) ){

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

void ForLearning( object oPC ){

    int n;
    int nID;
    int nCur=0;


    int nStart = GetLocalInt( oPC, "lang_newpage" );
    DeleteLocalInt( oPC, "lang_newpage" );

    for( n=0;n<11;n++ ){
        SetLocalInt( oPC, "ds_check_"+IntToString( n+1 ), FALSE );
    }

    for( n=nStart+1;TRUE;n++ ){

        nID = Messages_GetLanguage(n);
        if( nID == -1 )
            break;

        if( Messages_GetLanguageLevel( nID ) == 1 && !GetKnowsLanguage( oPC, nID ) ){

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

void main(){

    object oPC = GetPCSpeaker();

    if( GetLocalString( oPC, "ds_action" ) == "lang_list_sel" ){
        ForLearning( oPC );
    }
    else{
        ForSpeak( oPC );
    }
}
