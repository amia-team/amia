// Authors: Tarnus & Angelis96
// 2018
// This script is meant to apply a regeneration and restoration effect on a PC through interaction with a PC

// Includes
#include "cs_inc_xp"
#include "amia_include"

// main
void main()
{
	//Get the person who clicked the PLC
	object oTarget = GetLastUsedBy();

	// Create Regen effect
	effect eRegen = EffectRegenerate(6, 6.0);

	//Create VFX
	effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);

	// Message sent to PC
	string sMessage = "Standing this close to the flower, you feel warmth running through your body, any wounds, dark magic and other ailments fading as you remain. However, for whatever reason, you also feel faintly melancholic for the briefest moment.";

	// Look for negative effects

	effect eBad = GetFirstEffect(oTarget);
	while(GetIsEffectValid(eBad))
	{
		if (GetEffectType(eBad) == EFFECT_TYPE_ABILITY_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_AC_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_ATTACK_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_DAMAGE_IMMUNITY_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_SAVING_THROW_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_SPELL_RESISTANCE_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_SKILL_DECREASE ||
			GetEffectType(eBad) == EFFECT_TYPE_BLINDNESS ||
			GetEffectType(eBad) == EFFECT_TYPE_DEAF ||
			GetEffectType(eBad) == EFFECT_TYPE_CURSE ||
			GetEffectType(eBad) == EFFECT_TYPE_DISEASE ||
			GetEffectType(eBad) == EFFECT_TYPE_POISON ||
			GetEffectType(eBad) == EFFECT_TYPE_PARALYZE ||
			GetEffectType(eBad) == EFFECT_TYPE_NEGATIVELEVEL)
		{
			// Effect Removal
			if (GetName(GetEffectCreator(eBad)) != "ds_norestore"){
				RemoveEffect(oTarget, eBad);
			}

		}
		eBad = GetNextEffect(oTarget);
	}
	// Apply VFX
	ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

	// racial traits & area effects as per Disco's Restoration
	ApplyAreaAndRaceEffects(oTarget);

	// Apply Regeneration
	ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRegen, oTarget);
	// Send Message to Pc
	SendMessageToPC(oTarget, sMessage);


	DelayCommand(60.0, RemoveEffect(oTarget, eRegen));

}
