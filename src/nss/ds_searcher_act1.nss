//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_searcher_act1
//group:   PC searcher widget
//used as: action script on first node
//date:    jan 10 2007
//author:  disco

//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

// fires when you select a section
void SetCharSelection( object oPC, int nNode );

// utility function
int GetPlayersInSection( object oOnlinePC, int nNode );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main(){

     object oPC = OBJECT_SELF;
     int nNode  = GetLocalInt( oPC, "ds_node" );

     //set action script on second node
     SetLocalString( oPC, "ds_action", "ds_searcher_act2" );

     SetCharSelection( oPC, nNode );
}

//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------

// fires when you select a section
void SetCharSelection( object oPC, int nNode ){

     int nTotalPCs    = 0;
     int nSelectedPCs = 0;
     int i            = 0;

     //loop through all PCs
     object oOnlinePC = GetFirstPC();

     while ( GetIsObjectValid( oOnlinePC ) == TRUE ){

          nTotalPCs++;

          //select correct PCs
          if ( GetPlayersInSection( oOnlinePC, nNode ) == TRUE ){

               nSelectedPCs++;

               SetLocalObject( oPC, "ds_pc_"+IntToString( nSelectedPCs ), oOnlinePC );
               SetLocalInt( oPC, "ds_check_"+IntToString( nSelectedPCs ), 1 );
               SetCustomToken( ( 4000 + nSelectedPCs ), GetName ( oOnlinePC )+" (Lvl "+IntToString( GetHitDice( oOnlinePC ) )+", "+ GetName ( GetArea( oOnlinePC ) )+")" );
          }

          oOnlinePC = GetNextPC();

     }

     nSelectedPCs++;

     //clean up unused stored variables
     for ( i = nSelectedPCs; i < 28; ++i ) {

          DeleteLocalObject( oPC, "ds_pc_"+IntToString( i ) );
          DeleteLocalInt( oPC, "ds_check_"+IntToString( i ) );
          SetCustomToken( ( 4000 + i ), "" );

     }
}

// utility function
int GetPlayersInSection( object oOnlinePC, int nNode ){

     string sSection = GetStringLowerCase( GetSubString( GetName ( oOnlinePC ), 0, 1 ) );

     if ( sSection == "a" && nNode == 1 ){ return TRUE; }
     if ( sSection == "b" && nNode == 2 ){ return TRUE; }
     if ( sSection == "c" && nNode == 3 ){ return TRUE; }
     if ( sSection == "d" && nNode == 4 ){ return TRUE; }
     if ( sSection == "e" && nNode == 5 ){ return TRUE; }
     if ( sSection == "f" && nNode == 6 ){ return TRUE; }
     if ( sSection == "g" && nNode == 7 ){ return TRUE; }
     if ( sSection == "h" && nNode == 8 ){ return TRUE; }
     if ( sSection == "i" && nNode == 9 ){ return TRUE; }
     if ( sSection == "j" && nNode == 10 ){ return TRUE; }
     if ( sSection == "k" && nNode == 11 ){ return TRUE; }
     if ( sSection == "l" && nNode == 12 ){ return TRUE; }
     if ( sSection == "m" && nNode == 13 ){ return TRUE; }
     if ( sSection == "n" && nNode == 14 ){ return TRUE; }
     if ( sSection == "o" && nNode == 15 ){ return TRUE; }
     if ( sSection == "p" && nNode == 16 ){ return TRUE; }
     if ( sSection == "q" && nNode == 17 ){ return TRUE; }
     if ( sSection == "r" && nNode == 18 ){ return TRUE; }
     if ( sSection == "s" && nNode == 19 ){ return TRUE; }
     if ( sSection == "t" && nNode == 20 ){ return TRUE; }
     if ( sSection == "u" && nNode == 21 ){ return TRUE; }
     if ( sSection == "v" && nNode == 22 ){ return TRUE; }
     if ( sSection == "w" && nNode == 23 ){ return TRUE; }
     if ( sSection == "x" && nNode == 24 ){ return TRUE; }
     if ( sSection == "y" && nNode == 25 ){ return TRUE; }
     if ( sSection == "z" && nNode == 26 ){ return TRUE; }
     if ( !TestStringAgainstPattern( "*a", sSection ) && nNode == 27 ){ return TRUE; }

     return FALSE;
}


