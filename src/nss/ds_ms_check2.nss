//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_ms_check2
//group:   messenger
//used as: checks for more messages
//date:    feb 27 2008
//author:  disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

int StartingConditional(){

    int nMessages = GetLocalInt( GetPCSpeaker(), "ds_ms_cnt" );

    SetCustomToken( 4305, IntToString( nMessages ) );

    if ( nMessages > 0 ){

        return TRUE;
    }
    else{

        return FALSE;
    }
}

