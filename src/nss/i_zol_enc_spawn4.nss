#include "x2_inc_switches"

void main()
{
    int modEvent = GetUserDefinedItemEventNumber();
    int scriptResult = X2_EXECUTE_SCRIPT_END;

    switch(modEvent)
    {
        case X2_ITEM_EVENT_ACTIVATE:
            object monsterArea = GetObjectByTag("army_pen_4");
            object monsterToSpawn = GetFirstObjectInArea(monsterArea);

            location itemTargetLocation = GetItemActivatedTargetLocation();

            while(GetIsObjectValid(monsterToSpawn))
            {
                if(GetObjectType(monsterToSpawn) == OBJECT_TYPE_CREATURE)
                {
                    if(GetIsDM(monsterToSpawn) || GetIsPC(monsterToSpawn) || GetIsPlayerDM(monsterToSpawn))
                    {
                        continue;
                    }

                    ChangeToStandardFaction(monsterToSpawn, STANDARD_FACTION_HOSTILE);
                    CopyObject(monsterToSpawn, itemTargetLocation);
                }
                monsterToSpawn = GetNextObjectInArea(monsterArea);
            }
        break;
    }

    SetExecutedScriptReturnValue(scriptResult);
}
