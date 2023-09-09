// 08-sep-2023  frozen  added "allow" spot toportal block

#include "inc_recall_stne"

void main()
{
    object player = GetItemActivator();
    object area = GetArea(player);
    object nearestCreature = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, player);

    // Prevent strangeness with NPCs and DM characters.
    if(!GetIsPC(player)) return;

    if(GetLocalInt(area, "PreventRodOfPorting") == TRUE)
    {
        object allowedPoint    =   GetNearestObjectByTag ("recal_allowed_point", player);
        float  distanceAllowed =   GetLocalFloat (allowedPoint, "distance");

        if(GetDistanceBetween (player, allowedPoint) >= distanceAllowed)
        {
        FloatingTextStringOnCreature("Teleporting is disallowed in this area.", player);
        return;
        }
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

    object portal = CreateObject(OBJECT_TYPE_PLACEABLE, "recall_portal", playerLocation);
    object portalVfx = CreateObject(OBJECT_TYPE_PLACEABLE, "portal2yellow", playerLocation);

    SetLocalString(portal, LVAR_RECALL_WP, Recall_GetWaypointTag(player));

    AssignCommand(player, ActionInteractObject(portal));

    DelayCommand(20.0f, DestroyObject(portal));
    DelayCommand(20.0f, DestroyObject(portalVfx));
}
