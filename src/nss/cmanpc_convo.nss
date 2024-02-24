/*
   CMA Crafting Dialogue Luanch Script

  - Maverick00053  02/20/24

*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"

// Launches the Convo Function
void LaunchConvo( object oNPC, object oPC);

// Sets which NPC or PLC type you are talking to
void SetChecks(object oPC, object oNPC);

void main()
{
    object oNPC = OBJECT_SELF;
    object  oPC = GetLastSpeaker();
    object oDoor;

    DeleteLocalInt(oPC,"ds_check_1");
    DeleteLocalInt(oPC,"ds_check_2");

    // SetChecks(oPC,oNPC);

    DeleteLocalInt( oPC, "ds_node");
    DeleteLocalString( oPC, "ds_action");
    LaunchConvo(oNPC,oPC);
}

void SetChecks(object oPC, object oNPC)
{
}

void LaunchConvo( object oNPC, object oPC)
{
  AssignCommand(oNPC, ActionStartConversation(oPC, "c_cmanpc", TRUE, FALSE));
}
