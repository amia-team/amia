void main()
{
    object player = GetLastUsedBy();
    string conversation = GetLocalString(OBJECT_SELF, "convo_resref");
    AssignCommand(player, ActionStartConversation(player, conversation, TRUE, FALSE));
}
