#include "x2_inc_switches"

void main()
{
    int modEvent = GetUserDefinedItemEventNumber();
    int scriptResult = X2_EXECUTE_SCRIPT_END;
    switch(modEvent)
    {
        case X2_ITEM_EVENT_ACTIVATE:
            object plcToDestroy = GetItemActivatedTarget();

            if(GetTag(plcToDestroy) == "jes_ill_plc")
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(47), plcToDestroy);
                DestroyObject(plcToDestroy);
            }
        break;
    }

    SetExecutedScriptReturnValue(scriptResult);
}
