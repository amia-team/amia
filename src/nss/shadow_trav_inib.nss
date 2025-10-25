/*
    Created: 10/24/2025
    Creator: TheLoafyOne
    Description: Script used to initiate a conversation file that teleports
    players to places via the shadowplane.
*/
#include "amia_include"

void main()
{
    object player = GetLastUsedBy();
    object tTrigger = GetNearestObjectByTag( "party_trigger" );
    object nextPlayer  = GetFirstInPersistentObject( tTrigger );

     while ( GetIsObjectValid( nextPlayer ) ) {

        if ( ds_check_partymember( player, nextPlayer ) ) {
            if (GetAlignmentGoodEvil(player) == ALIGNMENT_GOOD || GetAlignmentGoodEvil(nextPlayer) == ALIGNMENT_GOOD)
            {
               SendMessageToPC(player, "You see nothing here out of the ordinary.");
               return;
            }
        }

        nextPlayer = GetNextInPersistentObject( tTrigger );
    }
    AssignCommand( player, ClearAllActions( TRUE ) );
    AssignCommand( player, ActionStartConversation( player, "shadow_travel_brazier", TRUE, FALSE ) );
}
