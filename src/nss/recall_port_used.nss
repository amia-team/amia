#include "inc_recall_stne"

void main()
{
    object player = GetLastUsedBy();
    string waypointTag = GetLocalString(OBJECT_SELF, LVAR_RECALL_WP);
    object portalDestination = GetObjectByTag(waypointTag);

    DelayCommand( 1.0, AssignCommand( player, ClearAllActions() ) );
    DelayCommand( 1.1, AssignCommand( player, JumpToObject( portalDestination, 0 ) ) );
}
