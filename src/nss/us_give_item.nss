//-----------------------------------------------------------------------------
// header
//-----------------------------------------------------------------------------
//script:  us_give_item
//description: creates item 'ds_item' on oPC
//used as: convo script
//date:    apr 05 2008
//author:  disco

//Updates:  11/10/22 - Lord-Jyssev: Added optional checks for 1/reset per player and for not giving quest items after completion
//          8/21/24 -  Lord-Jyssev: Added option to require quest start/completion in order to receive item


//-------------------------------------------------------------------------------
// includes
//-------------------------------------------------------------------------------
#include "amia_include"
#include "nw_i0_tool"

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
    string sQuestStarted   = GetLocalString( OBJECT_SELF, "queststarted");
    string sQuestFinished  = GetLocalString( OBJECT_SELF, "questfinished");
    int    nQuestStatus = GetLocalInt(oPCKey,sQuestFinished);
    int    nQuestStarted = GetLocalInt(oPCKey,sQuestStarted);
    int    nQuestFinished = GetLocalInt(oPCKey,sQuestFinished);

    //SendMessageToPC( oPC, "DEBUG: sQuest: "+sQuest );                                                                        ///
    //SendMessageToPC( oPC, "DEBUG: sQuest Value: "+IntToString(GetLocalInt(oPCKey, sQuest) == 2) );                                                                        ///

    if( sQuestStarted != "" && nQuestStarted < 1) //Check to see if the quest fields are set
    {
        SendMessageToPC( oPC, "You must have started the <c Í >" + sQuestStarted + "</c> quest to use this.");
        return;
    }
    else if( sQuestFinished != "" && nQuestFinished != 2) //Check to see if the quest fields are set
    {
        SendMessageToPC( oPC, "You must have completed the <c Í >" + sQuestFinished + "</c> quest to use this.");
        return;
    }
    else if(nQuestStatus == 2)
        {
            SendMessageToPC( oPC, "Quest completed! You would have no need for this item.");
            return;
        }
    else if(sQuest != "" && HasItem(oPC, sResRef))
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
            CreateItemOnObject( sResRef, oPC, 1 );
            SetLocalInt( OBJECT_SELF, sPubKey, 1 );
            SendMessageToPC( oPC, "You cannot acquire any more of this item this reset!");
        }
    else
        {
            CreateItemOnObject( sResRef, oPC, 1 );
        }
}
