void main()
{
    object oPC = GetLastSpeaker();
    DeleteLocalString(oPC, "bbs_Title");
    DeleteLocalString(oPC, "bbs_Message");
    DeleteLocalString(oPC, "bbs_Name");
}

