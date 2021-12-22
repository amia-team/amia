int StartingConditional()
{
    return ( GetIsObjectValid(GetPCSpeaker())
            && !GetLocalInt(OBJECT_SELF, "jp_IsPlaying") );
}
