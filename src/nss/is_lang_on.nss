int StartingConditional()
{
    return GetPCPlayerName( GetPCSpeaker() ) == "Terra_777" || GetLocalInt( GetModule(), "language_enabled" );
}

