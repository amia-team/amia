#include "x2_inc_switches"

void main()
{
    int modEvent = GetUserDefinedItemEventNumber();
    int scriptResult = X2_EXECUTE_SCRIPT_END;

    int iFaction = STANDARD_FACTION_HOSTILE;
    string ARMY_PEN_FACTION = "ARMY_PEN_FACTION";

    switch(modEvent)
    {
        case X2_ITEM_EVENT_ACTIVATE:
            object monsterArea = GetObjectByTag("army_pen");
            int iTempFaction = GetLocalInt(monsterArea, ARMY_PEN_FACTION);
            if (iTempFaction != 0) {
                iFaction = iTempFaction;
            }
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

                    ChangeToStandardFaction(monsterToSpawn, iFaction);
                    CopyObject(monsterToSpawn, itemTargetLocation);
                }
                monsterToSpawn = GetNextObjectInArea(monsterArea);
            }
        break;
    }

    SetExecutedScriptReturnValue(scriptResult);
}
