//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script: ds_crafting_act
//group: core stuff
//used as: activation script
//date:  2008-06-06
//author: Disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "inc_ds_crafting"
#include "inc_ds_actions"
#include "inc_ds_records"


//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------
void main(){

    object oPC          = OBJECT_SELF;
    object oItem        = GetLocalObject( oPC, "ds_target" );
    int nNode           = GetLocalInt( oPC, "ds_node" );
    object oCache       = GetCache( "ds_bindpoint_storage" );
    string sTag;
    string sTitle;

    if ( nNode > 0 ){

        sTag      = GetLocalString( oCache, "f_" + IntToString( nNode ) );
        sTitle    = GetLocalString( oCache, sTag );

        SendMessageToPC( oPC, "Attuning this wand to the "+sTitle+" faction. ("+GetSubString( sTag, 2, 5 )+")" );

        SetName( oItem, sTitle+" Faction Wand" );
        SetDescription( oItem, "This is your faction wand", TRUE );
        SetLocalString( oItem, "faction", GetSubString( sTag, 2, 5 ) );

        return;
    }
}


