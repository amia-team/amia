//::///////////////////////////////////////////////
//:: FileName ck_ass1
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 29/10/2005 16:00:01
//:://////////////////////////////////////////////
int StartingConditional()
{
	if(!(GetAbilityScore(GetPCSpeaker(), ABILITY_INTELLIGENCE) > 10))
		return FALSE;

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_ASSASSIN, GetPCSpeaker()) >= 2)
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
