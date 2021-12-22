#include "nw_i0_spells"
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
            location casterLocation = GetLocation(caster);


            int casterNotSelectedAndTargetIsCreature = (caster == OBJECT_INVALID) && (GetItemActivatedTarget() != OBJECT_INVALID) && (GetObjectType(GetItemActivatedTarget()) == OBJECT_TYPE_CREATURE);

            if(casterNotSelectedAndTargetIsCreature)
            {
                SetLocalObject(item, CASTER, GetItemActivatedTarget());
                caster = GetLocalObject(item, CASTER);
                FloatingTextStringOnCreature("Death Spell is set to " + GetName(caster) + ".", GetItemActivator(), FALSE);
                return;
            }


            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(686), caster);

            AssignCommand(caster, ActionSpeakString("*" + GetName(caster) + " raises a crystal teeming with magic high into the air. A powerful spell is unleashed!*"));

            object spellTarget = GetFirstObjectInShape(SHAPE_SPHERE, 20.0, casterLocation);

            int saveDc = 46;

            while(GetIsObjectValid(spellTarget))
            {
                if(GetIsReactionTypeHostile(spellTarget, caster) && spellTarget != caster)
                {
                    int savingThrowFailed = !MySavingThrow(SAVING_THROW_FORT, spellTarget, saveDc, SAVING_THROW_TYPE_SPELL, caster);

                    if(savingThrowFailed)
                    {
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(144), spellTarget);
                        DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), spellTarget));
                        DelayCommand(3.0f, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH), spellTarget));
                    }
                }
                spellTarget = GetNextObjectInShape(SHAPE_SPHERE, 20.0, casterLocation);

            }
        break;
    }

    SetExecutedScriptReturnValue(scriptResult);
}
