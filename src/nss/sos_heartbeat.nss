// Heartbeat event to make the summoning circles on the floor animate.
//
// Revision History
// Date       Name               Description
// ---------- ----------------   ---------------------------------------------
// 01/10/2005 jking              Initial Release
//

void main()
{
    // Only execute this while people are in the area.
    int nCount = GetLocalInt( OBJECT_SELF, "PlayerCount" );
    if ( nCount < 0 ) nCount = 0;
    if ( nCount == 0 ) return;

    // Find all the summoning circles in the area and animate them.
    object obj = GetFirstObjectInArea();
    while (GetIsObjectValid(obj)) {
        if (GetTag(obj) == "X2_PLC_SCIRCLE")
             ExecuteScript("x2_plc_used_act", obj);

        obj = GetNextObjectInArea();
    }
}
