//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_searcher_clean
//group:   PC searcher widget
//used as: action script on exit
//date:    jan 10 2007
//author:  disco

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//fires when a convo is closed
void CleanUpVars( object oPC );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main(){

     object oPC = GetPCSpeaker();

     CleanUpVars( oPC );
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------

//fires when a convo is closed
void CleanUpVars( object oPC ){

    int i = 0;

    for ( i = 1; i < 28; ++i ) {

          DeleteLocalObject( oPC, "ds_pc_"+IntToString( i ) );
          DeleteLocalInt( oPC, "ds_section_"+IntToString( i ) );
          DeleteLocalInt( oPC, "ds_check_" + IntToString( i ) );
          SetCustomToken( ( 4000 + i ), "" );
    }

    DeleteLocalInt( oPC, "ds_node" );
    DeleteLocalInt( oPC, "ds_action" );
    DeleteLocalInt( oPC, "ds_target" );

    //Unblock widget
    SetLocalInt( GetModule(), "ds_pc_searcher", 0 );

}

