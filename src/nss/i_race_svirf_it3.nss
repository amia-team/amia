// Spell-like Ability: Camouflage
#include "x2_inc_switches"
void DoCammoflage(object oPC);
void main(){

    int nEvent=GetUserDefinedItemEventNumber();
    int nResult=X2_EXECUTE_SCRIPT_END;

    switch (nEvent)
    {

        case X2_ITEM_EVENT_ACTIVATE:{

            // vars
            object oPC=GetItemActivator();
            AssignCommand(oPC,DoCammoflage(oPC));

            break;
        }
        default:{
            break;
        }
    }
    SetExecutedScriptReturnValue(nResult);
}


void DoCammoflage(object oPC)
{

            float fDuration=TurnsToSeconds(GetHitDice(oPC) * 10);   // 1 turn per level - PoS edit: no, it's 10 turns per level!

            // Hide +10
            effect eHide_boost=EffectSkillIncrease( SKILL_HIDE, 10);

            eHide_boost=EffectLinkEffects( eHide_boost, EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE));

            // slap it on
            ApplyEffectToObject( DURATION_TYPE_TEMPORARY, eHide_boost, oPC, fDuration);

}
