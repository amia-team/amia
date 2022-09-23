#include "inc_ds_records"
#include "inc_ds_porting"

void main()
{
    // Feature flag check to see if returning to the last logged in location is enabled
    if(NWNX_Util_GetEnvironmentVariable("SERVER_MODE") == "live") {
        return;
    }

    string LOGOUT_LOCATION = "LOGOUT_LOCATION";
    object oPC = GetLastUsedBy();
    object oPCKey = GetPCKEY(oPC);

    location rLoc = GetLocalLocation(oPCKey, LOGOUT_LOCATION);

    if (GetAreaFromLocation(rLoc) == OBJECT_INVALID) {
        SendMessageToPC(oPC,"Error, no location recorded to return to.");
        return;
    }
    DeleteLocalLocation(oPCKey,LOGOUT_LOCATION);
    //ActionJumpToLocation(rLoc);
    //MoveAssociates(oPC,GetAreaFromLocation(rLoc));
    AssignCommand( oPC, JumpToObject( GetAreaFromLocation(rLoc) ) );
    AssignCommand( oPC, ActionJumpToLocation(rLoc) );
}

void storeLocation(object oPC, object oArea) {
    int SAVE_LOCATION = TRUE;
    int SAVE_LOCATION_SAFE_ONLY = TRUE;
    string LOGOUT_LOCATION = "LOGOUT_LOCATION";
    string RETURN_NO_SET = "RETURN_NO_SET";
    //string RETURN_SPAWN_CHECK = "day_spawn1";

    if (SAVE_LOCATION == TRUE) {
        object oPCKey = GetPCKEY(oPC);

        location logloc = GetLocation(oPC);
        int iNoCasting = GetLocalInt(oArea, RETURN_NO_SET);
        if (iNoCasting == FALSE) {
            int hasspawns = FALSE;
            string spawnset = GetLocalString(GetArea(oPC), "day_spawn1");
            if (spawnset == "") {
                spawnset = GetLocalString(GetArea(oPC), "night_spawn1");
            }
            if (spawnset != "") {
                hasspawns = TRUE;
            }
            if (SAVE_LOCATION_SAFE_ONLY == TRUE && hasspawns == TRUE) {
                hasspawns = TRUE;
            } else {
                SetLocalLocation(oPCKey, LOGOUT_LOCATION, logloc);
            }
        }
    }
}