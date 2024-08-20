void RespawnNPC(location lRespawnLoc, json jNPC);

// Respawn_NPC script for Heist NPCs
void main()
{
    // Get the dead NPC and its location
    object oNPC = OBJECT_SELF;

    ExecuteScript("ds_ai2_death", oNPC);

    // Only trigger respawn if the RespawnRate is set
    if (GetLocalFloat(oNPC, "RespawnRate") != 0.0)
    {
        // Capture the guard's template at spawn
        json jNPC = GetLocalJson(oNPC, "NPCTemplate");

        // Get variables from NPC
        location lRespawnLoc = GetLocalLocation(oNPC, "Location");

        // Get the respawn delay set on the guard itself
        float fRespawnDelay = GetLocalFloat(oNPC, "RespawnRate");

        // Schedule the respawn
        AssignCommand(GetArea(oNPC), DelayCommand( fRespawnDelay, RespawnNPC(lRespawnLoc, jNPC)));
    }
    else
    {
        return;
    }
}

void RespawnNPC(location lRespawnLoc, json jNPC)
{
    // Create the NPC at the specified location
    object oNewNPC = JsonToObject(jNPC, lRespawnLoc, OBJECT_INVALID, TRUE );

}

