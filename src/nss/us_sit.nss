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
        object pc    = GetLastUsedBy();
        float facing = GetFacing(OBJECT_SELF);
        location plc = GetLocation(OBJECT_SELF);

        if(facing <= 180.0){
            facing = facing + 180.0;
        }
        else{
            facing = facing - 180.0;
        }

        AssignCommand(pc, ActionMoveToLocation(plc, FALSE));
        AssignCommand(pc, ActionPlayAnimation(animation, 1.0, 3600.0));
        DelayCommand(2.5, AssignCommand(pc, SetFacing(facing)));
    }
    else{
        ExecuteScript("x2_plc_used_sit", OBJECT_SELF);
    }
}

