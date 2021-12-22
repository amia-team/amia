// Conversation action: climb up from forest shrine to sanctuary of CoB
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 2005/02/12 jking            Initial Release.
//

void main()
{
    object oPC = GetPCSpeaker();

    AssignCommand(oPC, ClearAllActions());

    object oTarget;
    location lTarget;
    oTarget = GetWaypointByTag("a13_mir_san_climb_up");
    lTarget = GetLocation(oTarget);

    DelayCommand(1.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
}

