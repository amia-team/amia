//::///////////////////////////////////////////////
//:: FileName ck_ass3
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 29/10/2005 16:09:43
//:://////////////////////////////////////////////
int StartingConditional()
{
	if(!(GetAbilityScore(GetPCSpeaker(), ABILITY_INTELLIGENCE) > 12))
		return FALSE;

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_ASSASSIN, GetPCSpeaker()) >= 6)
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
