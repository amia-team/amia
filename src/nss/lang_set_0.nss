void main()
{
    SetLocalInt( GetPCSpeaker(), "chat_language", -1 );
    SendMessageToPC( GetPCSpeaker(), "Language turned off, you're now speaking common!" );
}
