#include "inc_dc_api"

void main()
{
    object dungeonMaster = GetPCSpeaker();
    object dcRod = GetItemPossessedBy(dungeonMaster, I_DM_DC_ROD);
    object player = GetLocalObject(dcRod, LVAR_LAST_ROD_TARGET);

    if(!GetIsPC(player))
    {
        // Not a player, do not execute.
        return;
    }

    location playerLocation = GetLocation(player);
    object creatureInArea = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, playerLocation, OBJECT_TYPE_CREATURE);

    while(GetIsObjectValid(creatureInArea) == TRUE)
    {
        if(GetIsPC(creatureInArea))
        {
            ExecuteScript(SCRIPTNAME_GIVE_ONE_DC, creatureInArea);
        }

        creatureInArea = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, playerLocation, OBJECT_TYPE_CREATURE);
    }
}
