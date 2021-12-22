// Teleport the PCs out from the Pirates Attack scenario

void main(){

    // vars
    object oCaptain=OBJECT_SELF;

    object oMod=GetModule();

    location lLoc=GetLocation(oCaptain);

    // Initial Destination
    string szDest=GetLocalString(
        oMod,
        "CS_BOATDEST");

    object oDest=GetWaypointByTag(szDest);

    location lDest=GetLocation(oDest);

    // Cycle for all PCs and Teleport them to the Initial Destination
    object oPCs=GetFirstObjectInShape(
        SHAPE_SPHERE,
        30.0,
        lLoc,
        FALSE,
        OBJECT_TYPE_CREATURE);

    while(oPCs!=OBJECT_INVALID){

        // PCs only
        if(GetIsPC(oPCs)==TRUE){

            AssignCommand(
                oPCs,
                ClearAllActions(TRUE));

            // Resurrect dead players - Incur a slight GP penalty for it
            if(GetIsDead(oPCs)==TRUE){

                // Resurrection
                ApplyEffectToObject(
                    DURATION_TYPE_INSTANT,
                    EffectResurrection(),
                    oPCs,
                    0.0);


                // GP Penalty
                TakeGoldFromCreature(
                    300,
                    oPCs,
                    TRUE);

            }

            DelayCommand(
                1.0,
                AssignCommand(
                    oPCs,
                    JumpToLocation(lDest)));

        }

        oPCs=GetNextObjectInShape(
            SHAPE_SPHERE,
            30.0,
            lLoc,
            FALSE,
            OBJECT_TYPE_CREATURE);

    }

    return;

}
