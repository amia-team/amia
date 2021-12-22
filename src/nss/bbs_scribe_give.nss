//name:         bbs_scribe_give
//author:       msheeler
//date:         1/16/2017

//This is a re-worked version of the Bulletin Board System

//Gives the PC a notice item with information to post on the bulletin board.
void main()
{
    object oPC = GetPCSpeaker();
    object Notice = CreateItemOnObject("bbs_notice_bp", GetPCSpeaker());
    SendMessageToPC(oPC, "Title = " + GetLocalString(oPC, "bbs_Title"));
    SendMessageToPC(oPC, "Message = " + GetLocalString(oPC, "bbs_Message"));
    SendMessageToPC(oPC, "Name = " + GetLocalString(oPC, "bbs_Name"));
    if (Notice != OBJECT_INVALID)
    {
        SetLocalString(Notice, "bbs_Title", GetLocalString(oPC, "bbs_Title"));
        SetLocalString(Notice, "bbs_Message", GetLocalString(oPC, "bbs_Message"));
        SetLocalString(Notice, "bbs_Name", GetLocalString(oPC, "bbs_Name"));
    }
    SendMessageToPC(oPC, "Title = " + GetLocalString(Notice, "bbs_Title"));
    SendMessageToPC(oPC, "Message = " + GetLocalString(Notice, "bbs_Message"));
    SendMessageToPC(oPC, "Name = " + GetLocalString(Notice, "bbs_Name"));
}

