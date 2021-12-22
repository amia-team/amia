//::///////////////////////////////////////////////
//:: OnUse: Sit
//:: x2_plc_used_sit
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Simple script to make the creature using a
    placeable sit on it

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-18
//:://////////////////////////////////////////////

// Modified (kfw: 12.23.05) - PC will face the direction that the invisible object and/or PLC is facing

void main(){

    // vars
    object oChair=OBJECT_SELF;
    object oPC=GetLastUsedBy();

    // Resolve seating status
    if(!GetIsObjectValid(GetSittingCreature(oChair))){

        // Initiate sitting
        AssignCommand(
            oPC,
            ActionSit(oChair));

        // Bump the PC's facing so it'll default to the PLC's facing
        AssignCommand(
            oPC,
            SetFacing(1.0));

    }

    return;

}
