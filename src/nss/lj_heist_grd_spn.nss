void main(){

    object oNPC = OBJECT_SELF;
    location lGuardLoc  = GetLocation(oNPC);
    float fGuardFacing  = GetFacing(oNPC);
    json jNPC = ObjectToJson(oNPC, TRUE);
    string sSpottedText = GetLocalString(oNPC, "SpottedText");
    string sCaughtText = GetLocalString(oNPC, "CaughtText");
    string sEscapeMessage = GetLocalString(oNPC, "EscapeMessage");
    string sCaughtMessage = GetLocalString(oNPC, "CaughtMessage");

    // If messages are unassigned, set some default ones
    if( sSpottedText == "") { SetLocalString(oNPC, "SpottedText", "Intruder!"); }
    if( sCaughtText == "") { SetLocalString(oNPC, "CaughtText", "Caught you!"); }
    if( sEscapeMessage == "") { SetLocalString(oNPC, "EscapeMessage", "You've managed to escape the guard."); }
    if( sCaughtMessage == "") { SetLocalString(oNPC, "CaughtMessage", "You've been kicked out!"); }

    SetLocalJson(oNPC, "NPCTemplate", jNPC);
    SetLocalLocation(oNPC, "Location", lGuardLoc);
    SetLocalFloat(oNPC, "Facing", fGuardFacing);

    ExecuteScript("ds_ai2_spawn");
    return;

}
