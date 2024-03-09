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
    int animation = GetLocalInt(OBJECT_SELF, "animation");

    if(animation > 0){
        location bed = GetLocation(OBJECT_SELF);
        object pc    = GetLastUsedBy();
        ActionJumpToLocation(bed);
        AssignCommand(pc, SetFacing(1.0));
        AssignCommand(pc, ActionPlayAnimation(animation, 1.0, 3600.0));
    }
    else{
        ExecuteScript("x2_plc_used_sit", OBJECT_SELF);
    }
}

