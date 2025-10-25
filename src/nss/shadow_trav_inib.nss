/*
    Created: 10/24/2025
    Creator: TheLoafyOne
    Description: Script used to initiate a conversation file that teleports
    players to places via the shadowplane.
*/

void main()
{
    object player = GetLastUsedBy();
    object partyMember = GetFirstFactionMember(player, TRUE);
    if (player != OBJECT_INVALID) {
    while(GetIsObjectValid(partyMember) == TRUE) {
        if (GetAlignmentGoodEvil(player) == ALIGNMENT_GOOD || GetAlignmentGoodEvil(partyMember) == ALIGNMENT_GOOD) {
            SendMessageToPC(player, "You see nothing here out of the ordinary.");
            return;
        }
        partyMember = GetNextFactionMember(player, TRUE);
    }

        AssignCommand( player, ActionStartConversation( player, "shadow_travel_brazier", TRUE, FALSE ) );
  }
}
