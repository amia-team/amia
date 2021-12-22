#include "class_effects"
#include "nwnx_events"


void main()
{

    switch(StringToInt(NWNX_Events_GetEventData("COMBAT_MODE_ID")))
    {
        case 11:
            ApplyDefenderEffects(OBJECT_SELF);
            break;
        default: break;
    }
}
