//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  us_give_item
//description: creates item 'ds_item' on oPC
//used as: convo script
//date:    apr 05 2008
//author:  disco

//Updates: 11/10/22 - Lord-Jyssev: Added optional checks for 1/reset per player and for not giving quest items after completion


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"

//-------------------------------------------------------------------------------
// main
//-------------------------------------------------------------------------------

void main(){

    object oPC          = GetLastUsedBy();
    int nOncePerReset   = GetLocalInt ( OBJECT_SELF, "OncePerReset");
    string sResRef      = GetLocalString( OBJECT_SELF, "ds_item" );
    string sQuest       = GetLocalString ( OBJECT_SELF, "questname");
    object oPCKey       = GetItemPossessedBy(oPC, "ds_pckey");
    string sPubKey      = GetPCPublicCDKey(oPC, TRUE);

    //SendMessageToPC( oPC, "DEBUG: sQuest: "+sQuest );                                                                        ///
    //SendMessageToPC( oPC, "DEBUG: sQuest Value: "+IntToString(GetLocalInt(oPCKey, sQuest) == 2) );                                                                        ///

    if(GetLocalInt(oPCKey, sQuest) == 2)
        {
            SendMessageToPC( oPC, "Quest completed! You would have no need for this item.");
            return;
        }
    else if(GetLocalInt(oPCKey, sQuest) == 1 && GetItemPossessedBy(oPC, sResRef) != OBJECT_INVALID)
        {
            return;
        }
    else if((nOncePerReset == 1) && (GetLocalInt(OBJECT_SELF, sPubKey) == 1))
        {
            SendMessageToPC( oPC, "Only one item per reset!");
            return;
        }
    else if ((nOncePerReset == 1) && (GetLocalInt(OBJECT_SELF, sPubKey) == 0))
        {
            //Set a variable on this object saying that the PC has spawned this once this reset
            SetLocalInt( OBJECT_SELF, sPubKey, 1 );
            ds_create_item( sResRef, oPC );
            SendMessageToPC( oPC, "You cannot acquire any more of this item this reset!");
        }
    else
        {
            CreateItemOnObject( sResRef, oPC, 1 );
        }
}
