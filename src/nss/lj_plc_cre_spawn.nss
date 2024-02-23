//
//          Lord-Jyssev's Item-Based Creature Spawner
//
// OnClosed event of a container with the tag lj_plc_cre_container(1-6)
// When the correct item is placed inside this container, this system will
// spawn a boss and optional minions wherever their waypoints are placed within
// the same area. Waypoint for the boss must be tagged with:
// lj_plc_cre_boss
//
// Minion Spawnpoints must be waypoints tagged with:
// lj_plc_cre_spawn(1-6)
//
// Required item tag must be a string variable set on each container:
// "ItemRequired"
//
// The waypoints must have a "creature" string variable that will determine the
// creature to be spawned.
//
// Each waypoint may also have a "vfx" int variable that will determine the
// VFX to play when spawning on their waypoint.
//
// The boss waypoint may have a "OncePerReset" int
// variable set to 1 that will only allow the system to be used 1/reset per
// player (the last person to close the last container with the item in it).
//
// The system has a cooldown of 10 minutes.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/13/2024 Lord-Jyssev      Initial Release.
//


#include "amia_include"

// Simple function to create the creature so that we can add a small delay
void CreateCreature(string sResref, location lWaypoint)
{
    CreateObject(OBJECT_TYPE_CREATURE, sResref, lWaypoint);
}

// Function to create a creature at a specified waypoint with given VFX
void CreateCreatureAtWaypoint(object oWaypoint, string sResref, int nVFX)
{
    location lWaypoint = GetLocation(oWaypoint);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nVFX), lWaypoint);
    DelayCommand(1.0, CreateCreature(sResref, lWaypoint));
}

// Function to destroy all items in the inventory of containers
void DestroyAllInventory()
{
    // Target initial container, since it won't be captured in the loop.
    object oItem = GetFirstItemInInventory(OBJECT_SELF);
    while (GetIsObjectValid(oItem))
    {
        DestroyObject(oItem); // Destroy the current item
        oItem = GetNextItemInInventory(OBJECT_SELF); // Move to the next item in the container
    }

    // Remove the "ItemFound" variable from the container
    DeleteLocalInt(OBJECT_SELF, "ItemFound");

    // Iterate through the rest of the containers in the area
    int i = 1;
    for (i; i <= 6; i++)
    {
        string sContainerTag = "lj_plc_cre_container" + IntToString(i);
        object oContainer = GetNearestObjectByTag(sContainerTag);

        // Check if the container is valid
        if (GetIsObjectValid(oContainer))
        {
            // Iterate through all items in the container's inventory
            object oItem = GetFirstItemInInventory(oContainer);
            while (GetIsObjectValid(oItem))
            {
                DestroyObject(oItem); // Destroy the current item
                oItem = GetNextItemInInventory(oContainer); // Move to the next item in the container
            }

            // Remove the "ItemFound" variable from the container
            DeleteLocalInt(oContainer, "ItemFound");
        }
    }
}

int CheckContainersForAllItemsFound(object oPC, string sItemRequired)
{
    int nContainersFound = 0; // Initialize counter for containers found
    int nItemsFound = 0;      // Initialize counter for items found

    // Check the last-closed chest, since it won't be captured in the loop
    object oLastClosed = OBJECT_SELF;
    object oItem = GetFirstItemInInventory(oLastClosed);
    while (GetIsObjectValid(oItem))
            {
                // If the item matches the required item, set "ItemFound" variable
                if (GetTag(oItem) == sItemRequired)
                {
                    nItemsFound++; // Increment item counter
                    SetLocalInt(oLastClosed, "ItemFound", 1);
                    break;
                }
                oItem = GetNextItemInInventory(oLastClosed);
            }
    nContainersFound++;

    // Iterate through all containers in the area
    int i = 1;
    for (i; i <= 6; i++)
    {
        string sContainerTag = "lj_plc_cre_container" + IntToString(i);
        object oContainer = GetNearestObjectByTag(sContainerTag);

        // Check if the container is valid
        if (GetIsObjectValid(oContainer))
        {
            nContainersFound++; // Increment container counter
            if (GetLocalInt(oContainer, "ItemFound") == TRUE)
            {
                nItemsFound++; // Increment item counter
            }

        }
    }

    // Check if the number of containers found matches the number of "ItemFound" variables set
    if (nContainersFound == nItemsFound)
    {
        return 1; // Return 1 if the number of containers match the number of items
    }
    else
    {
        return 0; // Return 0 if containers found and items found don't match
    }
}


void main()
{
    object oSelf = OBJECT_SELF;
    object oPC = GetLastClosedBy();

    // Clear the item found variable as a failsafe
    DeleteLocalInt(oSelf, "ItemFound");

    string sItemRequired = GetLocalString(oSelf, "ItemRequired");
    int nOncePerReset    = GetLocalInt( GetNearestObjectByTag("lj_plc_cre_boss"), "OncePerReset");
    // Check if all items in containers have the "ItemFound" variable set
    int nItemsFound = CheckContainersForAllItemsFound(oPC, sItemRequired);

    // If all items are found or if the required item is found in the inventory
    if (nItemsFound == TRUE)
    {
        // Check if the boss waypoint is found
        object oBossWaypoint = GetNearestObjectByTag("lj_plc_cre_boss");
        if (!GetIsObjectValid(oBossWaypoint))
        {
            SendMessageToPC(oPC, "Boss waypoint not found; report to a developer.");
            return;
        }
        if ( GetIsBlocked( GetNearestObjectByTag("lj_plc_cre_boss") ) > 0 ){

              SendMessageToPC( oPC, "You must wait before attempting to spawn again." );
              return;
           }
        else if(nOncePerReset == 1 && GetLocalInt( GetNearestObjectByTag("lj_plc_cre_boss"), GetPCPublicCDKey( oPC, TRUE ) ) == 1)
        {
            SendMessageToPC( oPC, "Only one spawning per reset!");
            return;
        }
        // Create the boss
        CreateCreatureAtWaypoint(oBossWaypoint, GetLocalString(oBossWaypoint, "creature"), GetLocalInt(oBossWaypoint, "vfx"));

        // Check if additional waypoints are found and create creatures
        int i = 1;
        for (i; i <= 6; i++)
        {
            string sWaypointTag = "lj_plc_cre_spawn" + IntToString(i);
            object oWaypoint = GetNearestObjectByTag(sWaypointTag);
            if (GetIsObjectValid(oWaypoint))
            {
                CreateCreatureAtWaypoint(oWaypoint, GetLocalString(oWaypoint, "creature"), GetLocalInt(oWaypoint, "vfx"));
            }
        }

        // Clean up and set flags
        DestroyAllInventory();
        SetLocalInt(GetNearestObjectByTag("lj_plc_cre_boss"), GetPCPublicCDKey(oPC, TRUE), 1);
        SetBlockTime( GetNearestObjectByTag("lj_plc_cre_boss"), 10, 0 );
    }
    else
    {
        return;
    }
}
