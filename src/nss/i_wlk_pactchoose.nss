void main()
{
    object player  = GetItemActivator();

    AssignCommand( player, ActionStartConversation(player,"c_wlk_pact",TRUE,FALSE));
}
