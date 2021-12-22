//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_dc_rod
//group:   Dream Coin system
//used as: PC DC rod activation script
//date:    apr 15 2007
//author:  disco



//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------

//get number of coins on account
int GetAccount( object oTarget, object oUser );

//gives a DC
void GiveOneDC( object  oTarget, object oUser );

//fires when you open the jump to convo
void SetSelection( object oUser );

// utility function
void GetSectionIsAvailable( object oUser, object oOnlinePC );

// utility function
void CleanUpVars( object oUser );

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    object oUser = GetPCSpeaker();

    CleanUpVars( oUser );

    //set customs
    SetSelection( oUser );

    return;
}

//fires when you open the convo
void SetSelection( object oUser ){

    int nTotalPCs    = 0;

    //loop through all PCs
    object oOnlinePC = GetFirstPC();

    while ( GetIsObjectValid( oOnlinePC ) == TRUE ){

        int nSuggested = GetLocalInt( oOnlinePC, "dc_recommended" );

        //select correct PCs
        if ( nSuggested > 0 ){

            nTotalPCs++;

            GetSectionIsAvailable( oUser, oOnlinePC );
        }

        oOnlinePC = GetNextPC();
    }

    SetCustomToken( 4005 , IntToString( nTotalPCs ) );
}

// utility function
void GetSectionIsAvailable( object oUser, object oOnlinePC ){

    string sSection = GetSubString( GetStringLowerCase( GetName ( oOnlinePC ) ), 0, 1 );

    if ( sSection == "a" ) { SetLocalInt( oUser, "ds_check_1", 1 ); return; }
    if ( sSection == "b" ) { SetLocalInt( oUser, "ds_check_2", 1 ); return; }
    if ( sSection == "c" ) { SetLocalInt( oUser, "ds_check_3", 1 ); return; }
    if ( sSection == "d" ) { SetLocalInt( oUser, "ds_check_4", 1 ); return; }
    if ( sSection == "e" ) { SetLocalInt( oUser, "ds_check_5", 1 ); return; }
    if ( sSection == "f" ) { SetLocalInt( oUser, "ds_check_6", 1 ); return; }
    if ( sSection == "g" ) { SetLocalInt( oUser, "ds_check_7", 1 ); return; }
    if ( sSection == "h" ) { SetLocalInt( oUser, "ds_check_8", 1 ); return; }
    if ( sSection == "i" ) { SetLocalInt( oUser, "ds_check_9", 1 ); return; }
    if ( sSection == "j" ) { SetLocalInt( oUser, "ds_check_10", 1 ); return; }
    if ( sSection == "k" ) { SetLocalInt( oUser, "ds_check_11", 1 ); return; }
    if ( sSection == "l" ) { SetLocalInt( oUser, "ds_check_12", 1 ); return; }
    if ( sSection == "m" ) { SetLocalInt( oUser, "ds_check_13", 1 ); return; }
    if ( sSection == "n" ) { SetLocalInt( oUser, "ds_check_14", 1 ); return; }
    if ( sSection == "o" ) { SetLocalInt( oUser, "ds_check_15", 1 ); return; }
    if ( sSection == "p" ) { SetLocalInt( oUser, "ds_check_16", 1 ); return; }
    if ( sSection == "q" ) { SetLocalInt( oUser, "ds_check_17", 1 ); return; }
    if ( sSection == "r" ) { SetLocalInt( oUser, "ds_check_18", 1 ); return; }
    if ( sSection == "s" ) { SetLocalInt( oUser, "ds_check_19", 1 ); return; }
    if ( sSection == "t" ) { SetLocalInt( oUser, "ds_check_20", 1 ); return; }
    if ( sSection == "u" ) { SetLocalInt( oUser, "ds_check_21", 1 ); return; }
    if ( sSection == "v" ) { SetLocalInt( oUser, "ds_check_22", 1 ); return; }
    if ( sSection == "w" ) { SetLocalInt( oUser, "ds_check_23", 1 ); return; }
    if ( sSection == "x" ) { SetLocalInt( oUser, "ds_check_24", 1 ); return; }
    if ( sSection == "y" ) { SetLocalInt( oUser, "ds_check_25", 1 ); return; }
    if ( sSection == "z" ) { SetLocalInt( oUser, "ds_check_26", 1 ); return; }

    if ( !TestStringAgainstPattern( "*a", sSection ) ) { SetLocalInt( oUser, "ds_check_27", 1 ); return; }

}

//fires when a convo is closed
void CleanUpVars( object oUser ){

    int i = 0;

    DeleteLocalInt( oUser, "ds_action" );
    DeleteLocalInt( oUser, "ds_target" );

    for ( i = 1; i < 28; ++i ) {

        DeleteLocalObject( oUser, "ds_pc_"+IntToString( i ) );
        DeleteLocalObject( oUser, "ds_check_"+IntToString( i ) );
        DeleteLocalInt( oUser, "ds_section_"+IntToString( i ) );
    }
}
