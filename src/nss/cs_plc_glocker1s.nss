// Gnomish-style Door Locker: Locks/Unlocks the nearest door with a tag = "gnome_door"
void main(){

    // vars
    object oLever=OBJECT_SELF;
    object oDoor=GetNearestObjectByTag(
        "gnome_door",
        oLever,
        1);

    // anim
    AssignCommand(
        oLever,
        PlayAnimation(
            ANIMATION_PLACEABLE_ACTIVATE,
            1.0,
            1.0));

    DelayCommand(
        1.0,
        AssignCommand(
            oLever,
            PlayAnimation(
                ANIMATION_PLACEABLE_DEACTIVATE,
                1.0,
                1.0)));

    // door acquired
    if(oDoor!=OBJECT_INVALID){

        // resolve locked status
        if(GetLocked(oDoor)==TRUE){

            // locked, unlock
            SetLocked(
                oDoor,
                FALSE);

            // open her up
            AssignCommand(
                oDoor,
                ActionOpenDoor(oDoor));

        }
        else{

            // shut her
            AssignCommand(
                oDoor,
                ActionCloseDoor(oDoor));

            // lock her
            SetLocked(
                oDoor,
                TRUE);

        }

    }

    return;

}
