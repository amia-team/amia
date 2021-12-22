//name:         bbs_scribe_convo
//author:       msheeler
//date:         1/16/2017

//This is a re-worked version of the Bulletin Board System

//onconversation script for the scribe. This will store the strings said by the PC on the PC.

void main()
{
    object oPC = GetLastSpeaker();

    //remove any old information and start the conversation
    DeleteLocalString(oPC, "bbs_Title");
    DeleteLocalString(oPC, "bbs_Message");
    DeleteLocalString(oPC, "bbs_Name");
    ClearAllActions();
    ActionStartConversation(oPC,"", FALSE, FALSE);
}

