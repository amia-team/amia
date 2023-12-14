/*
   Actland dialogue for Naomi to let people into the epic hunting grounds

  - Maverick00053  11/23/2023

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

    SetChecks(oPC,oNPC);
    DeleteLocalInt( oPC, "ds_node");
    DeleteLocalString( oPC, "ds_action");
    LaunchConvo(oNPC,oPC);
}

void SetChecks(object oPC, object oNPC)
{
    string nAlignment = GetAlignmentString(oPC);

    if((nAlignment=="LG") || (nAlignment=="NG") || (nAlignment=="CG"))
    {
      SetLocalInt(oPC,"ds_check_1",1);
    }
    else if((nAlignment=="LE") || (nAlignment=="NE") || (nAlignment=="CE"))
    {
      SetLocalInt(oPC,"ds_check_2",1);
    }
    else
    {
      SetLocalInt(oPC,"ds_check_1",1);
      SetLocalInt(oPC,"ds_check_2",1);
    }
}

void LaunchConvo( object oNPC, object oPC)
{
  AssignCommand(oNPC, ActionStartConversation(oPC, "c_actdung_convo", TRUE, FALSE));
}
