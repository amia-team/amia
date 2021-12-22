void main()
{

    object oPC = GetLastSpeaker();

    SetCustomToken( 8000, GetLocalString( OBJECT_SELF, "hak" ) );

    ActionStartConversation( oPC, "hak_chicken", TRUE, FALSE );
}
