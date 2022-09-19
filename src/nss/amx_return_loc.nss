#include "inc_ds_records"
#include "inc_ds_porting"

void main()
{
    string LOGOUT_LOCATION = "LOGOUT_LOCATION";
    object oPC = GetLastUsedBy();
    object oPCKey = GetPCKEY(oPC);

    location rLoc = GetLocalLocation(oPCKey, LOGOUT_LOCATION);

    if (GetAreaFromLocation(rLoc) == OBJECT_INVALID) {
        SendMessageToPC(oPC,"Error, no location recorded to return to.");
        return;
    }
    DeleteLocalLocation(oPCKey,LOGOUT_LOCATION);
    ActionJumpToLocation(rLoc);

}
