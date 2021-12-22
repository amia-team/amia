#include "cs_inc_leto"
#include "inc_td_appearanc"
#include "inc_ds_j_lib"
#include "inc_td_sysdata"
#include "amia_include"
#include "nwnx_areas"
#include "nwnx_messages"
#include "nwnx_dynres"

void Cache( string sFile, string sFull ){

    DYNRES_AddFile( sFile, sFull );
    DYNRES_CacheFile( sFile );
}

void main(){

    object oPC = OBJECT_SELF;
    string sMod = NWNX_ReadStringFromINI( "AMIA", "Mod", "%", "./NWNX.ini" );
    string sMini = NWNX_ReadStringFromINI( "NWNX", "ModuleName", "%", "./NWNX.ini" );
    if( sMini == "%" || sMod == "%" )
        return;

    if( GetLocalInt( GetModule(), "detached" ) ){

        SetLocalInt( GetModule(), "detached", FALSE );
        SendMessageToPC( oPC, "Attached module: "+IntToString( DYNRES_AddFile( sMini+".mod", sMod ) ) );
    }
    else{
        SetLocalInt( GetModule(), "detached", TRUE );
        SendMessageToPC( oPC, "Detach module: "+IntToString( DYNRES_RemoveFile( sMini+".mod ") ) );
    }

    Cache( "creaturepalcus.itp", sMod );
    Cache( "doorpalcus.itp", sMod );
    Cache( "encounterpalcus.itp", sMod );
    Cache( "itempalcus.itp", sMod );
    Cache( "placeablepalcus.itp", sMod );
    Cache( "soundpalcus.itp", sMod );
    Cache( "storepalcus.itp", sMod );
    Cache( "triggerpalcus.itp", sMod );
    Cache( "waypointpalcus.itp", sMod );
}
