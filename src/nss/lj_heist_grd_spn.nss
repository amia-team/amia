void main(){

    object oNPC = OBJECT_SELF;
    location lGuardLoc  = GetLocation(oNPC);
    float fGuardFacing  = GetFacing(oNPC);
    json jNPC = ObjectToJson(oNPC, TRUE);
    string sSpottedText = GetLocalString(oNPC, "SpottedText");
    string sCaughtText = GetLocalString(oNPC, "CaughtText");
    string sEscapeMessage = GetLocalString(oNPC, "EscapeMessage");
    string sCaughtMessage = GetLocalString(oNPC, "CaughtMessage");

    int nSightLevel = GetLocalInt(oNPC, "SightLevel");
    int nSpawnVFX = GetLocalInt(oNPC, "SpawnVFX");
    int nWalkScript = GetLocalInt(oNPC, "Walkscript"); // NEW: Check for Walkscript variable

    // Assign sight buff based on variable; 1 = See Invisibility; 2 = Ultravision; 3 = Amia True Seeing; 4 = Bioware Trueseeing
    effect eSight;
    if (nSpawnVFX != 0)
    {
        if( nSightLevel == 1)      { eSight = EffectSeeInvisible(); }
        else if( nSightLevel == 2) { eSight = EffectUltravision(); }
        else if( nSightLevel == 3) { eSight = EffectLinkEffects(EffectUltravision(), EffectSeeInvisible()); }
        else if( nSightLevel == 4) { eSight = EffectTrueSeeing(); }
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSight, oNPC);
    }

    // Create a VFX based on value provided on NPC's variable
    if ( nSpawnVFX != 0) { ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(nSpawnVFX), oNPC); }

    // If messages are unassigned, set some default ones
    if( sSpottedText == "") { SetLocalString(oNPC, "SpottedText", "Intruder!"); }
    if( sCaughtText == "") { SetLocalString(oNPC, "CaughtText", "Caught you!"); }
    if( sEscapeMessage == "") { SetLocalString(oNPC, "EscapeMessage", "You've managed to escape the guard."); }
    if( sCaughtMessage == "") { SetLocalString(oNPC, "CaughtMessage", "You've been kicked out!"); }

    SetLocalJson(oNPC, "NPCTemplate", jNPC);
    SetLocalLocation(oNPC, "Location", lGuardLoc);
    SetLocalFloat(oNPC, "Facing", fGuardFacing);

    // Execute walk script if Walkscript variable is 1
    if (nWalkScript == 1)
    {
        ExecuteScript("j_ai_walkwaypoin", oNPC);
    }

    ExecuteScript("ds_ai2_spawn");
    return;

}

