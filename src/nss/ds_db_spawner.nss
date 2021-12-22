/*#include "nwnx_object"
#include "nwnx_time"

string GetResRefVarPrefix(object area);
void SpawnCreatures(object area, int double_spawns);
int GetMaxSpawns(object area);
int GetNumberOfPlayersInParty(object player);
int TriggerStillOnCooldown();

const string Spawnpoint = "ds_spwn";
string Prefix;*/

void main()
{
    /*object area = GetArea(OBJECT_SELF);
    object player = GetEnteringObject();
    Prefix = GetResRefVarPrefix(area);

    if(TriggerStillOnCooldown())
    {
        SendMessageToPC(player, "You see signs of recent fighting here.");
        return;
    }

    int party_members = GetNumberOfPlayersInParty(player);

    int should_double_spawn = party_members > 6;

    SpawnCreatures(area, should_double_spawn);
}

int TriggerStillOnCooldown()
{
    int cooldown_start = GetLocalInt(OBJECT_SELF, "cooldown_start");
    int time_now = NWNX_Time_GetTimeStamp();

    return time_now - cooldown_start <= 900;
}


string GetResRefVarPrefix(object area)
{
    int spawns_vary = GetLocalInt(area, "spawns_vary");
    if(!spawns_vary) return "day_spawn";

    // If night time, spawn night spawns. Else spawn day spawns.
    int current_time = GetTimeHour();
    int night_spawns = current_time <= 6 || current_time >= 18;

    if(night_spawns == TRUE)
    {
        return "night_spawn";
    }
    else
    {
        return "day_spawn";
    }
}

void SpawnCreatures(object area, int should_double_spawn)
{
    int numberOfVariables = NWNX_Object_GetLocalVariableCount(area);
    int max_spawns = GetMaxSpawns(area);

    location spawn_point = GetLocation(GetNearestObjectByTag(Spawnpoint, OBJECT_SELF));

    int index = 0;

    while(index < numberOfVariables && index < max_spawns)
    {
        struct NWNX_Object_LocalVariable variable = NWNX_Object_GetLocalVariable(area, index);

        int variable_is_spawner = GetStringLeft(variable.key, GetStringLength(Prefix)) == Prefix;
        if(variable_is_spawner)
        {
                string resref = GetLocalString(area, variable.key);
                CreateObject(OBJECT_TYPE_CREATURE, resref, spawn_point);
                if(should_double_spawn)
                {
                    CreateObject(OBJECT_TYPE_CREATURE, resref, spawn_point);
                }
        }

        index++;
    }

    SetLocalInt(OBJECT_SELF, "cooldown_start", NWNX_Time_GetTimeStamp());
}

int GetMaxSpawns(object area)
{
    return d4() + 2;
}

int GetNumberOfPlayersInParty(object player)
{
    int party_members = 0;
    object party_member =  GetFirstFactionMember(player);

    while(GetIsObjectValid(party_member))
    {
        party_members++;

        party_member = GetNextFactionMember(player);
    }

    return party_members;*/
}
