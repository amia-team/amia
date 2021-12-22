// Generic OnUsed event script to have PC sit on object.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 11/30/2003 jpavelch         Initial Release.
// 2005/02/15 jking            Prefer to use standard script instead.
//

void main()
{
    ExecuteScript("x2_plc_used_sit", OBJECT_SELF);
}

