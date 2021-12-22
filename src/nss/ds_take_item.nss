//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  ds_give_rages
//description: creates item 'ds_item' on oPC
//used as: convo script
//date:    apr 05 2008
//author:  disco


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC      = GetPCSpeaker();
    string sResRef  = GetLocalString( OBJECT_SELF, "ds_item" );
    object oItem    = GetItemPossessedBy( oPC, sResRef );

    if( GetIsObjectValid( oItem ) )
    {
        DestroyObject( oItem );
    }
}

