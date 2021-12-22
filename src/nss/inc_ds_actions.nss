//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  inc_ds_actions
//group:   action scripting
//used as: lib
//date:    feb 02 2008
//author:  disco



//-------------------------------------------------------------------------------
// prototypes
//-------------------------------------------------------------------------------

//cleans quest system vars on a PC
//level = 1 - only cleans checks
//level = 2 - only cleans targets
//level = 3 - only cleans node
//level = 4 - cleans all
//sActionScript sets a new actionscript to call
//if sActionScript is an empty string it use previous setted actionscripts
void clean_vars( object oPC, int nLevel=1, string sActionScript = "" );



//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------

void clean_vars( object oPC, int nLevel=1, string sActionScript = "" ){

    int i;
    string sCheck;

    if ( nLevel == 3 || nLevel == 4 ){

        DeleteLocalInt( oPC, "ds_node" );
    }

    if ( nLevel == 2 || nLevel == 4 ){

        DeleteLocalInt( oPC, "ds_target" );
        DeleteLocalString( oPC, "ds_target" );
        DeleteLocalObject( oPC, "ds_target" );
        DeleteLocalLocation( oPC, "ds_target" );
    }

    if ( nLevel == 1 || nLevel == 4 ){

        for ( i=1; i<112; ++i ){

            sCheck = "ds_check_" + IntToString( i );

            DeleteLocalInt( oPC, sCheck );
        }
    }

    if ( nLevel == 4 ){

        DeleteLocalInt( oPC, "ds_section" );
        DeleteLocalInt( oPC, "ds_action" );
    }

    if( sActionScript != "" ){

        SetLocalString( oPC, "ds_action", sActionScript );
    }
}
