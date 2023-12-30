/*
  Dungeon Dynamic Tool set convo system for NPCs and PLCs

  - Maverick00053  11/23/2023

*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_ds_actions"

// Launches the Convo Function
void LaunchConvo( object oNPC_PLC, object oPC);

// Sets which NPC or PLC type you are talking to
void SetChecks(object oPC, object oNPC_PLC);

void main()
{
    object oNPC_PLC = OBJECT_SELF; // This can be the NPC or PLC
    object oPC;
    object oDoor;

    if(GetObjectType(oNPC_PLC) == OBJECT_TYPE_PLACEABLE) oPC = GetLastUsedBy();  // If PLC grab PC one way
    else oPC = GetLastSpeaker();  // If not a PLC grab the PC another way

    if(GetIsPC(oPC)==FALSE)
    {
     SendMessageToPC(oPC,"Only works with players!");
     return;
    }

    if(GetLocalInt(oNPC_PLC,"blocker")==1)
    {
     SendMessageToPC(oPC,"You must wait a full 60 seconds before trying again.");
     return;
    }
    clean_vars(oPC,4);
    SetChecks(oPC,oNPC_PLC);
    DeleteLocalInt( oPC, "ds_node");
    DeleteLocalString( oPC, "ds_action");
    LaunchConvo(oNPC_PLC,oPC);
}

void SetChecks(object oPC, object oNPC_PLC)
{
    string sType = GetLocalString(oNPC_PLC,"type");
    int nLevel = GetLocalInt(oNPC_PLC,"level");
    int nDC = nLevel + 10 + (nLevel-(nLevel/3));

    //This is how we track which NPC is talking.
    if(sType == "hiddendoornpc") SetLocalInt(oPC,"ds_check_1",1);
    else if(sType == "talknpc") SetLocalInt(oPC,"ds_check_2",1);
    else if(sType == "injuriednpc") SetLocalInt(oPC,"ds_check_3",1);
    else if(sType == "lorepuzzle") SetLocalInt(oPC,"ds_check_4",1);
    else if(sType == "spellcraftumdpuzzle") SetLocalInt(oPC,"ds_check_5",1);
    else if(sType == "depressednpc") SetLocalInt(oPC,"ds_check_6",1);
    else if(sType == "appriasepuzzle") SetLocalInt(oPC,"ds_check_7",1);
    else if(sType == "summonshrine") SetLocalInt(oPC,"ds_check_8",1);
    else if(sType == "buffshrine") SetLocalInt(oPC,"ds_check_9",1);


    SetCustomToken(73333331,"(DC:"+IntToString(nDC)+ ") ");// Standard DC
    SetCustomToken(73333332,"(DC:"+IntToString(nDC-5)+ ") ");// Standard DC with adjustment of -5
    SetCustomToken(73333333,"(DC:"+IntToString(nDC-10)+ ") ");// Standard DC with adjustment of -10

}

void LaunchConvo( object oNPC_PLC, object oPC)
{

    string sType = GetLocalString(oNPC_PLC,"type");
    string sWaypoint = GetLocalString(oNPC_PLC,"waypoint");
    int nLevel = GetLocalInt(oNPC_PLC,"level");

    SetLocalString(oPC,"dungtype",sType);
    SetLocalString(oPC,"dungwaypoint",sWaypoint);
    SetLocalInt(oPC,"dunglevel",nLevel);
    SetLocalObject(oPC,"dungobject",oNPC_PLC);

    SetLocalString(oPC,"ds_action","dung_conv_finish");
    AssignCommand(oNPC_PLC, ActionStartConversation(oPC, "c_dung_convo", TRUE, FALSE));
}

