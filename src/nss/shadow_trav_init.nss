/*
    Created: 10/24/2025
    Creator: TheLoafyOne
    Description: Script used to initiate a conversation file that teleports
    players to places via the shadowplane.
*/

void main()
{
    object player = GetLastUsedBy();

    if (player != OBJECT_INVALID) {
        AssignCommand( player, ActionStartConversation( player, "shadow_travel", TRUE, FALSE ) );
    }
}
