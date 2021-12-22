// Automated Character Maintenance door transition from OOC room

// Includes
#include "area_constants"

void main(){

    // vars
    object oPLC=GetObjectByTag("cs_phylactery1");
    object oArea=GetArea(oPLC);
    object oPC=GetClickingObject();

    if(GetPlayerCountInSpecificArea(oArea)>0){

        FloatingTextStringOnCreature(
            "- Someone is already using the Automated Character Maintenance Demiplane. Please try again later. -",
            oPC,
            FALSE);

        return;

    }

    // Teleport
    AssignCommand(
        oPC,
        JumpToLocation(GetLocation(GetWaypointByTag("wp_acmr_2"))));

    return;

}
