void main()
{
    string sSpeaker = GetLocalString(OBJECT_SELF, "GS_SPEAKER");
    int nBlockTime = GetLocalInt(OBJECT_SELF, "BlockTime");
    float fBlock = IntToFloat(nBlockTime);

    if( nBlockTime == 0 )
    {
        fBlock = 60.0;
    }

    if(GetLocalInt(OBJECT_SELF, "TIMER") == 1)
    {
        return;
    }

    if(sSpeaker != "")
    {
        object oSpeaker = GetNearestObjectByTag(sSpeaker);
        string sTalk = GetLocalString(OBJECT_SELF, "GS_TEXT");

        AssignCommand(oSpeaker, SpeakString(sTalk, TALKVOLUME_TALK));
        SetLocalInt(OBJECT_SELF, "TIMER", 1);
        DelayCommand(fBlock, SetLocalInt(OBJECT_SELF, "TIMER", 0));
    }
    else
    {
        FloatingTextStringOnCreature(GetLocalString(OBJECT_SELF, "GS_TEXT"),
                                 GetEnteringObject(),
                                 FALSE);
        SetLocalInt(OBJECT_SELF, "TIMER", 1);
        DelayCommand(fBlock, SetLocalInt(OBJECT_SELF, "TIMER", 0));
    }
}
