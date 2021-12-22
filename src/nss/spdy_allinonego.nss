/*
spdy_allinonego

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
This script gives all teh speedy items in one go

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
12-25-2006      disco      Start of header
------------------------------------------------
*/


//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "nw_i0_tool"

//-------------------------------------------------------------------------------
//prototypes
//-------------------------------------------------------------------------------
//safe version of CreateItemOnObject; checks for doubles.
void ds_create_item(string sTemplate,object oPC,int n);


//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){

    object oPC=GetPCSpeaker();
    string sConvoNPCTag=GetTag(OBJECT_SELF);

    //sometimes an NPC reacts to SpeakString from another NPC
    if( GetIsPC(oPC)==FALSE && GetIsPC(GetLastOpenedBy())==FALSE ){
        return;
    }

    ds_create_item( "parceligor" , oPC, 1 );
    ds_create_item( "parcelshelter" , oPC, 1 );
    ds_create_item( "parceley" , oPC, 1 );
    ds_create_item( "parcelgypsy" , oPC, 1 );
    ds_create_item( "parcelmaproom" , oPC, 1 );
    ds_create_item( "parcelhaur" , oPC, 1 );
    ds_create_item( "parcelgalver" , oPC, 1 );

}

//-------------------------------------------------------------------------------
// functions
//-------------------------------------------------------------------------------
void ds_create_item( string sTemplate, object oPC, int n ){

    object oItem = GetItemPossessedBy( oPC, sTemplate );

    if( oItem == OBJECT_INVALID ){

        CreateItemOnObject( sTemplate, oPC, n );
    }
    else{

        SendMessageToPC( oPC, "*Couldn't give you "+GetName(oItem)+". Item already in possession.*" );
    }
}
