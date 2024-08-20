#include "nw_i0_tool"

void main()
{
    string sSafeKey = GetLocalString(OBJECT_SELF, "SafeKey");
    object oPC = GetEnteringObject();
    int nItemFound = FALSE;

    // Check to see if the PC has an item that allows them safe passage from spawns
    if( GetIsPC(oPC) )
    {
        if (sSafeKey != "" && HasItem(oPC, sSafeKey))
        {
            nItemFound = TRUE;
        }
    }

    if (nItemFound == FALSE){ ExecuteScript("ds_db_spawner", OBJECT_SELF); }
    else { return; }
}
