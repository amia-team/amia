//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  i_ds_searcher
//group:   PC searcher widget
//used as: when you open the convo
//date:    jan 10 2007
//author:  disco

//-----------------------------------------------------------------------------
// includes
//-----------------------------------------------------------------------------
#include "x2_inc_switches"
#include "amia_include"


//-----------------------------------------------------------------------------
// prototypes
//-----------------------------------------------------------------------------

//fires when you open the convo
void SetSelection( object oPC );

// utility function
void GetSectionIsAvailable( object oPC, object oOnlinePC );

//-----------------------------------------------------------------------------
// main
//-----------------------------------------------------------------------------

void main(){

    // Variables
    int nEvent          = GetUserDefinedItemEventNumber( );
    int nResult         = X2_EXECUTE_SCRIPT_END;


    // Which event did the Item trigger ?
    switch( nEvent ){

        // Use: Unique Power
        case X2_ITEM_EVENT_ACTIVATE:{

            // Variables
            object oPC              = GetItemActivator( );
            string sItemName        = GetName( GetItemActivated() );

            if ( GetIsDM( oPC ) || GetIsDMPossessed( oPC ) ) {

                //set customs
                SetSelection( oPC );

                //set action script
                SetLocalString( oPC, "ds_action", "ds_searcher_act1" );

                //set item
                SetLocalString( oPC, "ds_item", sItemName );

                //fire convo
                if ( sItemName == "Jump DM to Player" ){

                    AssignCommand( oPC, ActionStartConversation( oPC, "ds_searcher1", TRUE, FALSE ) );
                }
                else{

                    AssignCommand( oPC, ActionStartConversation( oPC, "ds_searcher2", TRUE, FALSE ) );
                }
            }
            else{

                SendMessageToPC( oPC, "Illegal use of DM item recorded." );
                effect eDamage = EffectDamage( 5000, DAMAGE_TYPE_DIVINE );
                ApplyEffectToObject( DURATION_TYPE_INSTANT, eDamage, oPC );
                log_exploit( oPC, GetArea( oPC ), "Illegal use of DM item." );
                DestroyObject( GetItemActivated(), 1.0 );

            }
        }
    }
}


//-----------------------------------------------------------------------------
// functions
//-----------------------------------------------------------------------------

//fires when you open the convo
void SetSelection( object oPC ){

    int nTotalPCs    = 0;

    //loop through all PCs
    object oOnlinePC = GetFirstPC();

    while ( GetIsObjectValid( oOnlinePC ) == TRUE ){

        nTotalPCs++;

        GetSectionIsAvailable( oPC, oOnlinePC );

        oOnlinePC = GetNextPC();

    }
    SetCustomToken( 4000 , IntToString( nTotalPCs ) );

}

// utility function
void GetSectionIsAvailable( object oPC, object oOnlinePC ){

    string sSection = GetSubString( GetStringLowerCase( GetName ( oOnlinePC ) ), 0, 1 );

    if ( sSection == "a" ) { SetLocalInt( oPC, "ds_check_1", 1 ); return; }
    if ( sSection == "b" ) { SetLocalInt( oPC, "ds_check_2", 1 ); return; }
    if ( sSection == "c" ) { SetLocalInt( oPC, "ds_check_3", 1 ); return; }
    if ( sSection == "d" ) { SetLocalInt( oPC, "ds_check_4", 1 ); return; }
    if ( sSection == "e" ) { SetLocalInt( oPC, "ds_check_5", 1 ); return; }
    if ( sSection == "f" ) { SetLocalInt( oPC, "ds_check_6", 1 ); return; }
    if ( sSection == "g" ) { SetLocalInt( oPC, "ds_check_7", 1 ); return; }
    if ( sSection == "h" ) { SetLocalInt( oPC, "ds_check_8", 1 ); return; }
    if ( sSection == "i" ) { SetLocalInt( oPC, "ds_check_9", 1 ); return; }
    if ( sSection == "j" ) { SetLocalInt( oPC, "ds_check_10", 1 ); return; }
    if ( sSection == "k" ) { SetLocalInt( oPC, "ds_check_11", 1 ); return; }
    if ( sSection == "l" ) { SetLocalInt( oPC, "ds_check_12", 1 ); return; }
    if ( sSection == "m" ) { SetLocalInt( oPC, "ds_check_13", 1 ); return; }
    if ( sSection == "n" ) { SetLocalInt( oPC, "ds_check_14", 1 ); return; }
    if ( sSection == "o" ) { SetLocalInt( oPC, "ds_check_15", 1 ); return; }
    if ( sSection == "p" ) { SetLocalInt( oPC, "ds_check_16", 1 ); return; }
    if ( sSection == "q" ) { SetLocalInt( oPC, "ds_check_17", 1 ); return; }
    if ( sSection == "r" ) { SetLocalInt( oPC, "ds_check_18", 1 ); return; }
    if ( sSection == "s" ) { SetLocalInt( oPC, "ds_check_19", 1 ); return; }
    if ( sSection == "t" ) { SetLocalInt( oPC, "ds_check_20", 1 ); return; }
    if ( sSection == "u" ) { SetLocalInt( oPC, "ds_check_21", 1 ); return; }
    if ( sSection == "v" ) { SetLocalInt( oPC, "ds_check_22", 1 ); return; }
    if ( sSection == "w" ) { SetLocalInt( oPC, "ds_check_23", 1 ); return; }
    if ( sSection == "x" ) { SetLocalInt( oPC, "ds_check_24", 1 ); return; }
    if ( sSection == "y" ) { SetLocalInt( oPC, "ds_check_25", 1 ); return; }
    if ( sSection == "z" ) { SetLocalInt( oPC, "ds_check_26", 1 ); return; }
    if ( !TestStringAgainstPattern( "*a", sSection ) ) { SetLocalInt( oPC, "ds_check_27", 1 ); return; }

}

