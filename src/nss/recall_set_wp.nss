#include "inc_recall_stne"

void main()
{
    object player = GetPCSpeaker();
    object recallStone = GetItemPossessedBy(player, RECALL_STONE);
    object pylon = GetNearestObjectByTag("recall_pylon", player);
    string pylonWaypoint = GetLocalString(pylon, "recall_wp");
    string newName = GetLocalString(pylon, "itemname");

    // Prevent bugs. Don't try to operate on an item that does not exist...
    if(recallStone == OBJECT_INVALID) return;

    if(pylonWaypoint == "")
    {
        FloatingTextStringOnCreature("ERROR/BUG REPORT: Pylon waypoint not set! Notify a DM!", player, FALSE);
    }

    Recall_SetWaypointTag(player, pylonWaypoint);
    Recall_ChangeItemName(player, "<cÿÓ'>" + newName + "</c>");
}
