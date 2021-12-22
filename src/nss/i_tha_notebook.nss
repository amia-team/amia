/*
i_tha_notebook

---------------------------------------------------------------------------------
Verbatim
---------------------------------------------------------------------------------
Used in the Ostman quest in Forrstakkr

---------------------------------------------------------------------------------
Changelog
---------------------------------------------------------------------------------
Date            Name       Reason
------------------------------------------------
04-29-2006      disco      Start of header
10-20-2006      disco      Linguistic update
------------------------------------------------
*/

//-------------------------------------------------------------------------------
//includes
//-------------------------------------------------------------------------------
#include "x2_inc_switches"

//-------------------------------------------------------------------------------
//main
//-------------------------------------------------------------------------------
void main(){
    int nEvent = GetUserDefinedItemEventNumber();
    int nResult = X2_EXECUTE_SCRIPT_END;
    object oPC;      //The player character using the item
    object oItem;    //The item being used
    object oTarget;
    string sItemName;

    switch (nEvent){
        case X2_ITEM_EVENT_ACTIVATE:
            oPC=GetItemActivator();
            oItem=GetItemActivated();
            oTarget=GetItemActivatedTarget();
            sItemName=GetName(oItem);

            if(sItemName=="Notebook"){
                if(GetName(oTarget)=="Runestone"){
                    if(GetLocalInt(oItem,GetTag(oTarget))==1){
                        SendMessageToPC( oPC, "You already have this rune in your notebook!");
                    }
                    else{
                        SetLocalInt(oItem,GetTag(oTarget),1);
                        AssignCommand(oPC,ActionSpeakString("*Draws a nice image of this Runestone in a notebook.*"));
                    }
                }
            }

        break;

    }
    //Pass the return value back to the calling script
    SetExecutedScriptReturnValue(nResult);
}
