/*
    Description: This script handles launching the DC

    Author: ZoltanTheRed
    Author's note: Created a new DM DC rod because the last one was unnecessarily convoluted.
    Date Last Modified: 21 June 2020
*/

#include "nw_i0_plot"
#include "inc_dc_api"

void main()
{
    object target = GetItemActivatedTarget();
    object user = GetItemActivator();
    object dcRod = GetItemActivated();
    location targetLocation = GetItemActivatedTargetLocation();

    if(!GetIsPC(target))
    {
        // Target was neither self nor another player. Exit script.
        FloatingTextStringOnCreature("Target was not a player.", user);
        return;
    }

    if(user == target)
    {
        int dreamCoins = GetDreamCoins(GetPCPublicCDKey(user));
        SendMessageToPC(user, "You currently have " + IntToString(dreamCoins) + " dreamcoins.");
        WriteTimestampedLogEntry("Retrieved dreamcoins from " + GetName(user));
        DelayCommand(0.5, AssignCommand(user, ActionStartConversation(user, CONV_PC_DC_ROD, TRUE, FALSE)));
        WriteTimestampedLogEntry("Opened DC dialogue for player.");
    }
    else
    {
        SendMessageToAllDMs(GetName(user) + " has recommended " + GetName(target) + " for good roleplay!");
        FloatingTextStringOnCreature("You have recommended " + GetName(target) + " for good roleplay.", user, FALSE);
    }
}
