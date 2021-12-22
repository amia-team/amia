#include "x2_inc_switches"

const string CASTER = "zol_caster";

void main()
{
    int modEvent = GetUserDefinedItemEventNumber();
    int scriptResult = X2_EXECUTE_SCRIPT_END;

    switch(modEvent)
    {
        case X2_ITEM_EVENT_ACTIVATE:
            object item = GetItemActivated();
            object caster = GetLocalObject(item, CASTER);
            location blinkPoint = GetItemActivatedTargetLocation();

            int casterNotSelectedAndTargetIsCreature = (caster == OBJECT_INVALID) && (GetItemActivatedTarget() != OBJECT_INVALID) && (GetObjectType(GetItemActivatedTarget()) == OBJECT_TYPE_CREATURE);

            if(casterNotSelectedAndTargetIsCreature)
            {
                SetLocalObject(item, CASTER, GetItemActivatedTarget());
                caster = GetLocalObject(item, CASTER);
                FloatingTextStringOnCreature("Blinker is set to " + GetName(caster) + ".", GetItemActivator(), FALSE);
                return;
            }

            if(caster != OBJECT_INVALID)
            {
                ChangeToStandardFaction(caster, STANDARD_FACTION_DEFENDER);
                AssignCommand(caster, ClearAllActions(TRUE));
                DelayCommand(1.0, AssignCommand(caster, JumpToLocation(blinkPoint)));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(254), caster);
                ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(254), blinkPoint);
                ChangeToStandardFaction(caster, STANDARD_FACTION_HOSTILE);
            }
        break;
    }

    SetExecutedScriptReturnValue(scriptResult);
}
