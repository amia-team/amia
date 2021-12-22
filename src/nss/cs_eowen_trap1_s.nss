// Eowen's cage trap: spawns 2 cage walls at the designated waypoints
void main(){

    // vars
    object oTrap=OBJECT_SELF;
    object oPC=GetEnteringObject();
    if(GetIsPC(oPC)==FALSE){

        return;

    }

    // check spawn timer status
    if(GetLocalInt(
        oTrap,
        "spawned")==1){

        return;

    }
    else{

        AssignCommand(
            oTrap,
            SetLocalInt(
                oTrap,
                "spawned",
                1));

        DelayCommand(
            900.0,
            AssignCommand(
                oTrap,
                SetLocalInt(
                    oTrap,
                    "spawned",
                    1)));

    }

    // sound anim
    AssignCommand(
        oPC,
        PlaySound("gui_trapsetoff"));

    // inform the party they triggered a trap!
    FloatingTextStringOnCreature(
        "You triggered a trap.. cage walls close behind you!",
        oPC,
        TRUE);

    // designated waypoints
    location lWall1=GetLocation(GetWaypointByTag("cs_eowen_wp1")),lWall2=GetLocation(GetWaypointByTag("cs_eowen_wp2"));

    // spawn the cage walls
    object oWall1=CreateObject(
        OBJECT_TYPE_PLACEABLE,
        "cs_eowall_1",
        lWall1,
        FALSE);

    object oWall2=CreateObject(
        OBJECT_TYPE_PLACEABLE,
        "cs_eowall_2",
        lWall2,
        FALSE);

    // Cleanup
    DestroyObject(
        oWall1,
        890.0);

    DestroyObject(
        oWall2,
        890.0);

    return;

}
