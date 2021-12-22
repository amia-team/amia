//name:         bbs_scribe_n_get
//author:       msheeler
//date:         1/16/2017

//This is a re-worked version of the Bulletin Board System

//Gets the last chat message from the PC and saves it as the BBS message title

void main()
{
    object oPC = GetLastSpeaker();
    string sSaid = GetLocalString(oPC, "last_chat");

    //check to make sure we dont have duplicate entries
    if (GetStringLeft(sSaid, 30) == GetLocalString(oPC, "bbs_Title"))
    {
        sSaid = "No Name";
        SendMessageToPC(oPC, "Your name can not be the same as your message title. It has been changed to: " + sSaid);
    }
    if (GetStringLeft(sSaid, 200) == GetLocalString(oPC, "bbs_Message"))
    {
        sSaid = "No Name";
        SendMessageToPC(oPC, "Your name can not be the same as your message. It has been changed to: " + sSaid);
    }
    //message to long error
    if (GetStringLength(sSaid) > 30)
    {
        sSaid = GetStringLeft(sSaid, 30);
        SendMessageToPC(oPC, "Your name was to long, it has been change to: " + sSaid);
    }

    //message to short error
    else if (GetStringLength(sSaid) < 5)
    {
        sSaid = "No Name";
        SendMessageToPC(oPC, "Your name was to short, it has been changed to: " +sSaid);
    }
    SetLocalString(oPC, "bbs_Name", sSaid);
    SendMessageToPC(oPC, "Name = " + GetLocalString(oPC, "bbs_Name"));
}

