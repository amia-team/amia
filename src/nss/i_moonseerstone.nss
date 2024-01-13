//::///////////////////////////////////////////////
//:: Spawn PLC
//:: i_moonseer
//:: acts as t1k_spawnplc
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
    string SPAWNPLC_WAYPOINT = "SpawnPoint";
    string SPAWNPLC_PLC = "SpawnPLC";
    string SPAWNPLC_SPAWNED = "HasSpawned";
    string SPAWNPLC_OBJ = "SpawnPLCObjRef";
    string SPAWNPLC_COUNT = "SpawnAmt";

    int iAmt = GetLocalInt(OBJECT_SELF,SPAWNPLC_COUNT);
    if (iAmt == 0) {
        string sPLC = GetLocalString(OBJECT_SELF,SPAWNPLC_PLC);
        string sWaypoint = GetLocalString(OBJECT_SELF,SPAWNPLC_WAYPOINT);
        location lPLC = GetLocation(GetWaypointByTag(sWaypoint));

        int iSpawned = GetLocalInt(OBJECT_SELF,SPAWNPLC_SPAWNED);
        if (iSpawned == TRUE) {
            SetLocalInt(OBJECT_SELF,SPAWNPLC_SPAWNED,FALSE);
            DestroyObject(GetLocalObject(OBJECT_SELF,SPAWNPLC_OBJ));
            DeleteLocalObject(OBJECT_SELF,SPAWNPLC_OBJ);
            //DestroyObject(GetNearestObjectToLocation(OBJECT_TYPE_PLACEABLE,lPLC));
        } else {
            object oPLC = CreateObject(OBJECT_TYPE_PLACEABLE,sPLC,lPLC,FALSE,"");
            SetLocalInt(OBJECT_SELF,SPAWNPLC_SPAWNED,TRUE);
            SetLocalObject(OBJECT_SELF, SPAWNPLC_OBJ, oPLC);
        }
    } else {
        // Section if multiple PLCs are to be spawned.
        int loop;
        int iSpawned = GetLocalInt(OBJECT_SELF,SPAWNPLC_SPAWNED);
        for (loop = 1; loop <= iAmt; loop++) {
            string sPLC = GetLocalString(OBJECT_SELF,SPAWNPLC_PLC + IntToString(loop));
            string sWaypoint = GetLocalString(OBJECT_SELF,SPAWNPLC_WAYPOINT + IntToString(loop));
            location lPLC = GetLocation(GetWaypointByTag(sWaypoint));
            string sPlcObjRef = SPAWNPLC_OBJ + IntToString(loop);

            if (iSpawned == TRUE) {
                DestroyObject(GetLocalObject(OBJECT_SELF,sPlcObjRef));
                DeleteLocalObject(OBJECT_SELF,sPlcObjRef);
            } else {
                object oPLC = CreateObject(OBJECT_TYPE_PLACEABLE,sPLC,lPLC,FALSE,"");
                SetLocalObject(OBJECT_SELF, sPlcObjRef, oPLC);
            }
        }
        if (iSpawned == TRUE) {
            SetLocalInt(OBJECT_SELF,SPAWNPLC_SPAWNED,FALSE);
        } else {
            SetLocalInt(OBJECT_SELF,SPAWNPLC_SPAWNED,TRUE);
        }
    }
}
