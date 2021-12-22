//name:         bbs_scribe_m_get
//author:       msheeler
//date:         1/16/2017

//This is a re-worked version of the Bulletin Board System

//Gets the last chat message from the PC and saves it as the BBS message body

void main()
{
    object oPC = GetLastSpeaker();
    string sSaid = GetLocalString(oPC, "last_chat");

    //check for duplicate entry
    if (GetStringLeft(sSaid, 30) == GetLocalString(oPC, "bbs_Title"))
    {
        sSaid = "No Message.";
        SendMessageToPC(oPC, "Your message body cannot be the same as the title. It has been changed to: " + sSaid);
    }
    //message to long error
    if (GetStringLength(sSaid) > 200)
    {
        sSaid = GetStringLeft(sSaid, 200);
        SendMessageToPC(oPC, "Your message was to long, it has been change to: " + sSaid);
    }
    //message to short error
    else if (GetStringLength(sSaid) < 5)
    {
        sSaid = "No Message";
        SendMessageToPC(oPC, "Your message was to short, it has been changed to: " +sSaid);
    }

    SetLocalString(oPC, "bbs_Message", sSaid);
    SendMessageToPC(oPC, "Message = " + GetLocalString(oPC, "bbs_Message"));
}

