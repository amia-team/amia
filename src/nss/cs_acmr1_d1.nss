// Automated Character Maintenance door transition
void main(){

    // vars
    object oDoor=OBJECT_SELF;
    object oPC=GetLastUsedBy();

    // Teleport
    AssignCommand(
        oPC,
        JumpToLocation(GetLocation(GetWaypointByTag("wp_acmr_1"))));

    return;

}
