#include "class_effects"
#include "nwnx_events"
#include "amia_include"

// Edit: Mav - 11/25/2023 - Defender Stance Cooldown
// Mav 12/15/2023 - Added in No Poly Defensive Stance
void main()
{
    switch(StringToInt(NWNX_Events_GetEventData("COMBAT_MODE_ID")))
    {
        case 11: if(GetIsPolymorphed(OBJECT_SELF)==TRUE){SendMessageToPC(OBJECT_SELF,"You cannot enter Defensive Stance while polymorphed!");DelayCommand(0.5,SetActionMode(OBJECT_SELF,12,FALSE));}else if(GetLocalInt(OBJECT_SELF,"dwdcooldown")==0){ApplyDefenderEffects(OBJECT_SELF);SendMessageToPC(OBJECT_SELF,"Defensive Stance Enabled!");}else{SendMessageToPC(OBJECT_SELF,"You must wait a full round before reenabling Defenders Stance");DelayCommand(0.5,SetActionMode(OBJECT_SELF,12,FALSE));} break;
        default: break;
    }


}
