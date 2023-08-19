#include "inc_recall_stne"

void main()
{
    object player          = GetItemActivator();
    object area            = GetArea(player);
    object stone           = GetItemActivated();
    object nearestCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, player);
    object recallPoint     = GetItemActivatedTarget();
    string recallLocation  = GetTag(recallPoint);

    // Prevent strangeness with NPCs and DM characters.
    if(!GetIsPC(player)) return;

    if (recallPoint == player)
    {
        if(GetLocalInt(area, "PreventRodOfPorting") == TRUE)
        {
            FloatingTextStringOnCreature("Teleporting is disallowed in this area.", player);
            return;
        }

        if(nearestCreature != OBJECT_INVALID)
        {
            if(GetDistanceBetween(player, nearestCreature) <= 25.0f)
            {
                FloatingTextStringOnCreature("Your portal fails to materialize due to nearby hostiles within 25 meters.", player);
                return;
            }
        }

        location playerLocation = GetLocation(player);

        object portal            = CreateObject(OBJECT_TYPE_PLACEABLE, "recall_portal", playerLocation);
        object portalVfx         = CreateObject(OBJECT_TYPE_PLACEABLE, "portal2yellow", playerLocation);
        string portalDestination = GetLocalString(stone, LVAR_RECALL_WP);

        SetLocalString(player, LVAR_RECALL_WP, portalDestination);

        if (portalDestination != "")
        {
            SetLocalString(portal, LVAR_RECALL_WP, portalDestination);

            AssignCommand(player, ActionInteractObject(portal));

            DelayCommand(20.0f, DestroyObject(portal));
            DelayCommand(20.0f, DestroyObject(portalVfx));
        }
        else
        {
            FloatingTextStringOnCreature("You have not set this stone to a recall point. Use it on a pylon first.", player, FALSE);
            return;
        }
    }

    else if (GetTag(recallPoint) == "recall_pylon")
    {
        string pylonWaypoint = GetLocalString(recallPoint, "recall_wp");
        string newName = GetLocalString(recallPoint, "itemname");

        // Prevent bugs. Don't try to operate on an item that does not exist...
        if(stone == OBJECT_INVALID) return;

        if(pylonWaypoint == "")
        {
            FloatingTextStringOnCreature("ERROR/BUG REPORT: Recall waypoint not set! Notify a DM!", player, FALSE);
        }

        SetLocalString(stone, LVAR_RECALL_WP, pylonWaypoint);
        SetName(stone, "<cÿÓ'>Divine "+newName+"</c>");
        FloatingTextStringOnCreature(newName+" has been set to your Divine Recall Stone!", player);
    }

    else
    {
        FloatingTextStringOnCreature("You can only use the Divine Recall Stone on yourself or on a Recall Point, such as a Recall Pylon.", player);
        return;
    }

}
