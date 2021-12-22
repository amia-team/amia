//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: khm_ds_travel
//group: travel
//used as: onconvo script
//date: 2008-09-13
//author: disco


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){


    object oPC          = GetLastSpeaker();
    object oNPC         = OBJECT_SELF;
    string sGreeting    = GetLocalString( oNPC, "ds_greeting" );
    string sGoal        = GetLocalString( oNPC, "ds_goal" );
    string sWP          = GetLocalString( oNPC, "ds_wp" );
    int nPrice          = GetLocalInt( oNPC, "ds_price" );
    int nDC             = GetLocalInt( oNPC, "ds_dc" );
    int nMode           = GetLocalInt( oNPC, GetPCPublicCDKey( oPC, TRUE ) );

    if ( !nDC ){

        nDC   = 12 + d6();
        SetLocalInt( oNPC, "ds_dc", nDC );
    }

    if ( sGreeting == "" ){

        sGreeting = "Hello there!";
    }

    SetCustomToken( 4901, sGreeting );

    if ( sGoal == "" || sWP == "" ){

        DeleteLocalInt( oPC, "ds_check_1" );
    }
    else{

        SetLocalInt( oPC, "ds_check_1", 1 );
        SetCustomToken( 4902, sGoal );
    }


    if ( !nPrice ){

        SetCustomToken( 4903, "5" );
        SetLocalInt( oNPC, "ds_price", nPrice );
    }
    else{

        SetCustomToken( 4903, IntToString( nPrice ) );
    }

    if ( !nMode ){

        SetLocalInt( oPC, "ds_check_3", 1 );
    }
    else{

        DeleteLocalInt( oPC, "ds_check_3" );
    }

    SetLocalString( oPC, "ds_action", "khm_ds_travel_ac" );
    SetLocalObject( oPC, "ds_target", oNPC );
    DeleteLocalInt( oPC, "ds_node" );

    ActionStartConversation( oPC, "khm_ds_travel", TRUE );
}
