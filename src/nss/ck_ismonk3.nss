//::///////////////////////////////////////////////
//:: FileName ck_ismonk3
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 12/02/2006 16:55:09
//:://////////////////////////////////////////////
int StartingConditional()
{

	// Restrict based on the player's class
	int iPassed = 0;
	if(GetLevelByClass(CLASS_TYPE_MONK, GetPCSpeaker()) >= 3)
		iPassed = 1;
	if(iPassed == 0)
		return FALSE;

	return TRUE;
}
