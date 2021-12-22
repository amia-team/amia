//name:         bbs_scribe_t_get
//author:       msheeler
//date:         1/16/2017

//This is a re-worked version of the Bulletin Board System

//Gets the last chat message from the PC and saves it as the BBS message title

void main()
{
    object oPC = GetLastSpeaker();
    string sSaid = GetLocalString(oPC, "last_chat");
    SendMessageToPC(oPC, "last_chat = " + GetLocalString(oPC, "last_chat"));

    //message to long error
    if (GetStringLength(sSaid) > 30)
    {
        sSaid = GetStringLeft(sSaid, 30);
        SendMessageToPC(oPC, "Your title was to long, it has been change to: " + sSaid);
    }

    //message to short error
    else if (GetStringLength(sSaid) < 5)
    {
        sSaid = "No Title";
        SendMessageToPC(oPC, "Your title was to short, it has been changed to: " +sSaid);
    }

    SetLocalString(oPC, "bbs_Title", sSaid);
    SendMessageToPC(oPC, "Title = " + GetLocalString(oPC, "bbs_Title"));
}

