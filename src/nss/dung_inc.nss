/*
  Include script for destroying DTS blockers in a group.

  - Lord-Jyssev 3/15/24: Created
*/

// Loops through all blocker PLCs and destroys them.
void DestroyBlockers(object oPLC);

void DestroyBlockers(object oPLC)
{
    int nBlockerCount = GetLocalInt(oPLC, "count") + 1;
    string sBlockerTag = GetTag(oPLC);
    string sWaypointTag = GetStringLeft(sBlockerTag, GetStringLength(sBlockerTag) - 3);
    object oSubWP, oTemp;
    object oBlockerWP = GetWaypointByTag(sWaypointTag);

    // Iterate through the blocker PLC objects
    int i;
    for (i = 1; i <= nBlockerCount; i++)
    {
        oSubWP = GetWaypointByTag(sWaypointTag + "Sub" + IntToString(i));

        // Find the object with the specified tag under this waypoint
        oTemp = GetNearestObjectByTag(sBlockerTag, oSubWP);
        DestroyObject(oTemp);
    }

    // Cleanup the blocker waypoint itself
    oTemp = GetNearestObjectByTag(sBlockerTag, oBlockerWP);
    if(GetIsObjectValid(oTemp))
    {
        DestroyObject(oTemp);
    }
}
