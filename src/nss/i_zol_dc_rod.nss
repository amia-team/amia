// Created a new DM DC rod because the last one was unnecessarily convoluted.

#include "nw_i0_plot"
#include "inc_dc_api"

void main()
{
    object target = GetItemActivatedTarget();
    object user = GetItemActivator();
    object dcRod = GetItemActivated();
    location targetLocation = GetItemActivatedTargetLocation();

    object player = target != OBJECT_INVALID ? target : GetNearestCreatureToLocation(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, targetLocation);

    if(player != OBJECT_INVALID && !GetIsDM(player))
    {
        if(!GetIsPC(player))
        {
            FloatingTextStringOnCreature("Target was not a player.", user);
            return;
        }

        SetLocalObject(dcRod, "lastTarget", player);
        SetCustomToken(20659, GetName(player));
        SendMessageToPC(user, "Target has " + IntToString(GetDreamCoins(GetPCPublicCDKey(target))) + " dream coins.");
        DelayCommand( 0.5, AssignCommand(user, ActionStartConversation(user, CONV_DM_DC_ROD, TRUE, FALSE)));
    }
    else
    {
        FloatingTextStringOnCreature("Target was not a player and there were no players nearby.", user);
    }
}
