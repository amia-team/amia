//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: mod_act_item
//group: module events
//used as: OnActivateItem
//date: 2008-06-03
//author: Disco (copied & cleaned from old scripts)

//2009-04-14   Disco   Added Job System support


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main( ){

    // Variables
    object oSource      = OBJECT_SELF;
    object oItem        = GetItemActivated( );
    string sTag         = GetTag( oItem );

    if ( GetStringLeft( sTag, 5 ) == "ds_j_" && sTag != "ds_j_journal" ){

        // job system needs unique tags for pricing etc
        SetUserDefinedItemEventNumber( X2_ITEM_EVENT_ACTIVATE );
        ExecuteScriptAndReturnInt( "i_ds_j_activate", oSource );
    }
    else{

        // Item event initialized and "i_" prefix plus item's tag scriptname is executed.
        SetUserDefinedItemEventNumber( X2_ITEM_EVENT_ACTIVATE );
        ExecuteScriptAndReturnInt( "i_" + sTag, oSource );
    }

    return;
}

