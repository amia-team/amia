/*
   Craft Magical Arms Workbench closing script
   - Maverick00053 2/20/24

*/


void LaunchConvo( object oPLC, object oPC);

void main()
{
    object oPLC = OBJECT_SELF;
    object oPC = GetLastClosedBy();

    if(GetIsObjectValid(GetFirstItemInInventory(oPLC)))
    {
     LaunchConvo(oPLC, oPC);
    }
}


void LaunchConvo( object oPLC, object oPC)
{
    SetLocalString(oPC,"ds_action","cmaworkbench_fn");
    AssignCommand(oPLC, ActionStartConversation(oPC, "c_cmaworkbench", TRUE, FALSE));
}
