/*
    Corruption Orb Convo Launch

  - Maverick00053 - 12/13/2023
*/

#include "x2_inc_switches"
#include "inc_ds_records"
#include "x0_i0_campaign"
#include "inc_ds_actions"

// Launches the Convo Function
void LaunchConvo( object oOrb, object oPC);

void main()
{
    object oOrb = OBJECT_SELF; // This is the Orb of corruption
    object oPC = GetItemActivator();
    object oDoor;
    int nPaladin = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
    int nLevel = GetLevelByPosition(1,oPC) + GetLevelByPosition(2,oPC) + GetLevelByPosition(3,oPC);

    if(nPaladin >= 1)
    {
      SendMessageToPC(oPC,"*You feel evil, and darkness fill you as you touch the orb. As the corruption tries to take you, your body heats up and you feel divine energy enter your body, stopping and then removing the corruption. Praise be to your god.*");
      return;
    }

    clean_vars(oPC,4);
    LaunchConvo(oOrb,oPC);
}

void LaunchConvo( object oOrb, object oPC)
{
    SetLocalString(oPC,"ds_action","corruption_orb_f");
    AssignCommand(oPC, ActionStartConversation(oPC, "c_convo_cptorb", TRUE, FALSE));
}


