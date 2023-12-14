#include "class_effects"
#include "nwnx_events"

// Edit: Mav - 11/25/2023 - Defender Stance Cooldown
void main()
{

    switch(StringToInt(NWNX_Events_GetEventData("COMBAT_MODE_ID")))
    {
        case 11: RemoveDefenderEffects(OBJECT_SELF); SetLocalInt(OBJECT_SELF,"dwdcooldown",1); DelayCommand(6.0,DeleteLocalInt(OBJECT_SELF,"dwdcooldown")); break;
        default: break;
    }
}
