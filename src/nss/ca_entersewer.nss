// Conversation action to port PC to the Cordor sewers.
//
// Revision History
// Date       Name             Description
// ---------- ---------------- ---------------------------------------------
// 02/01/2004 jpavelch         Initial Release.
//

void main()
{
    object oPC = GetPCSpeaker();
    object oWaypoint = GetObjectByTag("sewerenter");
    location lLocation = GetLocation(oWaypoint);

    SetAreaTransitionBMP(AREA_TRANSITION_CITY);

    AssignCommand(oPC,ClearAllActions());
    AssignCommand(oPC,ActionJumpToLocation(lLocation));
    AssignCommand(oPC,SetFacing(GetFacing(oWaypoint)));
}
