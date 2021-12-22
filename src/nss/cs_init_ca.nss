// includes
#include "cs_inc_leto"

void main()
{
    //vars
    object oPC=GetLastUsedBy();
    string szConversationScript=GetLocalString(
        OBJECT_SELF,
        "cs_conversation");

    // only PCs may use the servervault
    if(GetIsPC(oPC)==FALSE){

        FloatingTextStringOnCreature(
            "<c�  >- Only PCs may use the servervault -</c>",
            oPC,
            FALSE);

        return;

    }

    FloatingTextStringOnCreature(
        "<c�  >- The servervault is not implemented at this time! -</c>",
        oPC,
        FALSE);

    SendMessageToAllDMs("- A player tried to use the servervault. This is a friendly reminder yelling at the team to get this re-implemented. -");

    return;

    /*
    // NOTE: Kept to retain this in the event we re-implement this!
    // init servervault conversation
    ActionStartConversation(
        oPC,
        szConversationScript,
        TRUE,
        FALSE);
              */
}
