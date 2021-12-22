// Item: Hin'ternizer: Gives tall-folk a special invite to take up residency in Bendir Dale
#include "x2_inc_switches"
void main(){

    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent){

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object oTallFolk=GetItemActivatedTarget();
            object oPC=GetItemActivator();

            // resolve Tall-folk status
            if(GetIsPC(oTallFolk)==FALSE){

                SendMessageToPC(
                    oPC,
                    "- You may only use the Hin'ternizer on PCs! -");

                break;

            }

            // Notify Randy and the designated Tall-folk
            string szMessage=
                "- "                                                            +
                GetName(oTallFolk)                                              +
                " has been Hin'ternized! -";

            // Randy
            SendMessageToPC(
                oPC,
                szMessage);

            // Tall-Folk
            SendMessageToPC(
                oTallFolk,
                szMessage);

            // Give the Tall-folk a special invite
            SetLocalInt(
                oTallFolk,
                "special_hin_invite",
                1);

            break;

        }

        default:{

            break;

        }

    }

    SetExecutedScriptReturnValue(nResult);

}
