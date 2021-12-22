//Name:     ms_shriek_trig
//date:     1/7/2017
//author:   msheeler

#include "amia_include"

void main()
{
    //variables
    int i;
    int nRnd;
    int nSpawns = GetLocalInt(OBJECT_SELF, "NumberOfSpawns");
    int nWaypoints = GetLocalInt(OBJECT_SELF, "NumberOfSpawnPoints");

    object oPC = GetEnteringObject();

    location lSpawnPoint;

    //DM spawnblock
    int nSpawnDisabled = GetLocalInt(GetArea(OBJECT_SELF), "no_spawn" );

    if(nSpawnDisabled)
    {
        return;
    }

    if (GetIsPC(oPC))
    {
        //If the spawn trigger is blocked then send message to PCs
        if(GetIsBlocked(OBJECT_SELF) > 0 )
        {
            SendMessageToPC( oPC, "*There are signs of recent fighting here...*" );
            return;
        }
        if (nSpawns < 0)
        {
            nSpawns = nSpawns * -1;
            nSpawns = Random (nSpawns) +1;
        }

        for (i=0; i<nSpawns; ++i)
        {
            nRnd = Random(nWaypoints) + 1;
            lSpawnPoint = GetLocation(GetNearestObjectByTag("ShriekerSpawn", oPC, nRnd));
            object oShrieker = ds_spawn_critter (oPC, "ud_shrieker", lSpawnPoint);
        }

        //Set spawn delay so we don't spawn in shriekers over and over
        SetBlockTime(OBJECT_SELF, 15, 0);
    }
}
