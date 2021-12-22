#include "x2_inc_switches"


void main()
{
    int modEvent = GetUserDefinedItemEventNumber();
    int scriptResult = X2_EXECUTE_SCRIPT_END;

    switch(modEvent)
    {
        case X2_ITEM_EVENT_ACTIVATE:
            object spellTarget = GetItemActivatedTarget();
            object item = GetItemActivated();
            effect stunAndImmobilize = EffectLinkEffects(EffectCutsceneImmobilize(), EffectCutsceneDominated());

            AssignCommand(spellTarget, ActionSpeakString("*A spell bathed in harsh whispers echoes outward as an unbearable sense of anguish and isolation consumes " + GetName(spellTarget) + ".*"));

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, stunAndImmobilize, spellTarget, RoundsToSeconds(4));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(31), spellTarget);
        break;
    }

    SetExecutedScriptReturnValue(scriptResult);
}
