// Electric Castle :: Initialize Convo

void main( ){

    // Variables
    object oOrigin      = OBJECT_SELF;
    object oPC          = GetLastUsedBy( );

    // Initialize Conversation
    ActionStartConversation( oPC, GetLocalString( oOrigin, "cs_convo" ), TRUE, FALSE );

    return;

}
