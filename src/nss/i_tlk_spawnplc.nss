//::///////////////////////////////////////////////
//:: Spawn PLC
//:: i_tlk_spawnplc
//:: acts as t1k_spawnplc, from an item
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: The1Kobra
//:: Created On: 11/04/2021
//:://////////////////////////////////////////////

// Explanation:
// This script is used to spawn a PLC and despawn it on a second use, or do so
// for multiple PLCs.

// To use for a single PLC, the object must have these local variables set:
// SpawnPoint - Reference to a waypoint to spawn the PLC at
// SpawnPLC - Reference to the PLC being spawned.

// To use for multiple PLCs, the object must have these local variables set:
// SpawnAmt - Amount of objects to set
// SpawnPLC1 - Reference to the first PLC being spawned
// SpawnPLC2 - Reference to the first PLC being spawned
// SpawnPLC3 - Reference to the first PLC being spawned
// SpawnPoint1 - Reference to the first waypoint to spawn the PLC at
// SpawnPoint2 - Reference to the second waypoint to spawn the PLC at
// SpawnPoint3 - Reference to the third waypoint to spawn the PLC at
// Etc, keep adding to add more and more references to use.

void main() {
    object spawner           = GetItemActivated();
    string SPAWNPLC_WAYPOINT = "SpawnPoint";
    string SPAWNPLC_PLC      = "SpawnPLC";
    string SPAWNPLC_SPAWNED  = "HasSpawned";
    string SPAWNPLC_OBJ      = "SpawnPLCObjRef";
    string SPAWNPLC_COUNT    = "SpawnAmt";

    int iAmt = GetLocalInt(spawner,SPAWNPLC_COUNT);
    if (iAmt == 0) {
        string sPLC = GetLocalString(spawner,SPAWNPLC_PLC);
        string sWaypoint = GetLocalString(spawner,SPAWNPLC_WAYPOINT);
        location lPLC = GetLocation(GetWaypointByTag(sWaypoint));

        int iSpawned = GetLocalInt(spawner,SPAWNPLC_SPAWNED);
        if (iSpawned == TRUE) {
            SetLocalInt(spawner,SPAWNPLC_SPAWNED,FALSE);
            DestroyObject(GetLocalObject(spawner,SPAWNPLC_OBJ));
            DeleteLocalObject(spawner,SPAWNPLC_OBJ);
            //DestroyObject(GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE,lPLC));
        } else {
            object oPLC = CreateObject(OBJECT_TYPE_PLACEABLE,sPLC,lPLC,FALSE,"");
            SetLocalInt(spawner,SPAWNPLC_SPAWNED,TRUE);
            SetLocalObject(spawner, SPAWNPLC_OBJ, oPLC);
        }
    } else {
        // Section if multiple PLCs are to be spawned.
        int loop;
        int iSpawned = GetLocalInt(spawner,SPAWNPLC_SPAWNED);
        for (loop = 1; loop <= iAmt; loop++) {
            string sPLC = GetLocalString(spawner,SPAWNPLC_PLC + IntToString(loop));
            string sWaypoint = GetLocalString(spawner,SPAWNPLC_WAYPOINT + IntToString(loop));
            location lPLC = GetLocation(GetWaypointByTag(sWaypoint));
            string sPlcObjRef = SPAWNPLC_OBJ + IntToString(loop);

            if (iSpawned == TRUE) {
                DestroyObject(GetLocalObject(spawner,sPlcObjRef));
                DeleteLocalObject(spawner,sPlcObjRef);
            } else {
                object oPLC = CreateObject(OBJECT_TYPE_PLACEABLE,sPLC,lPLC,FALSE,"");
                SetLocalObject(spawner, sPlcObjRef, oPLC);
            }
        }
        if (iSpawned == TRUE) {
            SetLocalInt(spawner,SPAWNPLC_SPAWNED,FALSE);
        } else {
            SetLocalInt(spawner,SPAWNPLC_SPAWNED,TRUE);
        }
    }
}
